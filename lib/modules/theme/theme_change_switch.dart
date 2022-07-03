
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class ChangeThemeSwitchWidget extends StatefulWidget {
  const ChangeThemeSwitchWidget({Key? key}) : super(key: key);
  @override
  State<ChangeThemeSwitchWidget> createState() => _ChangeThemeSwitchWidgetState();
}

class _ChangeThemeSwitchWidgetState extends State<ChangeThemeSwitchWidget> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return DayNightSwitcher(
      isDarkModeEnabled: Theme.of(context).primaryColor==Colors.white,
      onStateChanged: (value){
        //todo
      },
    );
  }
}
