# Premium Package for i Enablement website

This directory contains the complete, independent MkDocs Material site for the
approved enablement landing page. Existing lab documents, application sources,
and repository settings are not changed.

## Preview locally

From the repository root, with Python 3.10 or newer:

```sh
python -m pip install -r docs/premium-package-for-i/requirements.txt
python -m mkdocs serve --config-file docs/premium-package-for-i/mkdocs.yml
```

Open the address printed by MkDocs (normally `http://127.0.0.1:8000/`).

## Build

```sh
python -m mkdocs build --strict --config-file docs/premium-package-for-i/mkdocs.yml
```

The generated static site is written to `docs/premium-package-for-i/site/`,
which is ignored by Git. The output works with a GitHub Pages project-path prefix;
there are no Replit preview URLs or React runtime dependencies.

## Edit

- `overrides/landing-content.html`: headings, resource links, lab descriptions,
  and inline decorative SVG icons.
- `overrides/landing.html`: page shell, metadata, and stylesheet references.
- `content/assets/stylesheets/landing.css`: scoped custom styling, responsive
  adjustments, accessibility, and motion preferences.
- `content/assets/stylesheets/utilities.css`: precompiled utility styles from
  the approved preview; no Node.js build is needed to serve or build this site.
- `content/assets/images/bob-premium.png`: the repository's existing Bob artwork,
  copied from `pics/image-bobppi.png`.
- `content/index.md`: page metadata selecting the dedicated landing template.
- `mkdocs.yml`: this site's isolated MkDocs configuration.

The custom template preserves the approved landing design. MkDocs Material
remains the configured theme for future documentation pages.

The three named learning-material links currently open the shared Box folder.
Their tooltips contain the verified filenames; they are not direct file links.
The repository workshop overview provides the broader lab catalog.

## GitHub Pages

This commit does **not** enable Pages, modify repository settings, or add an
automatic publishing workflow.

When publishing is approved, build with the command above and publish its
`site/` output. For example, MkDocs supports:

```sh
python -m mkdocs gh-deploy --config-file docs/premium-package-for-i/mkdocs.yml
```

That command writes the generated site to the `gh-pages` branch. It must be run
deliberately, with repository write access, and GitHub Pages must be configured
to serve that branch. Do not run it merely to preview the page.