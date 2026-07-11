# CLAUDE.md — Konventionen für Flutter-Projekte (Riverpod + Freezed)

Allgemeine Anweisungen für KI-Assistenten, die an **beliebigen** Flutter-Projekten
dieser Art arbeiten. Dies ist der **gemeinsame Nenner** über ähnliche Apps hinweg —
nicht an ein bestimmtes Backend oder einen bestimmten Funktionsumfang gebunden.
Kopiere die Datei in das Wurzelverzeichnis eines Flutter-Projekts und ergänze sie
um projektspezifische Hinweise (Backend, Datenmodell, Deployment) in einem eigenen
Abschnitt oder einer `AGENTS.md`.

**Wenn eine konkrete Projektregel und eine Regel hier im Widerspruch stehen,
gewinnen die projekteigenen Dokumente.** Ansonsten gilt alles Folgende.

---

## Geltungsbereich — Empfehlungen, verbindlich für Neues

Die folgenden Regeln sind **Empfehlungen / Best Practices** und **gelten
verbindlich vor allem für neue Erweiterungen** (neuer Controller, neue View, neues
Widget, neuer Service). Konkret:

- **Neuer Code MUSS konform sein.** Beispiel: Eine neue View/ein neuer Controller
  wird **ohne `StatefulWidget`/`ConsumerStatefulWidget`** geschrieben (§3), ohne
  Cascades (§1), mit den vorgesehenen Schichten und Namen.
- **Bestehender Code bleibt bestehen — mit Warnung, nicht mit stiller Umschreibung.**
  Wenn du an vorhandenen Dateien arbeitest, die gegen diese Regeln verstoßen
  (z. B. ein bestehendes `StatefulWidget`, eine Cascade, ein `TextEditingController`
  in einem Riverpod-Controller), **weise per kurzem Hinweis darauf hin**, aber baue
  sie **nicht ungefragt** um. Eine Migration erfolgt nur auf ausdrückliche Anweisung
  und in eng umrissenem Rahmen.
- **Faustregel:** Neues sauber nach diesen Regeln; Altes respektieren und lediglich
  bemängeln. So wächst das Projekt schrittweise in die Konventionen hinein, ohne dass
  Massen-Refactorings ungeplant Bestandscode aufreißen.

---

## 0. Leitprinzip

Der Code in diesen Projekten soll von einer/einem **fortgeschrittenen
Flutter-Entwickler:in** — jemand, der Dart- und Flutter-Grundlagen beherrscht und
schon Apps ausgeliefert hat, aber *kein* Experte ist und *nicht* immer auf dem
neuesten Stand der Sprachkürzel — **gelesen, verstanden und erweitert** werden können.

> **Bevorzuge expliziten, ausführlichen, „langweiligen" Code gegenüber
> cleverem/knappem Code. Lesbarkeit schlägt Kürze — jedes Mal.**

Wenn du merkst, dass du etwas schreibst, das tiefes Dart-Wissen zum Verstehen
erfordert, schreibe es auf die einfache Weise um und füge einen kurzen Kommentar hinzu.

---

## 1. Codestil (gilt für ALLEN Code)

### TUN — explizit, lesbar
- **Explizite Typen** an Variablen, Feldern, Parametern, Rückgabewerten
  (`final String email = ...;`, `Future<void> login() async { ... }`). Verlasse
  dich nicht auf `var`/Typinferenz, wenn ein ausgeschriebener Typ klarer liest.
- **Vollständige Blockrümpfe** mit `{ ... }` und `return` — keine mehrschrittigen `=>`.
- **Schrittweise Logik** mit klar benannten Zwischenvariablen statt alles in einen
  einzigen Ausdruck zu verketten.
- Klares **`if / else`** statt Ternär-Ketten, wo es die Verständlichkeit fördert.
- Kurze Kommentare, die das **Warum** erklären, nicht das Was.
- Zerlege `build`-Methoden in kleine, benannte **`Widget _buildXxx()`**-Helfer,
  damit der Baum leicht nachvollziehbar bleibt.
- Beschreibende, ausgeschriebene Namen (`isPasswordVisible`, nicht `pwv`).
- Explizites **`try / catch`**, das klar loggt und zurückgibt/weiterwirft.

