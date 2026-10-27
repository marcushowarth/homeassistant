"""Unpack an encrypted HA backup the way HA does (homeassistant/backup_restore.py,
_extract_backup), without starting HA. Used for the FARMINGTON restore drill.

Run in the HA image with no network, a folder holding the backup mounted at /drill:

  docker run --rm -it --network none --user "$(id -u):$(id -g)" \
    -v ~/drill:/drill -v "$PWD/decryptHABackup.py:/decryptHABackup.py:ro" \
    --entrypoint python3 ghcr.io/home-assistant/home-assistant:stable \
    /decryptHABackup.py /drill/backups/Automatic_backup_<...>.tar

Prompts for the backup key (from the HA emergency kit) without echo; paste once,
then Enter. Unpacks /config to /drill/ha-restore/data.
"""
import getpass
import json
import sys
import tarfile
from pathlib import Path

import securetar

backup = Path(sys.argv[1])
out = Path("/drill/ha-restore")
outer = out / "outer"
outer.mkdir(parents=True, exist_ok=True)

if not (outer / "backup.json").exists():
    with tarfile.open(backup) as t:
        t.extractall(outer, filter="tar")
meta = json.loads((outer / "backup.json").read_text())
print("backup:", meta.get("name"), "| HA", meta["homeassistant"]["version"], "| protected:", meta.get("protected"))

suffix = ".gz" if meta["compressed"] else ""
inner = outer / f"homeassistant.tar{suffix}"
# Nothing echoes while typing or pasting: paste once, then Enter.
for attempt in range(3):
    password = getpass.getpass("HA backup key: ").strip() if meta.get("protected") else None
    try:
        with securetar.SecureTarFile(inner, gzip=meta["compressed"], password=password) as istf:
            istf.extractall(path=out, filter="tar")
        break
    except securetar.InvalidPasswordError:
        print(f"Wrong key ({len(password)} characters entered), try again.")
else:
    sys.exit("Three wrong keys: the emergency kit may be out of date (see Settings > System > Backups in HA).")
inner.unlink()
print("unpacked to", out / "data")
