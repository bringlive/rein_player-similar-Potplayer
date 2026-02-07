import 'package:get/get.dart';

enum ActionContext {
  player,
  playlist
}

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
