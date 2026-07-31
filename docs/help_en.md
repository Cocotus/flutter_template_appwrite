# User Manual

*This is the placeholder user manual of the starter template. Replace
the content of `docs/help_en.md` / `docs/help_de.md` with your product
documentation — the Help page renders these files directly, so the
manual ships with the app, always matches the running version and works
offline.*

## Getting started with this template

*This chapter is about setting up the TEMPLATE repository itself, not
about using a finished app — delete it once you ship a real product
(your users don't need to know what `ARB_AI_API_KEY` is). Until then, it's
the fastest way to see everything working after a clone or fork.*

A few one-time steps make every feature actually work. Most are optional —
only do the ones for features you're actually using.

1. **Appwrite backend.** Copy `config/app_config.example.json` to
   `config/app_config.json` and fill in your Appwrite project details.
   Skip this to keep exploring in Demo mode with no backend at all.
2. **Rename & rebrand.** Replace the package name, the logo, and the theme
   seed color — see the "Getting started" card on the Home page for the
   short version, or the README's full tutorial for the long one.
3. **Automated translation (optional).** The "AI Translate ARB" GitHub
   Actions workflow needs a Gemini API key. Add it as a repository secret
   named `ARB_AI_API_KEY` under **GitHub repo → Settings → Secrets and
   variables → Actions** before running that workflow.
4. **GitHub Pages hosting (optional).** To publish a web build via the
   included `gh-pages.yml` workflow, first enable it once under **GitHub
   repo → Settings → Pages → Build and deployment → Source → GitHub
   Actions**. Nothing else to configure — the workflow does the rest.
5. **The full walkthrough lives in `README.md`.** This in-app page only
   covers day-to-day usage of the running app; repository and CI setup is
   developer documentation and belongs in the README, not here — see the
   [full README](https://github.com/your-org/your-repo#readme) (replace
   this link with your own repository, same placeholder as `githubUrl` /
   `editUrlBase` — see the README's customization checklist).

## Writing the manual

- Plain **Markdown**: headings, lists, tables, links, code blocks and
  images all render in-app.
- One file per language (`help_en.md`, `help_de.md`); the app picks the
  file matching the UI language and falls back to English.
- Keep it user-facing: what the app does and how to use it — developer
  documentation belongs in the README.

## Example section — Frequently asked questions

**How do I change the language or theme?**
Open **Settings** in the sidebar. Your choices are saved to your
account and restored on every device you log in from.

**How do I log out?**
Use the logout icon next to your name at the bottom of the sidebar.

---

*Found a mistake? Use the "Edit on GitHub" link at the top of this page
to propose a change.*
