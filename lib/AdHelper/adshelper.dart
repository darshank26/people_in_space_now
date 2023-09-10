import 'dart:io';

class AdHelper {

  static String get bannerAdUnitIdOfHomeScreen {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2180535035689124/9279695503';
    }  else {
      throw UnsupportedError('Unsupported platform');
    }
  }


  static String get appOpenAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2180535035689124/3699269603';
    }  else {
      throw UnsupportedError('Unsupported platform');
    }
  }

}