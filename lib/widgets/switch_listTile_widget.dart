import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';


class SwitchListTileWidget extends StatelessWidget {
  const SwitchListTileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, themeProvider, Widget? child) {
        final isDark = themeProvider.getDarkTheme;
        return SwitchListTile(
          title: Text(isDark? 'Dark':'Light',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          secondary: Icon(isDark? Icons.dark_mode:Icons.light,
            color: Theme.of(context).iconTheme.color,
          ),
          value: themeProvider.getDarkTheme,
          onChanged: ( bool value) {
            themeProvider.setDarkTheme = value;
          },
        );
      },
    );
  }
}
