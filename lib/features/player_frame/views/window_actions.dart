import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rein_player/utils/constants/rp_app_icons.dart';
import 'package:rein_player/features/player_frame/controller/window_actions_controller.dart';
import 'package:rein_player/utils/constants/rp_colors.dart';
import 'package:rein_player/utils/constants/rp_sizes.dart';
import 'package:rein_player/utils/device/rp_device_utils.dart';

import '../../../common/widgets/rp_vertical_divider.dart';

class RpWindowActions extends StatelessWidget {
  const RpWindowActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMacOS = RpDeviceUtils.isMacOS();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RpVerticalDivider(),
        const SizedBox(width: 10),

        /// pin window
        Obx(
          () => InkWell(
            onTap: WindowActionsController.to.togglePin,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: RpSizes.sm),
              height: 58,
              child: WindowActionsController.to.isPinned.value
                  ? SvgPicture.asset(
                      RpAppIcons.pinDownIcon,
                      colorFilter: const ColorFilter.mode(
                          RpColors.accent, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(RpAppIcons.pinDownIcon),
            ),
          ),
        ),
        const SizedBox(width: 10),

        /// minimize (hidden on macOS - use traffic light button)
        if (!isMacOS) ...[
          InkWell(
            onTap: WindowActionsController.to.minimizeWindow,
            child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: RpSizes.sm),
                height: 58,
                child: SvgPicture.asset(RpAppIcons.minimizeIcon)),
          ),
          const SizedBox(width: 10),
        ],

        /// maximize (hidden on macOS - use traffic light button)
        if (!isMacOS) ...[
          InkWell(
            onTap: WindowActionsController.to.maximizeOrRestoreWindow,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: RpSizes.sm),
              height: 58,
              child: SvgPicture.asset(RpAppIcons.maximizeIcon),
            ),
          ),
          const SizedBox(width: 10),
        ],

        /// fullscreen mode
        InkWell(
          onTap: WindowActionsController.to.toggleFullScreenWindow,
          child: SvgPicture.asset(RpAppIcons.fullscreenIcon),
        ),
        const SizedBox(width: 10),

        /// close (hidden on macOS - use traffic light button)
        if (!isMacOS)
          InkWell(
            onTap: WindowActionsController.to.closeWindow,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: RpSizes.sm),
              height: 58,
              child: SvgPicture.asset(RpAppIcons.closeIcon),
            ),
          ),
        const SizedBox(width: 9)
      ],
    );
  }
}
