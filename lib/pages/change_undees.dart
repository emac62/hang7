import 'package:flutter/material.dart';
import 'package:hang7/animations/route.dart';
import 'package:hang7/pages/game_board.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/utils/get_current_undee.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:hang7/widgets/undee_box.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeUndees extends StatefulWidget {
  const ChangeUndees({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  State<ChangeUndees> createState() => _ChangeUndeesState();
}

class _ChangeUndeesState extends State<ChangeUndees> {
  late Image currentUndees;
  late String undeesStr;

  List<Widget> images = [
    Image.asset(
      'assets/images/pinkUndees.png',
      height: SizeConfig.blockSizeVertical * 1,
    ),
    Image.asset(
      'assets/images/whiteUndees.png',
      height: SizeConfig.blockSizeVertical * 1,
    ),
    Image.asset(
      'assets/images/blueUndees.png',
      height: SizeConfig.blockSizeVertical * 1,
    ),
    Image.asset(
      'assets/images/whiteTighties.png',
      height: SizeConfig.blockSizeVertical * 1,
    ),
    Image.asset(
      'assets/images/grayTighties.png',
      height: SizeConfig.blockSizeVertical * 1,
    ),
    Image.asset(
      'assets/images/blueTighties.png',
      height: SizeConfig.blockSizeVertical * 1,
    ),
  ];

  selectUndees(int index) {
    switch (index) {
      case 0:
        widget.prefs.setString('changeColor', "Pink");
        break;
      case 1:
        widget.prefs.setString('changeColor', "White");
        break;
      case 2:
        widget.prefs.setString('changeColor', "DarkBlue");
        break;
      case 3:
        widget.prefs.setString('changeColor', "WhiteTighties");
        break;
      case 4:
        widget.prefs.setString('changeColor', "GrayTighties");
        break;
      case 5:
        widget.prefs.setString('changeColor', "DarkBlueTighties");
        break;

      default:
    }
  }

  @override
  void initState() {
    super.initState();
    undeesStr = setUndees(widget.prefs);
    currentUndees = Image.asset(undeesStr);
    Image.asset(setUndees(widget.prefs));
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: AppColors.darkBlue),
            backgroundColor: AppColors.backgroundColor,
            toolbarHeight: SizeConfig.blockSizeVertical * 10,
            title: Text(
              "Change My Undees",
              style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: orientation == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal * 7
                      : SizeConfig.blockSizeVertical * 6),
            ),
          ),
          body: Consumer<Controller>(
            builder: (_, notifier, __) {
              return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.backgroundColor,
                          AppColors.lightGray
                        ]),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "My Undees",
                          style: TextStyle(
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeHorizontal * 8
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : SizeConfig.blockSizeVertical * 5,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: SizeConfig.blockSizeVertical * 10,
                              child: UndeesImageBox(
                                  undees: Image.asset(setUndees(widget.prefs))))
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
                        child: Text(
                          "Available Styles and Colours",
                          style: TextStyle(
                            fontSize: notifier.isPhone
                                ? SizeConfig.blockSizeHorizontal * 8
                                : orientation == Orientation.portrait
                                    ? SizeConfig.blockSizeHorizontal * 5
                                    : SizeConfig.blockSizeVertical * 5,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          child: GridView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    debugPrint(index.toString());
                                    setState(() {
                                      selectUndees(index);
                                    });
                                    debugPrint(
                                        widget.prefs.getString('changeColor'));
                                  },
                                  child: Container(
                                    //
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: AppColors.darkBlue, width: 2),
                                      //
                                    ),
                                    child: images[index],
                                  ));
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 4, //horizontal space
                                    crossAxisSpacing: 4, //vertical space
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.5),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: ElevatedButton(
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
                              Navigator.push(
                                  context,
                                  RotationRoute(
                                      page: GameBoard(
                                    prefs: widget.prefs,
                                  )));
                            },
                            child: Text(
                              "Play",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 3),
                            ),
                          ),
                        ),
                      )
                    ],
                  ));
            },
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: AppColors.violet,
                border: Border(
                    top: BorderSide(color: AppColors.darkBlue, width: 2))),
            height: 60,
          ));
    });
  }
}
