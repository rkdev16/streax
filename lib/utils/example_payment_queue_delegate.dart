import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper{
  @override
  bool shouldContinueTransaction(SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    // TODO: implement shouldContinueTransaction
   return true;
  }

  @override
  bool shouldShowPriceConsent() {
    // TODO: implement shouldShowPriceConsent
    return true;
  }

}