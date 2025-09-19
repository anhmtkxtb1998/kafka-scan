# Scan Project

This repository contains the services that power the Kafka based scanning
pipeline.  Besides the existing IP and full-port scanners the project now ships
with an optional **vulnerability scanning worker** built on top of nmap's NSE
"vuln" scripts.

## Vulnerability scanner

The new worker lives in `scan_vulnerability/scan_vulnerability.py`.  It
consumes scan tasks from Kafka, executes nmap with the provided arguments and
publishes structured results back to Kafka.

### Configuration

Environment variables (see `.env`) control how the worker connects to Kafka and
the default nmap command line flags:

| Variable | Description | Default |
| --- | --- | --- |
| `TOPIC_VULN_TASKS` | Kafka topic that supplies scan tasks. | `scan-vuln-topic` |
| `TOPIC_VULN_RESULTS` | Kafka topic that receives scan results. | `scan-vuln-results` |
| `DEFAULT_VULN_ARGS` | Base nmap arguments.  `ports` from the task are appended if no `-p` flag is present. | `--script vuln -sV -T4 --min-rate 500 --max-retries 1` |
| `VULN_MAX_WORKERS` | Number of consumer threads to spawn. | `2` |

Each task should include at least the target `ip`. Optional fields:

- `ports`: string, number or iterable defining the port list (e.g. `"80,443"` or `[80, 443]`).
- `scan_args`: extra nmap parameters replacing the default arguments.
- `script_args`: value for `--script-args` if custom NSE arguments are needed.
- `task_id` and `ip_range_id`: opaque identifiers forwarded with the results.

### Running locally

Install dependencies with `pip install -r scan_vulnerability/requirements.txt`
and start the worker:

```bash
python scan_vulnerability/scan_vulnerability.py
```

The worker prints progress to stdout and publishes results to the configured
Kafka topic in JSON format.
