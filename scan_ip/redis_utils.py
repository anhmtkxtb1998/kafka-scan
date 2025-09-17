from urllib.parse import urlparse, urlunparse, quote
import redis

try:
    from scan_ip.config import REDIS_URL, REDIS_PASSWORD, REDIS_USERNAME
except Exception:
    # fallback for direct execution/import
    from config import REDIS_URL, REDIS_PASSWORD, REDIS_USERNAME


def auth_url(redis_url: str, username: str | None, password: str | None) -> str:
    """Insert username/password into `redis_url` when missing.

    Returns a URL safe to pass to `redis.Redis.from_url`.
    """
    if not password:
        return redis_url

    u = urlparse(redis_url)
    hostport = u.netloc or u.path
    if '@' in hostport:
        return redis_url

    netloc = f"{username}:{quote(password)}@{hostport}" if username else f"{quote(password)}@{hostport}"
    return urlunparse((u.scheme or "redis", netloc, u.path or "/", u.params, u.query, u.fragment))


def make_redis_clients(bot_kind: str = "scan_ip") -> tuple[redis.Redis, redis.Redis]:
    """Create (command_client, pub_client) Redis connections using env vars.

    Mirrors the behavior previously inline in `scan_ip.py`.
    """
    _rds_cmd = redis.Redis.from_url(
        auth_url(REDIS_URL, REDIS_USERNAME, REDIS_PASSWORD), decode_responses=True
    )

    _rds_pub = redis.Redis.from_url(
        auth_url(REDIS_URL, REDIS_USERNAME, REDIS_PASSWORD), decode_responses=True
    )

    try:
        _rds_cmd.ping()
        print(f"✅ Redis command OK: {REDIS_URL} (BOT_KIND={bot_kind})")
    except Exception:
        print(f"❌ Redis command failed: {REDIS_URL} (BOT_KIND={bot_kind})")

    return _rds_cmd, _rds_pub