### VERMEIDEN — zu clever / nur für Experten
- ❌ **Arrow-Rümpfe (`=>`) für alles Nicht-Triviale.** Ein einzeiliges `=>` ist nur
  für einen wirklich trivialen Getter/Callback in Ordnung
  (`onPressed: () => controller.submit()`). Schreibe niemals mehrschrittige Logik
  oder ganze Methoden als Arrow-Ausdruck.
- ❌ **Cascade-Operatoren (`..`).** Sie geben das *Empfängerobjekt* statt des
  Methodenergebnisses zurück, was Nicht-Experten verwirrt. **Löse jede Cascade in
  explizite Anweisungen auf einer benannten `final`-Variable auf** (Beispiel unten).
- ❌ Lange einzeilige Methodenketten (`list.where(...).map(...).toList()..sort()`).
  Zerlege sie in Schritte mit benannten Variablen.
- ❌ **Spread-Operatoren (`...`) und Collection-`if`/`for` in Widget-Listen**
  (`if (cond) ...<Widget>[a, b]`, `for (final x in xs) ...buildRow(x)`). Baue
  stattdessen eine **`final List<Widget> children = [...]`-Variable explizit
  per `if`/`for`-Block und `.add()`/`.addAll()`** auf und übergib sie an
  `children:` (Beispiel unten). Gilt auch für Map/Set-Merges
  (`<K,V>{...other, 'k': v}`) — per Schleife mit `.entries` kopieren.
- ❌ Verschachtelte Ternäre, dichte Collection-`if`/`for` in großen Widget-Bäumen.
- ❌ Übermäßige `extension`s, Records, Pattern-Matching oder brandneue Syntax, die
  nur aus Cleverness verwendet wird. Nutze ein modernes Feature nur, wenn es den
  Code für Nicht-Experten wirklich *einfacher* macht, und kommentiere es, falls es
  unbekannt sein könnte.
- ❌ Tief verschachtelte anonyme Inline-Funktionen.

### Beispiel — Blockrumpf statt Arrow

```dart
// ❌ Zu knapp / Experten-Stil:
Future<void> login(String e, String p) async =>
    state = await AsyncValue.guard(() => _auth.login(email: e, password: p));

// ✅ Explizit, dokumentiert:
/// Meldet den Benutzer mit [email] und [password] an.
Future<void> login({required String email, required String password}) async {
  state = const AsyncValue<void>.loading();
  try {
    await _auth.login(email: email, password: password);
    state = const AsyncValue<void>.data(null);
  } catch (error, stackTrace) {
    state = AsyncValue<void>.error(error, stackTrace);
  }
}
```

### Beispiel — Auflösen einer Cascade

```dart
// ❌ Cascade (`..` gibt das Objekt zurück, nicht das Methodenergebnis):
ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(snackBar);

// ✅ Explizite Anweisungen auf einer benannten Variable:
final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
messenger.hideCurrentSnackBar();
messenger.showSnackBar(snackBar);
```

### Beispiel — Auflösen eines Spreads in einer Widget-Liste

```dart
// ❌ Spread + Collection-if (unklar, was am Ende in der Liste landet):
return Column(
  children: <Widget>[
    const Icon(Icons.info),
    if (message != null) ...<Widget>[
      const SizedBox(height: 8),
      Text(message),
    ],
  ],
);

// ✅ Explizite Liste, Schritt für Schritt aufgebaut:
final List<Widget> children = <Widget>[
  const Icon(Icons.info),
];
if (message != null) {
  children.add(const SizedBox(height: 8));
  children.add(Text(message));
}
return Column(children: children);
```

### Benennung & Dokumentation (offizieller Dart-Stil)
- **Jede öffentliche API** (öffentliche Klasse/Methode/Funktion/Feld, jeder Provider,
  jedes Top-Level-Member) hat einen `///`-Doc-Kommentar, der mit einem
  Ein-Satz-Resümee beginnt.
- **Private Member (`_name`)** brauchen keinen Doc-Kommentar, aber setze ein kurzes
  `//`, wo die Absicht nicht offensichtlich ist.
