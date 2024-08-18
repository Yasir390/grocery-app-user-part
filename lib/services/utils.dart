import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';

class Utils{
  BuildContext context;

  Utils(this.context);

  bool get getTheme => Provider.of<ThemeProvider>(context).getDarkTheme;
  Color get color => getTheme ? Colors.white: Colors.black;
}