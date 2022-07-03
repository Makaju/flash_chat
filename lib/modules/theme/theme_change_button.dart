
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flash_chat/modules/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatefulWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  State<ChangeThemeButtonWidget> createState() => _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return
      //   Switch.adaptive(value: themeProvider.isDarkMode, onChanged:(value){
      //   final provider = Provider.of<ThemeProvider>(context, listen: false);
      //   provider.toggleTheme(value);
      // } )
      DayNightSwitcherIcon(
        isDarkModeEnabled: Theme.of(context).primaryColor==Colors.white,
        onStateChanged: (value){setState((){
          // final provider = Provider.of<ThemeProvider>(context, listen: false);
          // Provider.of<ThemeProvider>(context, listen: false).swapTheme();
        });},
      );
  }
}
