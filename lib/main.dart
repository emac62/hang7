import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/pages/splash.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/providers/unique_word.dart';
import 'package:hang7/widgets/material_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;

  if (screenWidth < 600) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
  var prefs = await SharedPreferences.getInstance();
  runApp(
    Hang7(
      prefs: prefs,
    ),
  );
}

class Hang7 extends StatelessWidget {
  const Hang7({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Controller()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (_) => UniqueWord(),
        ),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        title: 'Hang 7',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xff28375A)),
          fontFamily: "Boogaloo",
        ),
        routes: {
          "/": (context) => SplashScreen(
                prefs: prefs,
              ),
          "/gameBoard": (context) => GameBoard(
                prefs: prefs,
              ),
          "/options": (context) => Options(prefs: prefs),
          "/welcome": (context) => WelcomePage(prefs: prefs)
        },
      ),
    );
  }
}
