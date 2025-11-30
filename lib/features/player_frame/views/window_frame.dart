import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:rein_player/common/widgets/rp_vertical_divider.dart';
import 'package:rein_player/features/player_frame/views/window_actions.dart';
import 'package:rein_player/features/player_frame/views/window_current_content_info.dart';
import 'package:rein_player/features/player_frame/views/window_player_menu.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';
import 'package:rein_player/utils/device/rp_device_utils.dart';

class RpWindowFrame extends StatelessWidget {
  const RpWindowFrame({super.key});

  @override
  Widget build(BuildContext context) {
    // On macOS, left padding to avoid overlapping with traffic light buttons
    final leftPadding = RpDeviceUtils.isMacOS() ? 70.0 : 0.0;

    return Container(
        height: 28,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: RpColors.gray_900,
        ),
        child: MoveWindow(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// menu
              Row(
                children: [
                  SizedBox(width: leftPadding),

                  /// player name and menu
                  const RpWindowPlayerMenu(),

                  /// black line
                  const RpVerticalDivider(),

                  /// video info
                  const RpWindowCurrentContentInfo(),
                ],
              ),

              /// window icons
              const RpWindowActions()
            ],
          ),
        ));
  }
}
