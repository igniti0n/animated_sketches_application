import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../contants.dart';
import '../../../core/widgets/settings_menu_button.dart';
import '../../../core/navigation/router.dart';
import '../../animation_preview_screen/animation_bloc/animation_bloc.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _animationBloc = BlocProvider.of<AnimationBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SettingsMenuButton(
          onTap: () {
            _animationBloc.add(ScreenStarted());
            Navigator.pushNamed(context, ANIMATION_PREVIEW_SCREEN_ROUTE);
          },
          text: "Prewiev animation",
          splashColor: purpleBar,
        ),
        // SettingsMenuButton(
        //   onTap: () => _overlayBloc.add(ShowColorPicker(
        //       currentColor: _drawingBloc.state.currentDrawing.backgroundColor,
        //       isForBackground: true,
        //       context:
        //           context)), //  => BlocProvider.of<OverlayBloc>(context).add(Show),
        //   text: "Change background color",
        //   splashColor: purpleBar,
        // ),
        // SettingsMenuButton(
        //   onTap: () {},
        //   text: "Export sketch",
        //   splashColor: purpleBar,
        // ),
        SettingsMenuButton(
          onTap: () {
            Navigator.of(context).pop();
          },
          text: "Back to drawing",
          splashColor: purpleBar,
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
