# Benutzerhandbuch

*Dies ist das Platzhalter-Handbuch des Starter-Templates. Ersetze den
Inhalt von `docs/help_de.md` / `docs/help_en.md` durch deine
Produktdokumentation — die Hilfe-Seite rendert diese Dateien direkt,
das Handbuch wird also mit der App ausgeliefert, passt immer zur
laufenden Version und funktioniert offline.*

## Erste Schritte mit diesem Template

*Dieses Kapitel dreht sich um die Einrichtung des TEMPLATE-Repositories
selbst, nicht um die Nutzung einer fertigen App — lösche es, sobald du
ein echtes Produkt ausgelieferst hast (deine Nutzer müssen nicht wissen,
was `ARB_AI_API_KEY` ist). Bis dahin ist es der schnellste Weg, nach
einem Clone oder Fork alles zum Laufen zu bringen.*

Ein paar einmalige Schritte sorgen dafür, dass jedes Feature tatsächlich
funktioniert. Die meisten sind optional — mach nur die, deren Feature du
wirklich nutzt.

1. **Appwrite-Backend.** Kopiere `config/app_config.example.json` nach
   `config/app_config.json` und trage deine Appwrite-Projektdaten ein.
   Überspringe das, um erstmal im Demo-Modus ganz ohne Backend zu erkunden.
2. **Umbenennen & Branding.** Ersetze Paketnamen, Logo und die
   Theme-Akzentfarbe — die Kurzfassung steht in der „Erste Schritte"-Karte
   auf der Home-Seite, die Langfassung im vollständigen Tutorial im README.
3. **Automatische Übersetzung (optional).** Der GitHub-Actions-Workflow
   „AI Translate ARB" benötigt einen Gemini-API-Key. Trage ihn als
   Repository-Secret namens `ARB_AI_API_KEY` unter **GitHub-Repo →
   Settings → Secrets and variables → Actions** ein, bevor du den Workflow
   ausführst.
4. **GitHub-Pages-Hosting (optional).** Um einen Web-Build über den
   mitgelieferten `gh-pages.yml`-Workflow zu veröffentlichen, aktiviere
   Pages einmalig unter **GitHub-Repo → Settings → Pages → Build and
   deployment → Source → GitHub Actions**. Danach übernimmt der Workflow
   den Rest.
5. **Die vollständige Anleitung steht im `README.md`.** Diese In-App-Seite
   deckt nur die tägliche Nutzung der laufenden App ab; Repository- und
   CI-Einrichtung ist Entwicklerdokumentation und gehört ins README, nicht
   hierher — siehe das
   [vollständige README](https://github.com/your-org/your-repo#readme)
   (ersetze diesen Link durch dein eigenes Repository — derselbe
   Platzhalter wie `githubUrl` / `editUrlBase`, siehe die
   Anpassungs-Checkliste im README).

## Das Handbuch schreiben

- Reines **Markdown**: Überschriften, Listen, Tabellen, Links,
  Codeblöcke und Bilder werden in der App gerendert.
- Eine Datei pro Sprache (`help_de.md`, `help_en.md`); die App wählt
  die zur UI-Sprache passende Datei, Fallback ist Englisch.
- Nutzerorientiert schreiben: was die App tut und wie man sie bedient —
  Entwicklerdoku gehört ins README.

## Beispielabschnitt — Häufige Fragen

**Wie ändere ich Sprache oder Design?**
Öffne **Einstellungen** in der Seitenleiste. Deine Auswahl wird im
Konto gespeichert und auf jedem Gerät wiederhergestellt.

**Wie melde ich mich ab?**
Über das Abmelden-Symbol neben deinem Namen unten in der Seitenleiste.

---

*Fehler gefunden? Über den Link „Auf GitHub bearbeiten" oben auf dieser
Seite kannst du direkt eine Änderung vorschlagen.*
