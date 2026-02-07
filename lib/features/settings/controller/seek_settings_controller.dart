import 'package:get/get.dart';
import 'package:rein_player/features/settings/models/seek_settings.dart';
import 'package:rein_player/utils/constants/rp_enums.dart';
import 'package:rein_player/utils/constants/rp_keys.dart';
import 'package:rein_player/utils/local_storage/rp_local_storage.dart';

class SeekSettingsController extends GetxController {
  static SeekSettingsController get to => Get.find();

  final storage = RpLocalStorage();
  late Rx<SeekSettings> settings;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    try {
      final data = storage.readData(RpKeysConstants.seekSettingsKey);
      if (data != null) {
        settings = SeekSettings.fromJson(data as Map<String, dynamic>).obs;
      } else {
        settings = SeekSettings().obs;
      }
    } catch (e) {
      settings = SeekSettings().obs;
    }
  }

  Future<void> updateSeekMode(SeekMode mode) async {
    settings.value = settings.value.copyWith(mode: mode);
    await _saveSettings();
  }

  Future<void> updateRegularSeekPercentage(double percentage) async {
    // Validate: 0.5% - 10%
    final clampedPercentage = percentage.clamp(0.005, 0.1);
    settings.value = settings.value.copyWith(regularSeekPercentage: clampedPercentage);
    await _saveSettings();
  }

  Future<void> updateBigSeekPercentage(double percentage) async {
    // Validate: 1% - 20%
    final clampedPercentage = percentage.clamp(0.01, 0.2);
    settings.value = settings.value.copyWith(bigSeekPercentage: clampedPercentage);
    await _saveSettings();
  }

  Future<void> updateRegularSeekSeconds(int seconds) async {
    // Validate: 1 - 120 seconds
    final clampedSeconds = seconds.clamp(1, 120);
    settings.value = settings.value.copyWith(regularSeekSeconds: clampedSeconds);
    await _saveSettings();
  }

  Future<void> updateBigSeekSeconds(int seconds) async {
    // Validate: 5 - 300 seconds
    final clampedSeconds = seconds.clamp(5, 300);
    settings.value = settings.value.copyWith(bigSeekSeconds: clampedSeconds);
    await _saveSettings();
  }

  Future<void> resetToDefaults() async {
    settings.value = SeekSettings();
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    await storage.saveData(RpKeysConstants.seekSettingsKey, settings.value.toJson());
    update();
  }
}
