import 'package:get/get.dart';
import 'package:rein_player/utils/constants/rp_enums.dart';

class NavigationContextController extends GetxController {
  static NavigationContextController get to => Get.find();

  final Rx<ActionContext> currentContext = ActionContext.player.obs;

  void switchToPlayer() {
    currentContext.value = ActionContext.player;
  }

  void switchToPlaylist() {
    currentContext.value = ActionContext.playlist;
  }
}
