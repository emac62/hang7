import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const apiKey = 'goog_UIjjIugdvmWTSDNSeCLtwDfoevi';
  static const apiKeyAS = 'appl_qpBpqgbPPzvoLhAcXmVpAkLsRxt';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);

    late PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(apiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(apiKeyAS);
    }
    await Purchases.configure(configuration);
  }
}
