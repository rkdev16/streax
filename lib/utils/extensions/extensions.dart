

import 'package:streax/consts/app_consts.dart';

extension ExtendedDoube on double {
  double get fontMultiplier {
    return AppConsts.commonFontSizeFactor * this;
  }
}

extension ExtendedInt on int {
  double get fontMultiplier {
    return AppConsts.commonFontSizeFactor * this;
  }
}




