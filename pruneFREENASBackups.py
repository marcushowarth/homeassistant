#!/usr/bin/env python3
"""Retention for the Home Assistant backups copied to the NAS by rsyncBackupsToFREENAS.sh.

The rsync never deletes, so without this the NAS keeps every backup forever.
Dry run by default: lists what would go and how much space it frees.
Pass --apply to delete.

Keeps, per group:
  HA backups (*.tar):           the newest 8, plus the oldest of each of the last 6 months
  DB dumps (*.sql.gz):          the newest 30, plus the oldest of each of the last 6 months
Everything else (Zigbee/Mosquitto tarballs, the pre-cutover .sql) is left alone.
"""
import subprocess
import sys
from collections import defaultdict
from datetime import datetime

REMOTE = "marcus@172.16.10.11"
REMOTE_DIR = "/mnt/Media/Backup/homeassistant/backups"
MONTHS = 6
GROUPS = {".tar": 8, ".sql.gz": 30}


def remote(cmd, stdin=None):
    return subprocess.run(["ssh", "-o", "BatchMode=yes", REMOTE, cmd],
                          input=stdin, capture_output=True, text=True, check=True).stdout


def listing():
    out = remote(f"find {REMOTE_DIR} -maxdepth 1 -type f -printf '%T@ %s %f\\n'")
    for line in out.splitlines():
        mtime, size, name = line.split(" ", 2)
        yield datetime.fromtimestamp(float(mtime)), int(size), name


def to_delete(files, keep_newest, now):
    files = sorted(files, reverse=True)
    keep = {name for _, _, name in files[:keep_newest]}
    oldest_in_month = {}
    for when, _, name in files:
        if (now.year - when.year) * 12 + now.month - when.month < MONTHS:
            oldest_in_month[(when.year, when.month)] = name
    keep |= set(oldest_in_month.values())
    return [f for f in files if f[2] not in keep]


def main():
    apply = "--apply" in sys.argv
    now = datetime.now()
    groups = defaultdict(list)
    for f in listing():
        for suffix in GROUPS:
            if f[2].endswith(suffix):
                groups[suffix].append(f)
    doomed = []
    for suffix, keep_newest in GROUPS.items():
        files = groups[suffix]
        gone = to_delete(files, keep_newest, now)
        doomed += gone
        print(f"{suffix}: {len(files)} files, {sum(f[1] for f in files) / 1e9:.0f} GB; "
              f"delete {len(gone)} ({sum(f[1] for f in gone) / 1e9:.0f} GB), keep {len(files) - len(gone)}")
    for when, size, name in sorted(doomed):
        print(f"  {'deleting' if apply else 'would delete'} {when:%Y-%m-%d} {size / 1e9:6.1f} GB  {name}")
    print(f"Total: {len(doomed)} files, {sum(f[1] for f in doomed) / 1e9:.0f} GB"
          + ("" if apply else " (dry run, pass --apply to delete)"))
    if apply and doomed:
        remote(f"cd {REMOTE_DIR} && xargs -0 rm --", stdin="\0".join(name for _, _, name in doomed))


if __name__ == "__main__":
    main()
