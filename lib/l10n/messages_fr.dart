// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'fr';

  static m0(days) => "${Intl.plural(days, one: 'Il y a un jour', other: 'Il y a ${days} jours')}";

  static m1(hours) => "${Intl.plural(hours, one: 'Il y a ${hours} heure', other: 'Il y a ${hours} heures')}";

  static m2(minutes) => "${minutes} min restantes";

  static m3(minutes) => "${Intl.plural(minutes, one: 'Il y a 1 minute', other: 'Il y a ${minutes} minutes')}";

  static m4(seconds) => "${seconds} sec restantes";

  static m5(weeks) => "${Intl.plural(weeks, one: 'Il y a une semaine', other: 'Il y a ${weeks} semaines')}";

  static m6(days) => "${Intl.plural(days, one: '1j', other: '${days}j')}";

  static m7(hours) => "${Intl.plural(hours, one: '1h', other: '${hours}h')}";

  static m8(minutes) => "${minutes} min";

  static m9(minutes) => "${Intl.plural(minutes, one: '1m', other: '${minutes}m')}";

  static m10(seconds) => "${seconds} sec";

  static m11(weeks) => "${Intl.plural(weeks, one: '1sem', other: '${weeks}sem')}";

  static m12(episodes) => "${Intl.plural(episodes, one: '1 nouvel \u00e9pisode', other: '${episodes} nouveaux \u00e9pisodes')}";

  static m13(episodes) => "${Intl.plural(episodes, one: '1 \u00e9pisode non \u00e9cout\u00e9', other: '${episodes} \u00e9pisodes non \u00e9cout\u00e9s')}";

  static m14(minutes) => "${minutes} minutes";

  static m15(minutes) => "${minutes} min";

  static m16(seconds) => "${seconds} sec";

  static m17(minutes) => "${minutes} minutes";

  static m18(seconds) => "${seconds} secondes";

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'about_label': MessageLookupByLibrary.simpleMessage('\u00c0 propos'),
    'add_rss_feed_option': MessageLookupByLibrary.simpleMessage('Ajouter un flux RSS'),
    'alert_sync_title_body': MessageLookupByLibrary.simpleMessage('Mise \u00e0 jour de votre biblioth\u00e8que en cours'),
    'alert_sync_title_label': MessageLookupByLibrary.simpleMessage('Mise \u00e0 jour'),
    'app_title': MessageLookupByLibrary.simpleMessage('enpleineconscience.ch'),
    'app_title_short': MessageLookupByLibrary.simpleMessage('enpleineconscience'),
    'audio_effect_trim_silence_label': MessageLookupByLibrary.simpleMessage('Couper les silences'),
    'audio_effect_volume_boost_label': MessageLookupByLibrary.simpleMessage('Amplification du volume'),
    'audio_settings_playback_speed_label': MessageLookupByLibrary.simpleMessage('Vitesse de lecture'),
    'auto_scroll_transcript_label': MessageLookupByLibrary.simpleMessage('Suivre la transcription'),
    'cancel_button_label': MessageLookupByLibrary.simpleMessage('Annuler'),
    'cancel_download_button_label': MessageLookupByLibrary.simpleMessage('Annuler le t\u00e9l\u00e9chargement'),
    'cancel_option_label': MessageLookupByLibrary.simpleMessage('Annuler'),
    'chapters_label': MessageLookupByLibrary.simpleMessage('Chapitres'),
    'clear_queue_button_label': MessageLookupByLibrary.simpleMessage('VIDER LA FILE'),
    'clear_search_button_label': MessageLookupByLibrary.simpleMessage('Effacer la recherche'),
    'close_button_label': MessageLookupByLibrary.simpleMessage('Fermer'),
    'consent_message': MessageLookupByLibrary.simpleMessage('Ce lien de financement vous dirigera vers un site externe.'),
    'continue_button_label': MessageLookupByLibrary.simpleMessage('Continuer'),
    'delete_button_label': MessageLookupByLibrary.simpleMessage('Supprimer'),
    'delete_episode_button_label': MessageLookupByLibrary.simpleMessage('Supprimer l\'\u00e9pisode t\u00e9l\u00e9charg\u00e9'),
    'delete_episode_confirmation': MessageLookupByLibrary.simpleMessage('Voulez-vous vraiment supprimer cet \u00e9pisode ?'),
    'delete_episode_title': MessageLookupByLibrary.simpleMessage('Supprimer l\'\u00e9pisode'),
    'delete_label': MessageLookupByLibrary.simpleMessage('Supprimer'),
    'discover': MessageLookupByLibrary.simpleMessage('Catalogue'),
    'discovery_categories_itunes': MessageLookupByLibrary.simpleMessage('All,Arts,Business,Comedy,Education,Fiction,Government,Health & Fitness,History,Kids & Family,Leisure,Music,News,Religion & Spirituality,Science,Society & Culture,Sports,TV & Film,Technology,True Crime'),
    'discovery_categories_pindex': MessageLookupByLibrary.simpleMessage('All,After-Shows,Alternative,Animals,Animation,Arts,Astronomy,Automotive,Aviation,Baseball,Basketball,Beauty,Books,Buddhism,Business,Careers,Chemistry,Christianity,Climate,Comedy,Commentary,Courses,Crafts,Cricket,Cryptocurrency,Culture,Daily,Design,Documentary,Drama,Earth,Education,Entertainment,Entrepreneurship,Family,Fantasy,Fashion,Fiction,Film,Fitness,Food,Football,Games,Garden,Golf,Government,Health,Hinduism,History,Hobbies,Hockey,Home,HowTo,Improv,Interviews,Investing,Islam,Journals,Judaism,Kids,Language,Learning,Leisure,Life,Management,Manga,Marketing,Mathematics,Medicine,Mental,Music,Natural,Nature,News,NonProfit,Nutrition,Parenting,Performing,Personal,Pets,Philosophy,Physics,Places,Politics,Relationships,Religion,Reviews,Role-Playing,Rugby,Running,Science,Self-Improvement,Sexuality,Soccer,Social,Society,Spirituality,Sports,Stand-Up,Stories,Swimming,TV,Tabletop,Technology,Tennis,Travel,True Crime,Video-Games,Visual,Volleyball,Weather,Wilderness,Wrestling'),
    'download_episode_button_label': MessageLookupByLibrary.simpleMessage('T\u00e9l\u00e9charger l\'\u00e9pisode'),
    'downloads': MessageLookupByLibrary.simpleMessage('T\u00e9l\u00e9chargements'),
    'empty_queue_message': MessageLookupByLibrary.simpleMessage('Votre file d\'attente est vide'),
    'episode_details_button_label': MessageLookupByLibrary.simpleMessage('Afficher les informations de l\'\u00e9pisode'),
    'episode_filter_clear_filters_button_label': MessageLookupByLibrary.simpleMessage('Effacer les filtres'),
    'episode_filter_no_episodes_title_description': MessageLookupByLibrary.simpleMessage('Aucun \u00e9pisode ne correspond \u00e0 vos crit\u00e8res'),
    'episode_filter_no_episodes_title_label': MessageLookupByLibrary.simpleMessage('Aucun \u00e9pisode trouv\u00e9'),
    'episode_filter_none_label': MessageLookupByLibrary.simpleMessage('Aucun'),
    'episode_filter_played_label': MessageLookupByLibrary.simpleMessage('\u00c9cout\u00e9s'),
    'episode_filter_semantic_label': MessageLookupByLibrary.simpleMessage('Filtrer les \u00e9pisodes'),
    'episode_filter_started_label': MessageLookupByLibrary.simpleMessage('Commenc\u00e9s'),
    'episode_filter_unplayed_label': MessageLookupByLibrary.simpleMessage('Non \u00e9cout\u00e9s'),
    'episode_label': MessageLookupByLibrary.simpleMessage('\u00c9pisode'),
    'episode_semantic_time_days_ago': m0,
    'episode_semantic_time_hours_ago': m1,
    'episode_semantic_time_minute_remaining': m2,
    'episode_semantic_time_minutes_ago': m3,
    'episode_semantic_time_second_remaining': m4,
    'episode_semantic_time_weeks_ago': m5,
    'episode_sort_alphabetical_ascending_label': MessageLookupByLibrary.simpleMessage('Alphab\u00e9tique A-Z'),
    'episode_sort_alphabetical_descending_label': MessageLookupByLibrary.simpleMessage('Alphab\u00e9tique Z-A'),
    'episode_sort_earliest_first_label': MessageLookupByLibrary.simpleMessage('Plus anciens d\'abord'),
    'episode_sort_latest_first_label': MessageLookupByLibrary.simpleMessage('Plus r\u00e9cents d\'abord'),
    'episode_sort_none_label': MessageLookupByLibrary.simpleMessage('Par d\u00e9faut'),
    'episode_sort_semantic_label': MessageLookupByLibrary.simpleMessage('Trier les \u00e9pisodes'),
    'episode_time_days_ago': m6,
    'episode_time_hours_ago': m7,
    'episode_time_minute_remaining': m8,
    'episode_time_minutes_ago': m9,
    'episode_time_now': MessageLookupByLibrary.simpleMessage('Maintenant'),
    'episode_time_second_remaining': m10,
    'episode_time_weeks_ago': m11,
    'error_no_connection': MessageLookupByLibrary.simpleMessage('Impossible de lire l\'\u00e9pisode. V\u00e9rifiez votre connexion et r\u00e9essayez.'),
    'error_playback_fail': MessageLookupByLibrary.simpleMessage('Une erreur est survenue pendant la lecture. V\u00e9rifiez votre connexion et r\u00e9essayez.'),
    'fast_forward_button_label': MessageLookupByLibrary.simpleMessage('Avancer de 30 secondes'),
    'feedback_menu_item_label': MessageLookupByLibrary.simpleMessage('Feedback'),
    'go_back_button_label': MessageLookupByLibrary.simpleMessage('Retour'),
    'label_episode_actions': MessageLookupByLibrary.simpleMessage('Actions de l\'\u00e9pisode'),
    'label_megabytes': MessageLookupByLibrary.simpleMessage('m\u00e9gaoctets'),
    'label_megabytes_abbr': MessageLookupByLibrary.simpleMessage('Mo'),
    'label_opml_importing': MessageLookupByLibrary.simpleMessage('Importation'),
    'label_podcast_actions': MessageLookupByLibrary.simpleMessage('Actions du podcast'),
    'layout_label': MessageLookupByLibrary.simpleMessage('Disposition'),
    'layout_selector_compact_grid_view': MessageLookupByLibrary.simpleMessage('Grille compacte'),
    'layout_selector_grid_view': MessageLookupByLibrary.simpleMessage('Grille'),
    'layout_selector_highlight_new_episodes': MessageLookupByLibrary.simpleMessage('Mettre en avant les nouveaux \u00e9pisodes'),
    'layout_selector_list_view': MessageLookupByLibrary.simpleMessage('Liste'),
    'layout_selector_sort_by': MessageLookupByLibrary.simpleMessage('Trier par'),
    'layout_selector_sort_by_alphabetical': MessageLookupByLibrary.simpleMessage('Alphab\u00e9tique'),
    'layout_selector_sort_by_followed': MessageLookupByLibrary.simpleMessage('Date d\'ajout'),
    'layout_selector_sort_by_unplayed': MessageLookupByLibrary.simpleMessage('Non \u00e9cout\u00e9s'),
    'layout_selector_unplayed_episodes': MessageLookupByLibrary.simpleMessage('Afficher le nombre de non \u00e9cout\u00e9s'),
    'library': MessageLookupByLibrary.simpleMessage('Biblioth\u00e8que'),
    'library_sort_alphabetical_label': MessageLookupByLibrary.simpleMessage('Alphab\u00e9tique'),
    'library_sort_date_followed_label': MessageLookupByLibrary.simpleMessage('Date d\'ajout'),
    'library_sort_latest_episodes_label': MessageLookupByLibrary.simpleMessage('Derniers \u00e9pisodes'),
    'library_sort_unplayed_count_label': MessageLookupByLibrary.simpleMessage('\u00c9pisodes non \u00e9cout\u00e9s'),
    'mark_episodes_not_played_label': MessageLookupByLibrary.simpleMessage('Marquer tous les \u00e9pisodes comme non \u00e9cout\u00e9s'),
    'mark_episodes_played_label': MessageLookupByLibrary.simpleMessage('Marquer tous les \u00e9pisodes comme \u00e9cout\u00e9s'),
    'mark_played_label': MessageLookupByLibrary.simpleMessage('Marquer comme \u00e9cout\u00e9'),
    'mark_unplayed_label': MessageLookupByLibrary.simpleMessage('Marquer comme non \u00e9cout\u00e9'),
    'minimise_player_window_button_label': MessageLookupByLibrary.simpleMessage('R\u00e9duire le lecteur'),
    'more_label': MessageLookupByLibrary.simpleMessage('Plus'),
    'new_episodes_label': MessageLookupByLibrary.simpleMessage('De nouveaux \u00e9pisodes sont disponibles'),
    'new_episodes_view_now_label': MessageLookupByLibrary.simpleMessage('VOIR'),
    'no_downloads_message': MessageLookupByLibrary.simpleMessage('Vous n\'avez aucun \u00e9pisode t\u00e9l\u00e9charg\u00e9'),
    'no_podcast_details_message': MessageLookupByLibrary.simpleMessage('Impossible de charger les \u00e9pisodes. V\u00e9rifiez votre connexion.'),
    'no_search_results_message': MessageLookupByLibrary.simpleMessage('Aucun podcast trouv\u00e9'),
    'no_subscriptions_message': MessageLookupByLibrary.simpleMessage('Appuyez sur Catalogue ci-dessous pour d\u00e9couvrir les m\u00e9ditations disponibles'),
    'no_transcript_available_label': MessageLookupByLibrary.simpleMessage('Aucune transcription disponible pour ce podcast'),
    'notes_label': MessageLookupByLibrary.simpleMessage('Notes'),
    'now_playing_episode_position': MessageLookupByLibrary.simpleMessage('Position de l\'\u00e9pisode'),
    'now_playing_episode_time_remaining': MessageLookupByLibrary.simpleMessage('Temps restant'),
    'now_playing_queue_label': MessageLookupByLibrary.simpleMessage('En cours'),
    'ok_button_label': MessageLookupByLibrary.simpleMessage('OK'),
    'open_show_website_label': MessageLookupByLibrary.simpleMessage('Ouvrir le site web'),
    'open_up_next_hint': MessageLookupByLibrary.simpleMessage('Ouvrir la file d\'attente'),
    'opml_export_button_label': MessageLookupByLibrary.simpleMessage('Exporter'),
    'opml_import_button_label': MessageLookupByLibrary.simpleMessage('Importer'),
    'opml_import_export_label': MessageLookupByLibrary.simpleMessage('Import/Export OPML'),
    'pause_button_label': MessageLookupByLibrary.simpleMessage('Pause'),
    'play_button_label': MessageLookupByLibrary.simpleMessage('\u00c9couter'),
    'play_download_button_label': MessageLookupByLibrary.simpleMessage('\u00c9couter l\'\u00e9pisode t\u00e9l\u00e9charg\u00e9'),
    'playback_speed_label': MessageLookupByLibrary.simpleMessage('Vitesse de lecture'),
    'playing_next_queue_label': MessageLookupByLibrary.simpleMessage('\u00c0 suivre'),
    'podcast_context_play_latest_episode_label': MessageLookupByLibrary.simpleMessage('\u00c9couter le dernier \u00e9pisode'),
    'podcast_context_play_next_episode_label': MessageLookupByLibrary.simpleMessage('\u00c9couter le prochain \u00e9pisode non \u00e9cout\u00e9'),
    'podcast_context_queue_latest_episode_label': MessageLookupByLibrary.simpleMessage('Ajouter le dernier \u00e9pisode \u00e0 la file'),
    'podcast_context_queue_next_episode_label': MessageLookupByLibrary.simpleMessage('Ajouter le prochain non \u00e9cout\u00e9 \u00e0 la file'),
    'podcast_funding_dialog_header': MessageLookupByLibrary.simpleMessage('Financement du podcast'),
    'podcast_options_overflow_menu_semantic_label': MessageLookupByLibrary.simpleMessage('Menu d\'options'),
    'queue_add_label': MessageLookupByLibrary.simpleMessage('Ajouter'),
    'queue_clear_button_label': MessageLookupByLibrary.simpleMessage('Vider'),
    'queue_clear_label': MessageLookupByLibrary.simpleMessage('Voulez-vous vraiment vider la file d\'attente ?'),
    'queue_clear_label_title': MessageLookupByLibrary.simpleMessage('Vider la file'),
    'queue_remove_label': MessageLookupByLibrary.simpleMessage('Retirer'),
    'refresh_feed_label': MessageLookupByLibrary.simpleMessage('Actualiser les \u00e9pisodes'),
    'resume_button_label': MessageLookupByLibrary.simpleMessage('Reprendre'),
    'rewind_button_label': MessageLookupByLibrary.simpleMessage('Reculer de 10 secondes'),
    'scrim_episode_details_selector': MessageLookupByLibrary.simpleMessage('Dismiss episode details'),
    'scrim_episode_filter_selector': MessageLookupByLibrary.simpleMessage('Dismiss episode filter'),
    'scrim_episode_sort_selector': MessageLookupByLibrary.simpleMessage('Dismiss episode sort'),
    'scrim_layout_selector': MessageLookupByLibrary.simpleMessage('Dismiss layout selector'),
    'scrim_sleep_timer_selector': MessageLookupByLibrary.simpleMessage('Dismiss sleep timer selector'),
    'scrim_speed_selector': MessageLookupByLibrary.simpleMessage('Dismiss playback speed selector'),
    'search_back_button_label': MessageLookupByLibrary.simpleMessage('Retour'),
    'search_button_label': MessageLookupByLibrary.simpleMessage('Rechercher'),
    'search_episodes_label': MessageLookupByLibrary.simpleMessage('Rechercher des \u00e9pisodes'),
    'search_for_podcasts_hint': MessageLookupByLibrary.simpleMessage('Rechercher des podcasts'),
    'search_provider_label': MessageLookupByLibrary.simpleMessage('Fournisseur de recherche'),
    'search_transcript_label': MessageLookupByLibrary.simpleMessage('Rechercher dans la transcription'),
    'semantic_announce_loading': MessageLookupByLibrary.simpleMessage('Loading, please wait.'),
    'semantic_announce_searching': MessageLookupByLibrary.simpleMessage('Searching, please wait.'),
    'semantic_chapter_link_label': MessageLookupByLibrary.simpleMessage('Chapter web link'),
    'semantic_current_chapter_label': MessageLookupByLibrary.simpleMessage('Current chapter'),
    'semantic_current_value_label': MessageLookupByLibrary.simpleMessage('Current value'),
    'semantic_new_episodes_count': m12,
    'semantic_playing_options_collapse_label': MessageLookupByLibrary.simpleMessage('Close playing options slider'),
    'semantic_playing_options_expand_label': MessageLookupByLibrary.simpleMessage('Open playing options slider'),
    'semantic_podcast_artwork_label': MessageLookupByLibrary.simpleMessage('Podcast artwork'),
    'semantic_unplayed_episodes_count': m13,
    'semantics_add_to_queue': MessageLookupByLibrary.simpleMessage('Add episode to queue'),
    'semantics_collapse_podcast_description': MessageLookupByLibrary.simpleMessage('Collapse podcast description'),
    'semantics_decrease_playback_speed': MessageLookupByLibrary.simpleMessage('Decrease playback speed'),
    'semantics_episode_tile_collapsed': MessageLookupByLibrary.simpleMessage('Episode list item. Showing image, summary and main controls.'),
    'semantics_episode_tile_collapsed_hint': MessageLookupByLibrary.simpleMessage('expand and show more details and additional options'),
    'semantics_episode_tile_expanded': MessageLookupByLibrary.simpleMessage('Episode list item. Showing description, main controls and additional controls.'),
    'semantics_episode_tile_expanded_hint': MessageLookupByLibrary.simpleMessage('collapse and show summary, download and play control'),
    'semantics_expand_podcast_description': MessageLookupByLibrary.simpleMessage('Expand podcast description'),
    'semantics_increase_playback_speed': MessageLookupByLibrary.simpleMessage('Increase playback speed'),
    'semantics_layout_option_compact_grid': MessageLookupByLibrary.simpleMessage('Compact grid layout'),
    'semantics_layout_option_grid': MessageLookupByLibrary.simpleMessage('Grid layout'),
    'semantics_layout_option_list': MessageLookupByLibrary.simpleMessage('List layout'),
    'semantics_main_player_header': MessageLookupByLibrary.simpleMessage('Main player window'),
    'semantics_mark_episode_played': MessageLookupByLibrary.simpleMessage('Mark Episode as played'),
    'semantics_mark_episode_unplayed': MessageLookupByLibrary.simpleMessage('Mark Episode as un-played'),
    'semantics_mini_player_header': MessageLookupByLibrary.simpleMessage('Mini player. Swipe right to play/pause button. Activate to open main player window'),
    'semantics_play_pause_toggle': MessageLookupByLibrary.simpleMessage('Play/pause toggle'),
    'semantics_podcast_details_header': MessageLookupByLibrary.simpleMessage('Podcast details and episodes page'),
    'semantics_remove_from_queue': MessageLookupByLibrary.simpleMessage('Remove episode from queue'),
    'settings_auto_open_now_playing': MessageLookupByLibrary.simpleMessage('Lecteur plein \u00e9cran au d\u00e9marrage de l\'\u00e9coute'),
    'settings_auto_update_episodes': MessageLookupByLibrary.simpleMessage('Actualiser les podcasts'),
    'settings_auto_update_episodes_10min': MessageLookupByLibrary.simpleMessage('10 minutes depuis la derni\u00e8re mise \u00e0 jour'),
    'settings_auto_update_episodes_12hour': MessageLookupByLibrary.simpleMessage('Toutes les 12 heures'),
    'settings_auto_update_episodes_1hour': MessageLookupByLibrary.simpleMessage('Toutes les heures'),
    'settings_auto_update_episodes_24hour': MessageLookupByLibrary.simpleMessage('Toutes les 24 heures'),
    'settings_auto_update_episodes_30min': MessageLookupByLibrary.simpleMessage('Toutes les 30 minutes'),
    'settings_auto_update_episodes_3hour': MessageLookupByLibrary.simpleMessage('Toutes les 3 heures'),
    'settings_auto_update_episodes_48hour': MessageLookupByLibrary.simpleMessage('Tous les 2 jours'),
    'settings_auto_update_episodes_6hour': MessageLookupByLibrary.simpleMessage('Toutes les 6 heures'),
    'settings_auto_update_episodes_always': MessageLookupByLibrary.simpleMessage('Toujours'),
    'settings_auto_update_episodes_heading': MessageLookupByLibrary.simpleMessage('Actualiser les podcasts'),
    'settings_auto_update_episodes_never': MessageLookupByLibrary.simpleMessage('Jamais'),
    'settings_background_refresh_mobile_data_option': MessageLookupByLibrary.simpleMessage('Actualiser via donn\u00e9es mobiles'),
    'settings_background_refresh_mobile_data_option_subtitle': MessageLookupByLibrary.simpleMessage('Autoriser l\'actualisation via les donn\u00e9es mobiles'),
    'settings_background_refresh_option': MessageLookupByLibrary.simpleMessage('Actualisation en arri\u00e8re-plan'),
    'settings_background_refresh_option_subtitle': MessageLookupByLibrary.simpleMessage('Actualiser les \u00e9pisodes lorsque l\'\u00e9cran est \u00e9teint. Augmente la consommation de batterie.'),
    'settings_continuous_play_option': MessageLookupByLibrary.simpleMessage('Lecture continue'),
    'settings_continuous_play_subtitle': MessageLookupByLibrary.simpleMessage('Lire automatiquement l\'\u00e9pisode suivant si la file est vide'),
    'settings_data_divider_label': MessageLookupByLibrary.simpleMessage('DONN\u00c9ES'),
    'settings_delete_played_label': MessageLookupByLibrary.simpleMessage('Supprimer les t\u00e9l\u00e9chargements apr\u00e8s \u00e9coute'),
    'settings_download_sd_card_label': MessageLookupByLibrary.simpleMessage('T\u00e9l\u00e9charger sur la carte SD'),
    'settings_download_switch_card': MessageLookupByLibrary.simpleMessage('Les nouveaux t\u00e9l\u00e9chargements seront enregistr\u00e9s sur la carte SD.'),
    'settings_download_switch_internal': MessageLookupByLibrary.simpleMessage('Les nouveaux t\u00e9l\u00e9chargements seront enregistr\u00e9s en stockage interne.'),
    'settings_download_switch_label': MessageLookupByLibrary.simpleMessage('Changer l\'emplacement de stockage'),
    'settings_episodes_divider_label': MessageLookupByLibrary.simpleMessage('\u00c9PISODES'),
    'settings_export_opml': MessageLookupByLibrary.simpleMessage('Exporter OPML'),
    'settings_import_opml': MessageLookupByLibrary.simpleMessage('Importer OPML'),
    'settings_label': MessageLookupByLibrary.simpleMessage('Param\u00e8tres'),
    'settings_mark_deleted_played_label': MessageLookupByLibrary.simpleMessage('Marquer les \u00e9pisodes supprim\u00e9s comme \u00e9cout\u00e9s'),
    'settings_notification_divider_label': MessageLookupByLibrary.simpleMessage('NOTIFICATIONS'),
    'settings_personalisation_divider_label': MessageLookupByLibrary.simpleMessage('PERSONNALISATION'),
    'settings_playback_divider_label': MessageLookupByLibrary.simpleMessage('LECTURE'),
    'settings_podcast_management_divider_label': MessageLookupByLibrary.simpleMessage('GESTION DES PODCASTS'),
    'settings_refresh_notification_option': MessageLookupByLibrary.simpleMessage('Notification de mise \u00e0 jour'),
    'settings_refresh_notification_option_subtitle': MessageLookupByLibrary.simpleMessage('Afficher une notification lors de l\'actualisation'),
    'settings_theme': MessageLookupByLibrary.simpleMessage('Th\u00e8me'),
    'settings_theme_heading': MessageLookupByLibrary.simpleMessage('Choisir le th\u00e8me'),
    'settings_theme_value_auto': MessageLookupByLibrary.simpleMessage('Th\u00e8me syst\u00e8me'),
    'settings_theme_value_dark': MessageLookupByLibrary.simpleMessage('Th\u00e8me sombre'),
    'settings_theme_value_light': MessageLookupByLibrary.simpleMessage('Th\u00e8me clair'),
    'share_episode_option_label': MessageLookupByLibrary.simpleMessage('Partager l\'\u00e9pisode'),
    'share_podcast_option_label': MessageLookupByLibrary.simpleMessage('Partager le podcast'),
    'show_notes_label': MessageLookupByLibrary.simpleMessage('Notes de l\'\u00e9pisode'),
    'sleep_episode_label': MessageLookupByLibrary.simpleMessage('Fin de l\'\u00e9pisode'),
    'sleep_minute_label': m14,
    'sleep_off_label': MessageLookupByLibrary.simpleMessage('D\u00e9sactiv\u00e9'),
    'sleep_timer_label': MessageLookupByLibrary.simpleMessage('Minuterie de sommeil'),
    'stop_download_button_label': MessageLookupByLibrary.simpleMessage('Arr\u00eater'),
    'stop_download_confirmation': MessageLookupByLibrary.simpleMessage('Voulez-vous vraiment arr\u00eater ce t\u00e9l\u00e9chargement ?'),
    'stop_download_title': MessageLookupByLibrary.simpleMessage('Arr\u00eater le t\u00e9l\u00e9chargement'),
    'subscribe_button_label': MessageLookupByLibrary.simpleMessage('S\'abonner'),
    'subscribe_label': MessageLookupByLibrary.simpleMessage('S\'abonner'),
    'time_minutes': m15,
    'time_seconds': m16,
    'time_semantic_minutes': m17,
    'time_semantic_seconds': m18,
    'transcript_label': MessageLookupByLibrary.simpleMessage('Transcription'),
    'transcript_why_not_label': MessageLookupByLibrary.simpleMessage('Pourquoi pas ?'),
    'transcript_why_not_url': MessageLookupByLibrary.simpleMessage('https://anytimeplayer.app/docs/anytime_transcript_support_en.html'),
    'unsubscribe_button_label': MessageLookupByLibrary.simpleMessage('Se d\u00e9sabonner'),
    'unsubscribe_label': MessageLookupByLibrary.simpleMessage('Se d\u00e9sabonner'),
    'unsubscribe_message': MessageLookupByLibrary.simpleMessage('Se d\u00e9sabonner supprimera tous les \u00e9pisodes t\u00e9l\u00e9charg\u00e9s de ce podcast.'),
    'up_next_queue_label': MessageLookupByLibrary.simpleMessage('\u00c0 suivre'),
    'update_library_option': MessageLookupByLibrary.simpleMessage('Actualiser la biblioth\u00e8que')
  };
}
