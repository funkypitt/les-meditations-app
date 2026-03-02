## les méditations

Application mobile de méditations guidées pour [enpleineconscience.ch](https://www.enpleineconscience.ch), disponible sur Android et iOS.

L'app propose un catalogue de podcasts de méditation guidée pré-configurés, organisés par catégories (bodyscan, respiration, pleine conscience, etc.).

### Fork

Ce projet est un fork de [Anytime Podcast Player](https://github.com/amugofjava/anytime_podcast_player) par Ben Hills, adapté pour la diffusion de méditations guidées. Le code original est distribué sous licence BSD-3-Clause — voir le fichier [LICENSE](LICENSE).

### Principales modifications

- Catalogue fixe de podcasts de méditation (pas de recherche iTunes/PodcastIndex)
- Rebranding complet (icônes, couleurs, nom, écrans de lancement)
- Suppression des fonctionnalités non pertinentes (import/export OPML, choix de moteur de recherche)
- Interface simplifiée pour l'écoute de méditations

### Construction depuis les sources

Prérequis : [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.6.0)

```bash
git clone https://github.com/funkypitt/anytime_podcast_player.git
cd anytime_podcast_player
flutter pub get
flutter build apk
```

### Technologies

Basé sur la stack du projet Anytime :

* [Flutter](https://flutter.dev/) — SDK
* [Sembast](https://pub.dev/packages/sembast) — Base de données NoSQL locale
* [RxDart](https://pub.dev/packages/rxdart) — Extensions réactives pour Dart Streams
* [Audio Service](https://pub.dev/packages/audio_service) — Lecture audio en arrière-plan
* [Podcast Search](https://pub.dev/packages/podcast_search) — Parsing de flux RSS de podcasts

### Licence

Ce projet est distribué sous licence BSD-3-Clause. Voir le fichier [LICENSE](LICENSE) pour les détails.

Copyright (c) 2020 Ben Hills and the project contributors. All rights reserved.
