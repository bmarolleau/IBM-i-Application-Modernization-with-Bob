# Premium Package for i Enablement website

This directory contains the independent MkDocs Material site for the approved
enablement landing page. Keep site changes inside this directory; existing lab
documents and application sources do not need to change.

**Live site:** https://bmarolleau.github.io/IBM-i-Application-Modernization-with-Bob/

## Why an HTML edit did not appear online

There are three separate copies:

| Copy | Where it lives | What changes it |
| --- | --- | --- |
| Replit canvas preview | `artifacts/mockup-sandbox/src/components/mockups/premium-enablement/Landing.tsx` in the Replit design workspace only | Editing the React component |
| MkDocs source | This directory on `main`, especially `overrides/landing-content.html` | Editing and committing the site source |
| Public website | Built HTML, CSS and images at the root of `gh-pages` | Rebuilding MkDocs and publishing the generated output |

**Saving or pushing `landing-content.html` on `main` does not publish it.**
GitHub Pages serves `gh-pages`, not the source template. There is currently no
automatic workflow that rebuilds the site after changes to `main`.

Similarly, editing the static template does not change the canvas preview, and
editing the preview does not automatically change the static template.
The preview component and the Replit export helper are not in this GitHub
repository; they belong to the separate design workspace.

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

For ordinary text or link changes, edit `overrides/landing-content.html`,
then preview, commit and publish as described below. The homepage uses that
template rather than Markdown body content from `content/index.md`.

For new styling in a GitHub-only checkout, add scoped CSS to `landing.css`.
`utilities.css` contains only the utility classes compiled from the approved
preview: adding a new utility class to HTML will not create its CSS rule.
Either regenerate the utility stylesheet from the Replit preview or use a
custom class with a rule in `landing.css`.

The custom template preserves the approved landing design. MkDocs Material
remains the configured theme for future documentation pages.

The three named learning-material links currently open the shared Box folder.
Their tooltips contain the verified filenames; they are not direct file links.
The repository workshop overview provides the broader lab catalog.

## Maintain the site from a GitHub repository checkout

Use a normal clone of
`bmarolleau/IBM-i-Application-Modernization-with-Bob`, with GitHub push access.
Run these commands from the repository root. Check `git remote -v` first:
`origin` must point to this GitHub repository, not a Replit checkpoint backup.

1. Work on `main` and get the latest source. If you edited a file through the
   GitHub website, pull that change before building locally.

   ```sh
   git checkout main
   git pull --ff-only origin main
   python -m pip install -r docs/premium-package-for-i/requirements.txt
   ```

2. Edit the source, then preview the actual MkDocs site:

   ```sh
   python -m mkdocs serve --config-file docs/premium-package-for-i/mkdocs.yml
   ```

   Check the page and links at the address printed by MkDocs. Stop the preview
   with Ctrl+C when finished.

3. Build with validation, then commit and push any new source changes:

   ```sh
   python -m mkdocs build --strict --config-file docs/premium-package-for-i/mkdocs.yml
   git add docs/premium-package-for-i/
   git commit -m "Update enablement website"
   git push origin main
   ```

   Skip the commit if the changes were already committed through GitHub.
   Generated `site/` files are ignored: do not commit them to `main`.

4. Publish deliberately:

   ```sh
   python -m mkdocs gh-deploy --strict \
     --config-file docs/premium-package-for-i/mkdocs.yml \
     --remote-name origin --remote-branch gh-pages
   ```

   This command rebuilds the site and pushes the output to `gh-pages`.
   GitHub Pages is already configured to serve that branch's root (`/`);
   do not change it to `main` or `/docs`.

5. In the repository's **Actions** tab, wait for **pages build and deployment**
   to finish, then open the live URL above. If the old version appears after a
   successful deployment, reload without cache.

Do not edit generated files directly on `gh-pages`: the next release replaces
them with a fresh build of the source.

## Synchronize changes from the Replit canvas preview

This workflow is only for the original Replit design workspace, where the
preview component and local export helper already exist.

1. Make preview changes in
   `artifacts/mockup-sandbox/src/components/mockups/premium-enablement/Landing.tsx`.
   Its scoped styles are in the adjacent `_group.css`.
2. Before exporting, reconcile any manual changes made to the static template
   on GitHub with the preview. **The exporter overwrites the static template
   and generated styles**, so unmerged static-only edits would be lost.
3. Export and build from the Replit workspace root:

   ```sh
   node .local/export-enablement.mjs
   uv run python -m mkdocs build --strict --config-file docs/premium-package-for-i/mkdocs.yml
   ```

   The helper renders the preview to `overrides/landing-content.html`, replaces
   the Replit image URL with a MkDocs asset URL, compiles `utilities.css`, and
   copies the scoped styling and Bob artwork into this site's assets.
4. Review the changed HTML/CSS and the built site, including desktop and mobile
   layouts. Preserve any manual source changes and approved resource links.
5. Transfer the changed files in this site directory to your GitHub repository
   checkout, then follow the commit-and-publish steps above. Alternatively,
   ask the Replit agent to commit the site source and publish the built output
   through the connected GitHub repository.

Do not run `gh-deploy` blindly from the design workspace: its Git remote may
be Replit's checkpoint backup rather than this GitHub repository.