- `UpperCamelCase` für Typen; `lowerCamelCase` für Member & Konstanten (NICHT
  `SCREAMING_CAPS`); `lowercase_with_underscores` für Dateien/Ordner.
- Booleans lesen sich als positive Aussagen (`isLoading`, `hasError`, `isDarkMode`).
- Bevorzuge `final` gegenüber `var`, wenn sich der Wert nicht ändert.
- Reihenfolge der Member: Konstruktoren → öffentliche Felder → öffentliche Methoden
  → private Helfer. Wo sinnvoll, eine primäre öffentliche Klasse pro Datei.

---

## 2. Architektur — View / Controller / Service / Model

Vier Schichten unter `lib/`:

- **`lib/models/`** — nur unveränderliche Datenmodelle (Freezed + `fromJson`/`toJson`).
- **`lib/views/`** — UI-Widgets, ein Unterordner pro Feature (`views/login/`, …).
  Nur UI + Verdrahtung, **keine Geschäftslogik**.
- **`lib/controllers/`** (oder eine daneben liegende `xyz_controller.dart` neben
  ihrer View) — **Logik für GENAU EINE View**: der Zustand dieser View,
  Validierung, Laden/Fehler und Aufrufe in Services.
- **`lib/services/`** — **Logik, die von vielen Views geteilt wird** (Auth, Daten,
  Theme, Logging, Config, querschneidender Zustand), als Riverpod-Provider
  bereitgestellt, wo sinnvoll als Singletons.
- **`lib/widgets/`** — wiederverwendbare, geteilte Widgets (siehe §4).
- **`lib/theme/`** — zentralisiertes Theming (siehe §5).

**Faustregel:** *Controller* = Logik **für eine View**. *Service* = Logik, die
**von vielen Views geteilt wird**.

**Schichtenregel:** Controller hängen von **Service-Schnittstellen** ab, niemals
direkt von einem rohen Backend-Client (SDK, HTTP, DB) — das hält die Schichten
sauber getrennt und leicht austauschbar (z. B. Demo-Modus, siehe
`services/demo/`). Ein **zustandsloser Service ist eine schlichte Klasse**, die
über einen `keepAlive`-Funktionsprovider bereitgestellt wird. Mache ihn nur
dann zu einer Notifier-Klasse, wenn er tatsächlich Zustand hält.

---

## 3. State-Management — Riverpod (Code-Gen) + Hooks

- **Riverpod mit Code-Generierung** (`@riverpod` / `riverpod_annotation` +
  `riverpod_generator`) ist das einzige State-Management-Framework. Füge KEIN
  zweites hinzu (BLoC/GetX/plain Provider) und verwende NICHT das veraltete
  `StateNotifier`/`ChangeNotifier`.
- **Kein `StatefulWidget` und kein `ConsumerStatefulWidget`.** Erlaubte Widget-Typen:
  - **`StatelessWidget`** — reine Präsentation, keine Logik, kein veränderlicher Zustand.
  - **`ConsumerWidget`** — liest Provider / braucht Zustand.
  - **`HookConsumerWidget`** / **`HookWidget`** — braucht Widget-gebundene Objekte
    (z. B. `TextEditingController`) oder reinen UI-Zustand via `flutter_hooks`. Das
    ist der sanktionierte Weg, Widget-Lebenszyklus-Objekte ohne ein StatefulWidget
    zu haben.
- Für jede View mit Logik oder veränderlichem Zustand: kombiniere sie mit einem
  **`@riverpod`-Controller**: `xyz_view.dart` (UI) + `xyz_controller.dart` (Logik).
- **Aller view-lokale Geschäftszustand liegt im Controller** — niemals in
  Widget-Feldern. Reine UI-Flags (Passwort-Sichtbarkeit, Auf-/Zuklappen) dürfen
  `useState` verwenden.
