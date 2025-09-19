import os
import json
import shlex
import subprocess
import tempfile
import xml.etree.ElementTree as ET
from typing import List
from datetime import datetime
import os

def run_from_db(days: int = 7, limit: int | None = None, extra_args: str = '') -> dict:
    """Fetch IPs and ports from `scan_results` table and run vuln scans.

    - selects rows where last_scan is within `days` or all if days is None
    - groups by ip and runs nmap per ip
    """
    # lazy import to avoid hard dependency unless used
    try:
        from write_results.config import get_db_connection
    except Exception:
        try:
            from write_results.config import get_db_connection
        except Exception:
            return {"error": "DB config import failed"}

    q = "SELECT DISTINCT ip FROM scan_results WHERE status_port='open'"
    if days is not None:
        q += f" AND last_scan >= (NOW() - INTERVAL '{int(days)} days')"
    if limit:
        q += f" LIMIT {int(limit)}"

    targets = []
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(q)
            for (ip,) in cur.fetchall():
                targets.append(ip)

    if not targets:
        return {"error": "no targets from DB"}

    return run_nmap_on_targets(targets, extra_args)

try:
    from scan_vuln.config import VULN_SCAN_ARGS, VULN_SCRIPTS, TMP_OUTPUT_PREFIX
except Exception:
    from config import VULN_SCAN_ARGS, VULN_SCRIPTS, TMP_OUTPUT_PREFIX


def run_nmap_on_targets(targets: List[str], extra_args: str = '') -> dict:
    """Run nmap --script=vuln on given targets with cautious defaults.

    Returns parsed results as a dict.
    """
    if not targets:
        return {}

    target_str = ' '.join(shlex.quote(t) for t in targets)
    with tempfile.NamedTemporaryFile(prefix=os.path.basename(TMP_OUTPUT_PREFIX), suffix='.xml', delete=False) as out:
        xml_path = out.name

    # Build command
    args = f"{VULN_SCAN_ARGS} --script={VULN_SCRIPTS} {extra_args} -oX {shlex.quote(xml_path)} {target_str}"
    cmd = f"nmap {args}"

    try:
        proc = subprocess.run(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=60*30)
    except subprocess.TimeoutExpired:
        return {"error": "nmap timeout"}

    if proc.returncode not in (0, 1):
        # nmap can return 1 for host unreachable; include stderr
        return {"error": "nmap failed", "stderr": proc.stderr.decode('utf-8', errors='ignore')}

    # Parse XML
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
    except Exception as e:
        return {"error": f"parse failed: {e}"}

    results = {"scanned_at": str(datetime.utcnow()), "hosts": []}
    for host in root.findall('host'):
        addr = host.find('address')
        ip = addr.get('addr') if addr is not None else None
        host_result = {"ip": ip, "ports": [], "scripts": []}

        # parse ports
        ports = host.find('ports')
        if ports is not None:
            for p in ports.findall('port'):
                portid = p.get('portid')
                protocol = p.get('protocol')
                state = p.find('state')
                state_name = state.get('state') if state is not None else None
                service = p.find('service')
                service_name = service.get('name') if service is not None else None
                host_result['ports'].append({
                    'port': int(portid) if portid else None,
                    'protocol': protocol,
                    'state': state_name,
                    'service': service_name
                })

        # parse host-level scripts and port scripts
        for elem in host.findall('hostscript/script'):
            host_result['scripts'].append({'id': elem.get('id'), 'output': elem.get('output')})

        for ports in host.findall('ports'):
            for port in ports.findall('port'):
                for script in port.findall('script'):
                    host_result['scripts'].append({'port': port.get('portid'), 'id': script.get('id'), 'output': script.get('output')})

        results['hosts'].append(host_result)

    # cleanup xml file
    try:
        os.remove(xml_path)
    except Exception:
        pass

    return results


def run_nmap_for_ip_port(ip: str, port: int | None = None, extra_args: str = '') -> dict:
    """Convenience wrapper to run nmap against single IP and optional port.

    Returns the same dict structure as `run_nmap_on_targets`.
    """
    args = extra_args
    if port:
        args = f"-p {port} {extra_args}"
    return run_nmap_on_targets([ip], extra_args=args)


# This module is intended to be used as a library by the vuln worker and producer.
# CLI was removed because inputs are provided via Kafka/DB in the overall architecture.

