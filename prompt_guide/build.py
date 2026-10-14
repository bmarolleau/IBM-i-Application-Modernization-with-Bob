#!/usr/bin/env python3
"""Build the guide.

1. Regenerates the table of contents inside bob-ppi-prompt-guide.md
   (between the <!-- toc:start --> and <!-- toc:end --> markers).
2. Generates bob-ppi-prompt-guide.html (IBM Redbooks look and feel) with pandoc.

Usage:  python3 prompt_guide/build.py      (requires pandoc)
"""
import os
import re
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
MD = os.path.join(HERE, "bob-ppi-prompt-guide.md")
HTML = os.path.join(HERE, "bob-ppi-prompt-guide.html")
TEMPLATE = os.path.join(HERE, "redbook-template.html")
TMP_MD = os.path.join(HERE, ".build-tmp.md")

TOC_START = "<!-- toc:start -->"
TOC_END = "<!-- toc:end -->"


def slug(text, seen):
    """GitHub style anchor."""
    s = re.sub(r"[`*_]", "", text).strip().lower()
    s = re.sub(r"[^\w\- ]", "", s)
    s = s.replace(" ", "-")
    n = seen.get(s, 0)
    seen[s] = n + 1
    return s if n == 0 else "%s-%d" % (s, n)


def headings(lines):
    seen = {}
    in_code = False
    out = []
    for line in lines:
        if line.startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        m = re.match(r"^(#{1,3}) (.+)$", line)
        if m:
            out.append((len(m.group(1)), m.group(2).strip(), slug(m.group(2), seen)))
    return out


def build_toc(lines):
    items = headings(lines)[1:]  # skip the document title
    toc = ["## Table of contents", ""]
    for level, text, anchor in items:
        if text.lower() == "table of contents":
            continue
        indent = "  " * (level - 1)
        toc.append("%s- [%s](#%s)" % (indent, text, anchor))
    return toc


def main():
    with open(MD, encoding="utf-8") as f:
        text = f.read()

    # 1. Markdown: regenerate the TOC between the markers
    body_lines = text.split("\n")
    toc = build_toc(
        [l for l in body_lines if not l.startswith("## Table of contents")]
    )
    block = TOC_START + "\n" + "\n".join(toc) + "\n" + TOC_END
    if TOC_START in text:
        new_text = re.sub(
            re.escape(TOC_START) + r".*?" + re.escape(TOC_END),
            lambda m: block,
            text,
            flags=re.S,
        )
    else:
        raise SystemExit("toc markers not found in " + MD)
    with open(MD, "w", encoding="utf-8") as f:
        f.write(new_text)
    print("markdown TOC updated")

    # 2. HTML: drop the title line and the TOC block (the sidebar replaces it)
    html_src = re.sub(
        re.escape(TOC_START) + r".*?" + re.escape(TOC_END) + r"\n*",
        "",
        new_text,
        flags=re.S,
    )
    html_src = re.sub(r"^# .*\n", "", html_src, count=1)
    with open(TMP_MD, "w", encoding="utf-8") as f:
        f.write(html_src)

    cmd = [
        "pandoc", TMP_MD, "-f", "gfm", "-t", "html5",
        "--template", TEMPLATE, "--toc", "--toc-depth=3",
        "-M", "pagetitle=Getting Started with IBM Bob and the Premium Package for i",
        "-M", "title=Getting Started with IBM Bob and the Premium Package for i",
        "-M", "kicker=IBM Bob Premium Package for i | Practitioner's guide",
        "-M", "subtitle=A hands-on guide for developers, green-screen programmers and administrators",
        "-o", HTML,
    ]
    subprocess.check_call(cmd)
    os.remove(TMP_MD)

    # 3. Post-process: wrap tables so they scroll on small screens
    with open(HTML, encoding="utf-8") as f:
        h = f.read()
    h = h.replace("<table>", '<div class="table-wrap"><table>').replace(
        "</table>", "</table></div>"
    )
    with open(HTML, "w", encoding="utf-8") as f:
        f.write(h)
    print("html written: " + HTML)


if __name__ == "__main__":
    main()