- VERMEIDE, einen `TextEditingController` (oder ein anderes
  Widget-Lebenszyklus-Objekt) als Feld in einem `@riverpod`-Controller abzulegen —
  Auto-Dispose entsorgt ihn sonst der UI unter den Füßen weg. Halte ihn in der View
  via `useTextEditingController()`; der Controller erhält schlichte **`String`s**.
  Bestehende Riverpod-Controller mit diesem Anti-Pattern (TextEditingController)
  müssen bemängelt werden, oder der Controller MUSS auf keepAlive gesetzt werden,
  damit er am Leben bleibt!
  Hintergrund: Manche Apps wurden mit Riverpod 2.0 entwickelt, das ein
  entgegengesetztes Default-Verhalten für Provider hatte! Mache solche Controller
  daher robust und kompatibel bei der Verwendung von Riverpod 3+!!
- Vermeide, `BuildContext` in Controller/Services zu übergeben. Controller stellen
  `AsyncValue` bereit; die UI reagiert via `ref.listen`, um Snackbars zu zeigen oder
  zu navigieren.
- Stelle asynchrone Arbeit als **`AsyncValue`** bereit (`AsyncNotifier`/
  `FutureProvider`); die UI behandelt Daten/Laden/Fehler. Begründung siehe oben.
- Langlebiger Zustand (Auth, Theme, Logger, Config, Backend-Client) nutzt
  **`@Riverpod(keepAlive: true)`**; alles andere disposed automatisch.

### Controller-Form (übernimm dieses Muster)
```dart
/// Controller für den Login-Screen. Hält keine Widget-Lebenszyklus-Objekte und
/// erhält niemals einen BuildContext; stellt den Fortschritt als AsyncValue<void> bereit.
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    // Leerer Rumpf (NICHT `return;`) — startet im Leerlauf.
  }

  /// Meldet den Benutzer mit [email] und [password] an.
  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue<void>.loading();
    try {
      final AuthService auth = ref.read(authServiceProvider);
      await auth.login(email: email, password: password);
      state = const AsyncValue<void>.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue<void>.error(error, stackTrace);
    }
  }
}
```

---

## 4. Widgets & Wiederverwendung

- Extrahiere **wiederverwendete Steuerelemente** nach `lib/widgets/`-Unterordnern —
  etwa Formular-Eingaben (z. B. `AppTextField` für Label+Icon-Eingaben,
  `AppPasswordField` für ein Passwortfeld mit eingebautem Anzeigen/Verbergen-Umschalter),
  damit das Styling einmal definiert ist und jeder Screen konsistent bleibt.
- Ein wiederverwendbares **Passwortfeld besitzt seinen eigenen Sichtbarkeitszustand**
  (`useState` in einem `HookWidget`), statt einen geteilten Umschalter vom Aufrufer
  zu nehmen — so kann es beliebig oft eingesetzt werden.
- Stelle konsistente **Lade-/Fehler-/Leer-**Widgets bereit und nutze sie über alle
  `AsyncValue`-Views hinweg, damit die Zustandsbehandlung einheitlich aussieht.
- Halte Widgets klein; gib wiederverwendbaren Widgets eine **minimale, konsistente
  API** und füge Parameter nur hinzu, wenn ein echter Bedarf entsteht.

---

## 5. Theming
Falls im Projekt noch keine Theme-Unterstützung existiert, hier die Best Practice:
- **Material 3** (`useMaterial3: true`). Baue BEIDE `ThemeData`, hell und dunkel, aus
  einer **einzigen Seed-Farbe** via `ColorScheme.fromSeed(...)`.
- **Zentralisiere die Theme-Konstruktion** in `lib/theme/app_theme.dart`
  (`AppTheme.build({brightness, seedColor})`) — niemals inline in `app.dart`.
- **Schriftgrößen und Komponenten-Styling gehören ins `ThemeData`** (z. B.
  `navigationRailTheme`, `textTheme`), einmal in `AppTheme` definiert — niemals an
  jeder Aufrufstelle fest verdrahtet. Umgestalten durch Bearbeiten des Themes, nicht
  jedes einzelnen Widgets.
- Bietet die App eine benutzerwählbare **Akzentfarbe**, speichere sie als Seed
  (ARGB-Int) in den Nutzereinstellungen und leite die gesamte Palette daraus neu ab;
  bevorzuge eine **kuratierte Preset-Palette** gegenüber einem freien Farbrad
  (keine Extra-Abhängigkeit, testbar). Lies Farben mit `Color(intValue)` zurück und
  persistiere mit `color.toARGB32()` (`Color.value` ist veraltet).
