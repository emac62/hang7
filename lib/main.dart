import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/pages/options.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/pages/splash.dart';
import 'package:hang7/pages/welcome_page.dart';
import 'package:hang7/providers/unique_word.dart';
import 'package:hang7/widgets/material_color.dart';
import 'package:provider/provider.dart';

List<String> testDeviceIDs = [
  "8E3C44E0453B296DEDFBA106CDBB59CC", // Samsung S5
  "ea230aa9edfec099faea521e541b8502", //my phone
  "4520409bc3ffb536b6e203bf9d0b0007", //old SE
  "8f4cb8307ba6019ca82bccc419afe5d0", // my iPad
  "GADSimulatorID",
];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize().then((InitializationStatus status) {
    debugPrint('Initialization done: ${status.adapterStatuses}');
  });
  final RequestConfiguration requestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      testDeviceIds: testDeviceIDs);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  final double screenWidth =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;

  if (screenWidth <= 600) {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  runApp(
    const Hang7(),
  );
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
          "/": (context) => const SplashScreen(),
          "/gameBoard": (context) => const GameBoard(),
          "/options": (context) => const Options(),
          "/welcome": (context) => const WelcomePage()
        },
      ),
    );
  }
}
