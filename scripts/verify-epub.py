#!/usr/bin/env python3
"""Structural check for the generated EPUB: mimetype, container, OPF title,
manifest image count, and a sanity read of the spine. Usage:
    python3 scripts/verify-epub.py [path-to.epub]
"""
import re
import sys
import zipfile

path = sys.argv[1] if len(sys.argv) > 1 else "build/structuring-successful-dart-and-flutter-projects.epub"
ok = True

with zipfile.ZipFile(path) as z:
    names = z.namelist()

    # 1. mimetype must be first, exact, uncompressed
    mime = z.read("mimetype").decode("utf-8", "replace")
    info = z.getinfo("mimetype")
    if mime.strip() != "application/epub+zip":
        print(f"FAIL mimetype: {mime!r}")
        ok = False
    if names[0] != "mimetype" or info.compress_type != zipfile.ZIP_STORED:
        print("FAIL mimetype must be first and stored (uncompressed)")
        ok = False
    else:
        print(f"ok   mimetype ({mime.strip()}) first + stored")

    # 2. container.xml -> OPF
    try:
        container = z.read("META-INF/container.xml").decode("utf-8", "replace")
        opf = re.search(r'full-path="([^"]+\.opf)"', container).group(1)
        print(f"ok   container -> {opf}")
    except Exception as e:
        print(f"FAIL container.xml: {e}")
        ok = False
        opf = None

    # 3. OPF title + image manifest
    if opf:
        content = z.read(opf).decode("utf-8", "replace")
        title = re.search(r"<dc:title[^>]*>(.*?)</dc:title>", content, re.S)
        print(f"ok   OPF title: {title.group(1).strip() if title else '(none)'}")
        imgs = sorted(n for n in names if n.lower().endswith((".png", ".jpg", ".jpeg", ".svg")))
        print(f"ok   {len(imgs)} image(s) in package: {imgs}")

    # 4. spine has content
    content_files = [n for n in names if "/" in n and n.endswith((".xhtml", ".html"))]
    if len(content_files) < 5:
        print(f"FAIL spine looks thin: {len(content_files)} content files")
        ok = False
    else:
        print(f"ok   {len(content_files)} content files (chapters)")

    # 5. total size sanity
    total = sum(i.file_size for i in z.infolist())
    print(f"ok   uncompressed size: {total/1024:.0f} KiB")

print("VERDICT:", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
