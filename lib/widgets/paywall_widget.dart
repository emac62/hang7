import 'package:flutter/material.dart';
import 'package:hang7/providers/settings_provider.dart';
import 'package:hang7/widgets/app_colors.dart';
import 'package:hang7/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;
  const PaywallWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.packages,
      required this.onClickedPackage})
      : super(key: key);

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  int coins = 0;

  @override
  Widget build(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    coins = settingsProvider.coins;
    Widget buildPackage(BuildContext context, Package package) {
      final product = package.storeProduct;
      return Container(
        padding: SizeConfig.screenWidth > 500
            ? EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 15)
            : EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 10),
        child: Card(
          color: Colors.transparent,
          child: ListTile(
            tileColor: AppColors.lightGray,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.darkBlue, width: 3),
                borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(8),
            title: Text(product.title),
            subtitle: Text(product.description),
            trailing: Text(product.priceString),
            onTap: () => widget.onClickedPackage(package),
          ),
        ),
      );
    }

    Widget buildPackages() => ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          return buildPackage(context, package);
        });

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.lightGray, AppColors.backgroundColor])),
      constraints: BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 75),
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeVertical * 5),
                    height: SizeConfig.blockSizeVertical * 8,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/BasketOfCoins.png"),
                      fit: BoxFit.scaleDown,
                    )),
                    child: Center(
                        child: Text(
                      coins.toString(),
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 6,
                      ),
                    ))),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 5),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                buildPackages(),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          )),
    );
  }
}
