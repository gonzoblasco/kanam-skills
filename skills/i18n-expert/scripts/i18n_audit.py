#!/usr/bin/env python3
"""i18n_audit.py — Audit locale files for missing keys, orphaned keys, and parity.

Usage:
  python3 i18n_audit.py --src <src-dir> --locale <locale-file> [--locale <locale-file> ...]

Scans source code for t('key') usage and compares against locale JSON files.
Reports:
- Missing keys (in source but not in locale file)
- Orphaned keys (in locale file but not in source)
- Parity gaps between locales
"""

import sys
import json
import re
import os
from pathlib import Path
from collections import defaultdict


def extract_keys_from_source(src_dir: str) -> set[str]:
    """Extract all i18n keys from source files using regex."""
    keys = set()
    src_path = Path(src_dir)

    patterns = [
        r"t\(['\"]([\w.]+)['\"]",           # t('key') or t("key")
        r"t\(['\"]([\w.]+)['\"],\s*\{",     # t('key', { ... })
        r"i18n\.t\(['\"]([\w.]+)['\"]",     # i18n.t('key')
        r"useTranslations\(\)\.\(['\"]([\w.]+)['\"]",  # next-intl
    ]

    for ext in (".ts", ".tsx", ".js", ".jsx"):
        for filepath in src_path.rglob(f"*{ext}"):
            if "node_modules" in str(filepath):
                continue
            try:
                content = filepath.read_text(encoding="utf-8")
                for pattern in patterns:
                    for match in re.finditer(pattern, content):
                        keys.add(match.group(1))
            except (UnicodeDecodeError, OSError):
                continue

    return keys


def load_locale_keys(locale_file: str) -> dict[str, str]:
    """Load all keys from a flat or nested JSON locale file."""
    keys = {}

    def flatten(obj, prefix=""):
        for key, value in obj.items():
            full_key = f"{prefix}.{key}" if prefix else key
            if isinstance(value, dict):
                flatten(value, full_key)
            else:
                keys[full_key] = str(value)

    try:
        with open(locale_file, encoding="utf-8") as f:
            data = json.load(f)
        flatten(data)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"  ⚠️  Error loading {locale_file}: {e}")

    return keys


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    src_dir = ""
    locale_files = []

    args = sys.argv[1:]
    while args:
        if args[0] == "--src" and len(args) > 1:
            src_dir = args[1]
            args = args[2:]
        elif args[0] == "--locale" and len(args) > 1:
            locale_files.append(args[1])
            args = args[2:]
        else:
            args = args[1:]

    if not src_dir or not locale_files:
        print("❌ --src and at least one --locale required")
        sys.exit(1)

    print("🔍 I18n Audit")
    print(f"   Source: {src_dir}")
    print(f"   Locales: {', '.join(locale_files)}")
    print()

    # Extract keys from source
    source_keys = extract_keys_from_source(src_dir)
    print(f"📝 Keys found in source: {len(source_keys)}")

    # Load locale files
    locale_data = {}
    for lf in locale_files:
        locale_data[lf] = load_locale_keys(lf)
        print(f"   {lf}: {len(locale_data[lf])} keys")

    print()

    # Check each locale
    all_ok = True
    for lf, locale_keys in locale_data.items():
        locale_name = Path(lf).stem
        missing = source_keys - set(locale_keys.keys())
        orphaned = set(locale_keys.keys()) - source_keys

        if missing:
            print(f"❌ {locale_name}: {len(missing)} missing keys")
            for key in sorted(missing)[:20]:
                print(f"   - {key}")
            if len(missing) > 20:
                print(f"   ... and {len(missing) - 20} more")
            all_ok = False
        else:
            print(f"✅ {locale_name}: all source keys present")

        if orphaned:
            print(f"   ⚠️  {len(orphaned)} orphaned keys (in locale but not in source)")
            for key in sorted(orphaned)[:10]:
                print(f"   - {key}")

    # Parity check (if multiple locales)
    if len(locale_files) > 1:
        print()
        print("📊 Parity check:")
        base = locale_data[locale_files[0]]
        for lf in locale_files[1:]:
            missing = set(base.keys()) - set(locale_data[lf].keys())
            if missing:
                print(f"   ⚠️  {Path(lf).stem}: {len(missing)} keys missing vs baseline")
                all_ok = False
            else:
                print(f"   ✅ {Path(lf).stem}: full parity with baseline")

    print()
    if all_ok:
        print("✅ Audit passed: all keys present and parity OK")
    else:
        print("❌ Audit failed: fix issues above")
        sys.exit(1)


if __name__ == "__main__":
    main()
