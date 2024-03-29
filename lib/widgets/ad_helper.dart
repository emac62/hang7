import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1618980018345182/6375521605';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1618980018345182/9379021091';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1618980018345182/7504770449";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1618980018345182/2722113407";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get testBannerAdUnitID {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get testInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
