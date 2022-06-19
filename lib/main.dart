import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hang7/end_of_game.dart';
import 'package:hang7/game_layouts.dart/game_board.dart';
import 'package:hang7/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/splash.dart';
import 'package:hang7/welcome_page.dart';
import 'package:hang7/widgets/material_color.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  final double screenHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  debugPrint("screenWidth: $screenWidth");
  debugPrint("screenHeight: $screenHeight");
  if (screenWidth < 600) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  runApp(const Hang7());
}

class Hang7 extends StatelessWidget {
  const Hang7({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Controller()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Hang 7',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xff28375A)),
          fontFamily: "Boogaloo",
        ),
        routes: {
          "/": (context) => const SplashScreen(),
          "/gameBoard": (context) => const GameBoard(),
          "/options": (context) => const Options(),
          "/endOfGame": (context) => const EndOfGame(),
          "/welcome": (context) => const WelcomePage()
        },
      ),
    );
  }
}
