import 'package:get/get.dart';
import 'package:rein_player/features/settings/models/settings.dart';
import 'package:rein_player/utils/constants/rp_enums.dart';
import 'package:rein_player/utils/local_storage/rp_local_storage.dart';

import '../../../utils/constants/rp_keys.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();

  final storage = RpLocalStorage();

  late Settings settings;

  @override
  void onInit() async {
    super.onInit();

    dynamic settingsJson = storage.readData(RpKeysConstants.settingsKey) ?? (Settings()).defaultSettings();
    settings = Settings.fromJson(settingsJson);
  }

  Future<void> updateDoubleClickAction(DoubleClickAction action) async {
    settings.doubleClickAction = action;
    await storage.saveData(RpKeysConstants.settingsKey, settings.toJson());
    update();
  }

  Future<void> updatePlaylistLoadBehavior(PlaylistLoadBehavior behavior) async {
    settings.playlistLoadBehavior = behavior;
    await storage.saveData(RpKeysConstants.settingsKey, settings.toJson());
    update();
  }

  Future<void> updatePlaylistEndBehavior(PlaylistEndBehavior behavior) async {
    settings.playlistEndBehavior = behavior;
    await storage.saveData(RpKeysConstants.settingsKey, settings.toJson());
    update();
  }
}