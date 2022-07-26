import 'package:flutter/material.dart';
import 'package:hang7/animations/dance.dart';
import 'package:hang7/providers/controller.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/letter_tile.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';

class WordGrid extends StatefulWidget {
  const WordGrid({Key? key, required this.orientation}) : super(key: key);
  final Orientation orientation;

  @override
  State<WordGrid> createState() => _WordGridState();
}

class _WordGridState extends State<WordGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
          horizontal: widget.orientation == Orientation.portrait
              ? SizeConfig.blockSizeHorizontal * 7
              : SizeConfig.blockSizeHorizontal * 20,
          vertical: SizeConfig.blockSizeVertical * 1),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: widget.orientation == Orientation.portrait
              ? SizeConfig.screenHeight < 750
                  ? 0.5
                  : 0.5
              : SizeConfig.screenHeight > 750
                  ? 0.75
                  : 0.5),
      itemCount: 7,
      itemBuilder: (context, index) {
        var settingsProvider = Provider.of<SettingsProvider>(context);
        return Consumer<Controller>(
          builder: (_, notifier, __) {
            bool animate = false;
            int danceDelay = 1600;
            if (notifier.gameWon) {
              for (var i = 0; i < 7; i++) {
                if (index == i) {
                  animate = true;
                  danceDelay += 150 * i;
                }
              }
            }

            return Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 2)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: settingsProvider.withAnimation
                    ? Dance(
                        animate: animate,
                        delay: danceDelay,
                        child: LetterTile(
                          index: index,
                          orientation: widget.orientation,
                        ))
                    : LetterTile(
                        index: index,
                        orientation: widget.orientation,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
