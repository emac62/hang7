import 'package:flutter/material.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';

import '../providers/controller.dart';
import '../utils/get_current_undee.dart';

class UndeesBasket extends StatefulWidget {
  const UndeesBasket({Key? key}) : super(key: key);

  @override
  State<UndeesBasket> createState() => _UndeesBasketState();
}

class _UndeesBasketState extends State<UndeesBasket> {
  late Image currentUndees;

  @override
  void initState() {
    super.initState();
    currentUndees = Image.asset(setUndees(context));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Controller>(builder: (_, notifier, __) {
      return SizedBox(
        height: SizeConfig.blockSizeVertical * 6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            notifier.remainingGuesses > 0
                ? SizedBox(
                    height: SizeConfig.blockSizeVertical * 4,
                    child: currentUndees)
                : SizedBox(
                    height: SizeConfig.blockSizeVertical * 7,
                  ),
            Image.asset(
              'assets/images/emptyBasket.png',
              fit: BoxFit.scaleDown,
              height: SizeConfig.blockSizeVertical * 9,
            )
          ],
        ),
      );
    });
  }
}
