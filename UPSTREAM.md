# Suivi du dépôt d'origine (Anytime Podcast Player)

Cette app est un fork de [amugofjava/anytime_podcast_player](https://github.com/amugofjava/anytime_podcast_player)
(licence BSD-3-Clause, voir `NOTICE.md`). Elle n'est **pas** fusionnée avec l'amont par `git merge` :
les changements utiles sont repris un par un (cherry-pick ou report manuel). Ce fichier dit d'où l'on
part, ce qui a déjà été repris, et ce qui diverge volontairement.

## Point de départ

- Base amont : commit `ffa2fd5` (« Translated using Weblate (German) (#191) »), Anytime 1.3.x, mars 2026.
- Dernier examen de l'amont : **2026-09-15**. Mettre cette date à jour à chaque passage.

## Apports amont déjà repris après la base

| Commit local | Sujet |
|---|---|
| `9ef0a3f` | `podcast_search` : gestion des flux déplacés (410) |
| `247a807` | erreurs de `mp3_info` traitées sans planter |
| `ade3d71` | actualisation manuelle quand l'auto-actualisation est désactivée |
| `871e45f` | `podcast_search` : user-agent, redirections 301 |

## Comment reprendre une nouvelle version d'Anytime

1. Parcourir `git log ffa2fd5..upstream/main` (ou depuis le dernier commit repris) et **ne retenir que**
   ce qui touche la lecture, les flux, les téléchargements, le stockage ou les dépendances :
   `lib/services/`, `lib/repository/`, `lib/bloc/`, `lib/api/`, `lib/entities/`, `pubspec.yaml`,
   `android/` et `ios/` hors icônes.
2. Ignorer par défaut tout ce qui est dans `lib/ui/` : l'apparence est volontairement différente
   (voir ci-dessous). Ne reporter un changement d'interface que s'il corrige un comportement
   (accessibilité, plantage, edge-to-edge…), et le réécrire dans le style du fork.
3. Ignorer `lib/l10n/` amont : le français est maintenu à la main dans `lib/l10n/messages_fr.dart`.
4. Après reprise : `flutter analyze lib` (zéro avertissement attendu), `flutter test` (64 tests),
   puis un tour sur l'émulateur — accueil, une catégorie, lecture, écran éteint 45 s.
5. Ajouter le commit repris au tableau ci-dessus et mettre à jour la date d'examen.

## Fichiers volontairement divergents

Toute fusion automatique y échouera ; c'est attendu.

**Identité et catalogue** (n'existent pas dans l'amont ou n'ont plus rien à voir)
- `lib/core/meditation_catalog.dart` — les flux fixes d'enpleineconscience.ch
- `lib/ui/library/discovery.dart` — l'accueil : liste des catégories
- `lib/l10n/messages_fr.dart` — traduction française
- `lib/core/environment.dart` — nom, version, user-agent (à bumper avec `pubspec.yaml`)
- `assets/images/meditation-*.png`, icônes Android/iOS, écrans de lancement, `fastlane/`

**Apparence** (refonte du 2026-09-15 : Material 3, Montserrat, palette du logo)
- `lib/ui/themes.dart` — **tout part de là** : classe `Palette` (clair/sombre) et thème complet
- `lib/ui/anytime_podcast_app.dart` — barre, `NavigationBar`, menu, « À propos »
- `lib/ui/podcast/podcast_details.dart` — en-tête compact au lieu de la bannière plein écran
- `lib/ui/podcast/podcast_episode_list.dart`, `lib/ui/widgets/episode_tile.dart` — lignes sans vignette,
  tuile dépliable dans tous les cas (le drapeau `accessibleNavigation` est peu fiable sur Android)
- `lib/ui/widgets/play_pause_button.dart`, `download_button.dart`, `tile_image.dart`
- `lib/ui/podcast/transport_controls.dart`, `player_transport_controls.dart` — bouton bordeaux
- `lib/ui/podcast/now_playing.dart`, `now_playing_options.dart`, `mini_player.dart`, `episode_details.dart`
- `lib/ui/widgets/action_text.dart`, `lib/ui/settings/settings_section_label.dart` — casse de phrase
- `lib/ui/settings/settings.dart`, `episode_refresh.dart`, `up_next_view.dart`, sélecteurs (`*_selector.dart`)

**Comportement propre au fork**
- `lib/services/podcast/mobile_podcast_service.dart` — lecture hors ligne depuis la base locale d'abord
- `lib/services/settings/mobile_settings_service.dart` — thème par défaut `system`
- `lib/ui/library/opml_*.dart`, `lib/ui/search/search.dart`, `show_notes.dart` — simplifiés (catalogue fixe)
- `test/unit/core/environment_test.dart`, `test/unit/services/settings_test.dart` — alignés sur ces choix

## Pièges connus

- `.gitignore` exclut `*.png` : toute nouvelle image se commite avec `git add -f`.
- La version se bump à **trois** endroits : `pubspec.yaml`, `lib/core/environment.dart`,
  `ios/Runner.xcodeproj/project.pbxproj` (`MARKETING_VERSION = 50.0.x`, la ligne iOS est à 50.0.x
  parce que l'App Store était déjà au-delà de 33).
- Codemagic ne construit pas sur push : lancer les builds à la main.