- Eingebettete Drittanbieter-Screens (Log-Viewer, Picker, …) sollten das
  `ColorScheme` der App erhalten, damit sie zu hell/dunkel passen, statt ihre eigene
  Standardpalette mitzubringen.

---

## 6. Modelle

- Alle Datenmodelle nutzen **Freezed** (`@freezed`, `abstract class X with _$X`)
  plus `fromJson`/`toJson`. Keine handgeschriebenen, veränderlichen Datenklassen.
- Gib jedem Feld einen **Default** (`@Default(...)`), damit `fromJson` fehlende
  Schlüssel toleriert (ältere gecachte/entfernte Daten, nachdem ein Feld ergänzt wurde).

---

## 7. Navigation
Falls im Projekt noch kein Navigationsmuster / keine Navigationslösung genutzt wird,
hier die zu verwendende Best Practice:
- Nutze **`go_router`** mit einem Top-Level-`redirect`-Guard, der vom
  Auth-/Session-Provider gesteuert wird (nicht authentifiziert → Login; während der
  Startup-Prüfung → ein Splash).
- **Binde `refreshListenable` des Routers an den Auth-Zustand**, damit der Redirect
  bei Login/Logout sofort neu bewertet wird, nicht nur bei expliziter Navigation.
- Für eine persistente Sidebar/Shell nutze **`StatefulShellRoute.indexedStack`**,
  damit jeder Tab seinen eigenen Zustand behält und URL/Zurück-Verhalten im Browser
  korrekt bleibt.

---

## 8. Testen

**Dieses Projekt verzichtet bewusst auf eine eigene Unit-/Widget-Test-Suite.**
Schreibe **keine** `test/`-Dateien und keine `flutter_test`-Abhängigkeiten,
außer der Benutzer bittet explizit darum. Verifiziere Änderungen stattdessen
manuell (App starten, `flutter analyze`, ggf. Browser-Preview) — siehe §13.

Falls der Benutzer für ein *anderes* Projekt doch Tests wünscht: Hänge von
**Service-Schnittstellen** ab und überschreibe dann die Service-Provider mit
**handgeschriebenen Fakes** (bevorzugt gegenüber einem Mocking-Framework —
besser lesbar) via `ProviderContainer` / `ProviderScope(overrides: [...])`.
Riverpod 3 exportiert den Typ `Override` **nicht** — schreibe
`overrides: [...]` ohne explizites Typargument.

---

## 9. Logging
- Nutze ein strukturiertes Logging-Framework (z. B. **Talker**) über einen
  `LoggerService`-Provider. **Kein `print` / `debugPrint`** fürs App-Logging.
- **Logge eine Ausnahme einmal, an der Grenze, an der sie mit Kontext behandelt
  wird** (Controller-/Service-`catch`), dann rethrow oder Weitergabe via
  `AsyncValue`. Nicht stillschweigend schlucken; nicht auf jeder Schicht doppelt loggen.
- **Logge niemals Secrets oder PII** (Passwörter, Tokens, vollständige E-Mails) —
  vorher redigieren.
- Fange unbehandelte Fehler global ab (`FlutterError.onError`,
  `PlatformDispatcher.instance.onError`), damit Fehler auf Web/Desktop sichtbar sind,
  wo es kein Terminal gibt.

---

## 10. Config & Secrets

- Lies Config (Endpunkte, IDs, Feature-Flags) via `--dart-define` /
  `--dart-define-from-file`, bereitgestellt über eine Konstantenklasse mit
  `String.fromEnvironment` / `bool.fromEnvironment`.
- Gib jedem Wert einen **sicheren Default**, damit die CI ohne Secrets kompilieren kann.
- **Keine Secrets im eingecheckten Quellcode.** Liefere eine `*.example.json` mit;
  setze die echte Config-Datei auf gitignore.
