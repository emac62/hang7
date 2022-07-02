import 'package:flutter/material.dart';
import 'package:hang7/widgets/size_config.dart';

class StatsBox extends StatelessWidget {
  const StatsBox({
    required this.heading,
    required this.value,
    Key? key,
  }) : super(key: key);

  final String heading;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: const Alignment(0, 1),
              child: Padding(
                padding: const EdgeInsets.all(0.5),
                child: Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontSize: 32,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              alignment: const Alignment(0, -1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                child: Text(
                  heading,
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeVertical * 3.5),
                  // style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  //       fontWeight: FontWeight.normal,
                  //       fontSize: 12,
                  //     ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
