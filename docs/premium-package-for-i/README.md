# Premium Package for i Enablement website

A static website built with [MkDocs](https://www.mkdocs.org/) and
[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

Run the commands below from the repository root with Python 3.10 or newer.

## Edit the site

Use any code editor or AI tool to modify the source files in this directory:

| File or directory | Purpose |
| --- | --- |
| `overrides/landing-content.html` | Homepage text, links and layout |
| `overrides/landing.html` | Page shell, metadata and stylesheet references |
| `content/assets/stylesheets/landing.css` | Custom styles and responsive behavior |
| `content/assets/stylesheets/utilities.css` | Precompiled utility styles |
| `content/assets/images/` | Images |
| `content/index.md` | Homepage metadata and template selection |
| `mkdocs.yml` | Site settings, navigation and theme configuration |

The homepage uses a custom HTML template. For additional documentation pages,
create Markdown files in `content/` and add them to `nav` in `mkdocs.yml`.
For new styles, add CSS rules to `landing.css`; adding a utility class to HTML
does not automatically generate its CSS.

## Install and preview

```sh
python -m pip install -r docs/premium-package-for-i/requirements.txt
python -m mkdocs serve --config-file docs/premium-package-for-i/mkdocs.yml
```

Open the local address printed by MkDocs. Changes refresh automatically.
Check the content, links and mobile layout, then stop the server with Ctrl+C.

## Build

```sh
python -m mkdocs build --strict --config-file docs/premium-package-for-i/mkdocs.yml
```

The generated website is written to `site/` inside this directory.
This output is ignored by Git; commit source files instead.

## Publish to GitHub Pages

From a checkout of this repository on `main`, commit and push your source changes:

```sh
git add docs/premium-package-for-i/
git commit -m "Update enablement website"
git push origin main
```

Verify that `origin` points to the intended GitHub repository, then publish:

```sh
python -m mkdocs gh-deploy --strict \
  --config-file docs/premium-package-for-i/mkdocs.yml \
  --remote-name origin --remote-branch gh-pages
```

This command builds the site and pushes the output to `gh-pages`.
GitHub Pages serves that branch's root (`/`). Pushing source changes to `main`
alone does not publish them; there is no automatic source-build workflow.

Wait for the Pages deployment in the repository's **Actions** tab, then check
the live site. Do not edit generated files on `gh-pages` directly: the next
publish replaces them.