- **Feature-Flags, die Sicherheit umgehen (Demo-/Offline-Modi, Auth-Abkürzungen),
  MÜSSEN durch ein Compile-Time-Flag** abgesichert sein, nicht allein durch einen
  Runtime-Schalter — ein Runtime-Schalter darf niemals Auth in einem ausgelieferten
  Binary umgehen können.

---

## 11. Lokalisierung

- Standard-ARB-Lokalisierung (`flutter: generate: true`, `l10n.yaml`,
  `lib/l10n/app_*.arb` mit übereinstimmenden Schlüsseln). Keine fest verdrahteten,
  benutzersichtbaren Strings in Widgets — füge einen Schlüssel hinzu und nutze das
  generierte `AppLocalizations`.

---

## 12. Hooks & reaktive Fallstricke
Bevorzugte Steuerungs-/Event-Verwaltung aus der UI:
- **Widget-Zustand, der in einem Event-Handler gesetzt wird, geht bei einem
  provider-getriebenen Remount verloren.** Wenn eine Aktion sowohl widget-lokalen
  Zustand setzt (z. B. Vorbefüllen eines `TextEditingController`) ALS AUCH einen
  Provider ändert, den der Router-Guard beobachtet, kann der Guard die Route
  umlenken und **die View neu mounten**, wodurch deren Hooks neu initialisiert und
  der Wert verworfen werden. Lösung: Leite diesen Zustand aus einem **auf den
  Quellwert gekeyten `useEffect`** ab, damit er sich bei jedem (Re-)Mount neu
  anwendet — setze ihn nicht einmalig im Handler.

---

## 13. Workflow-Erwartungen an den Assistenten

- Nach dem Ändern von Quellen für generierten Code (Freezed/JSON/Riverpod) führe
  **`dart run build_runner build`** aus; nach dem Ändern von ARB-Dateien
  regeneriere die Lokalisierungen. (`--delete-conflicting-outputs` ist bei
  `build_runner` ≥ 2.15 obsolet.)
- Bevor du „fertig" meldest: **`flutter analyze` muss sauber durchlaufen.**
  Es gibt bewusst keine Testsuite (§8) — verifiziere stattdessen durch
  tatsächliches Ausführen der App (Browser-Preview o. Ä.), wo sinnvoll. Nenne
  Ergebnisse ehrlich; wenn etwas fehlschlägt oder übersprungen wird, sage es.
- Passe dich in jeder Änderung dem **Stil des umgebenden Codes** an (Kommentardichte,
  Benennung, Idiome).
- Halte Änderungen eng umrissen; füge keine Abhängigkeiten oder zweite Frameworks
  ohne klaren Grund und (idealerweise) das OK des Benutzers hinzu.

---

## Kurze DON'T-Liste

- ❌ `StatefulWidget` / `ConsumerStatefulWidget`; veraltete `StateNotifier` /
  `ChangeNotifier`; eine zweite State-Management-Bibliothek.
- ❌ Für neue Riverpod-Controller möglichst vermeiden (oder keepAlive in bestehenden
  Controllern nutzen!): `TextEditingController`-Felder in Riverpod-Controllern.
- ❌ Für neue Riverpod-Controller möglichst vermeiden (oder keepAlive in bestehenden
  Controllern nutzen!): `BuildContext` in Controllern/Services.
- ❌ Einen rohen Backend-Client aus einem Controller aufrufen (geh über einen Service).
- ❌ Cascade-Operatoren (`..`); Spread-Operatoren (`...`) und Collection-`if`/`for`
  in Widget-/Map-Literalen; mehrschrittige Arrow-Rumpf-Methoden; lange einzeilige
  Ketten; verschachtelte Ternäre.
- ❌ Fest verdrahtete Schriftgrößen/-stile an der Aufrufstelle; `ThemeData` inline in
  `app.dart` gebaut.
- ❌ `print` / `debugPrint`; Secrets oder PII loggen.
- ❌ Fehlende `///` an öffentlichen APIs; `SCREAMING_CAPS`-Konstanten; Dateinamen,
  die nicht `snake_case` sind.
- ❌ Secrets/Config-IDs im Quellcode eingecheckt.
- ❌ Nur zur Laufzeit gesetzte Flags, die in einem Produktions-Build die
  Authentifizierung umgehen können.
