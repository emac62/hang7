import 'package:flutter/material.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool showAnimations = true;
  bool playSound = true;

  Future<void> clearSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
              toolbarHeight: SizeConfig.blockSizeVertical * 10,
              title: Text(
                "OPTIONS",
                style: TextStyle(
                    fontSize: orientation == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal * 7
                        : SizeConfig.blockSizeVertical * 6),
              )),
          body: Consumer<Controller>(
            builder: (_, notifier, __) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 5,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Play animations?',
                            style: TextStyle(
                              fontSize: notifier.isPhone
                                  ? SizeConfig.blockSizeHorizontal * 5
                                  : orientation == Orientation.portrait
                                      ? SizeConfig.blockSizeHorizontal * 5
                                      : SizeConfig.blockSizeVertical * 5,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 8,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Switch(
                                  activeColor: AppColors.green,
                                  inactiveThumbColor: AppColors.lightGray,
                                  value: settingsProvider.withAnimation,
                                  onChanged: (value) {
                                    setState(() {
                                      settingsProvider.setWithAnimation(value);
                                      if (value) {
                                        debugPrint("value $value");
                                      } else {}
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Play sound effects?',
                              style: TextStyle(
                                fontSize: notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : SizeConfig.blockSizeVertical * 5,
                              )),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 8,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Switch(
                                  activeColor: AppColors.green,
                                  inactiveThumbColor: AppColors.lightGray,
                                  value: settingsProvider.withSound,
                                  onChanged: (value) {
                                    setState(() {
                                      settingsProvider.setWithSound(value);
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text('UnDees Colour:',
                                style: TextStyle(
                                  fontSize: notifier.isPhone
                                      ? SizeConfig.blockSizeHorizontal * 5
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 5
                                          : SizeConfig.blockSizeVertical * 5,
                                )),
                          ),
                          Flexible(
                            flex: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(12),
                                    primary: AppColors.backgroundColor),
                                child: null,
                                onPressed: () {}),
                          ),
                          Flexible(
                            flex: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(12),
                                  primary: Colors.yellow,
                                ),
                                child: null,
                                onPressed: () {}),
                          ),
                          Flexible(
                            flex: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(12),
                                  primary: Colors.green,
                                ),
                                child: null,
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reset Stats",
                              style: TextStyle(
                                fontSize: notifier.isPhone
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : orientation == Orientation.portrait
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : SizeConfig.blockSizeVertical * 5,
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 10,
                                padding: EdgeInsets.all(
                                  notifier.isPhone
                                      ? SizeConfig.blockSizeHorizontal * 2
                                      : orientation == Orientation.portrait
                                          ? SizeConfig.blockSizeHorizontal * 2
                                          : SizeConfig.blockSizeVertical * 2,
                                ),
                              ),
                              onPressed: () {
                                clearSP();
                              },
                              child: Text("Reset",
                                  style: TextStyle(
                                    fontSize: notifier.isPhone
                                        ? SizeConfig.blockSizeHorizontal * 5
                                        : orientation == Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal * 5
                                            : SizeConfig.blockSizeVertical * 5,
                                  )))
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: AppColors.violet,
                border: Border(
                    top: BorderSide(color: AppColors.darkBlue, width: 2))),
            height: 60,
          ),
        );
      },
    );
  }
}
