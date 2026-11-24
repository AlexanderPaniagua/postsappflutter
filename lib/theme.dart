import 'package:material_ui/material_ui.dart';

const primaryColor = Color(0xFF3B5069);
const searchFillColor = Color(0xFFA9B4BF);
const searchHintColor = Color(0xFF5C6773);
const cardBorderColor = Color(0xFFD9D9D9);
const bubbleColor = Color(0xFFA4EBBD);
const photoTileColor = Color(0xFFF2E3E3);
const greyText = Color(0xFF333333);

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 3,
    shadowColor: Colors.black26,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: cardBorderColor),
    ),
  ),
);
