import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/model/one_time_purchases_res_model.dart';
import 'package:streax/model/subscription_plans_res_model.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/example_payment_queue_delegate.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class SubscriptionsController extends GetxController {
  final isLoadingOneTimePurchase = false.obs;
  final isLoadingSubscriptions = false.obs;
  final isLoadingPage = false.obs;
  final isSubscriptionLoading = false.obs;

  late PageController pageController;

  RxInt selectedSubscriptionIndex = 1.obs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isStoreAvailable = false;

  final oneTimePlans = <OneTimePlansData>[].obs;
  final subscriptionPlans = <SubscriptionPlan>[].obs;

  InAppProductType? selectedInAppProductType;
  OneTimePlan? selectedOneTimePlan;
  SubscriptionPlan? selectedSubscriptionPlan;

  @override
  void onInit() {
    super.onInit();
    pageController =
        PageController(initialPage: selectedSubscriptionIndex.value);
    debugPrint("Index = ${selectedSubscriptionIndex.value}");

    final Stream<List<PurchaseDetails>> purchaseUpdate =
        _inAppPurchase.purchaseStream;

    _subscription =
        purchaseUpdate.listen((List<PurchaseDetails> purchaseDetails) {
      Map<String, PurchaseDetails> purchases =
          Map.fromEntries(purchaseDetails.map((PurchaseDetails purchase) {
        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      }));
      debugPrint(purchases.toString());
      _listenToPurchaseUpdated(purchaseDetails);
    }, onDone: () {
      debugPrint("ONDoneCalled");
      _subscription.cancel();
    }, onError: (Object error) {
      debugPrint("OnErrorCalled");

      //   _inAppPurchase.completePurchase(purchaseDetails);
      //handle error here
    });
    initStoreInfo();
  }

  @override
  void onReady() {
    super.onReady();
    getOneTimePlans();
    getSubscriptions();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    debugPrint("IsStoreAvailable = $isAvailable");
    _isStoreAvailable = isAvailable;
    if (isAvailable) {
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _inAppPurchase
                .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }
    }
  }

  Future<ProductDetails?> queryProductDetail(String productId) async {
    if (!_isStoreAvailable) {
      AppAlerts.error(message: 'message_store_not_available'.tr);
      return null;
    }
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails({productId});

    debugPrint(
        "ProductDetailsResponse = ${productDetailResponse.productDetails.first.price}");

    if (productDetailResponse.error != null) {
      AppAlerts.error(message: productDetailResponse.error!.message);
      return null;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      AppAlerts.error(message: 'message_product_not_found'.tr);
      return null;
    }

    return productDetailResponse.productDetails.first;
  }

  purchaseOneTimePlan(OneTimePlan plan) async {
    plan.loading.value = true;
    isSubscriptionLoading.value = true;
    final productId =
        Platform.isAndroid ? plan.androidProductId : plan.iosProductId;

    if (productId == null) {
      return;
    }

    final ProductDetails? productDetails = await queryProductDetail(productId);

    if (productDetails != null) {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      bool result =
          await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);

      if (result) {
        selectedInAppProductType = InAppProductType.consumable;
        selectedOneTimePlan = plan;
        debugPrint('One Time Purchase successful, handle accordingly');
        debugPrint('result ---- $selectedInAppProductType');
        Future.delayed((Duration(seconds: 2)), () {
          plan.loading.value = false;
          isSubscriptionLoading.value = false;
        });
      } else {
        clearSelectedPlans();
        debugPrint('One Time Purchase failed, handle accordingly');
        Future.delayed((Duration(seconds: 1)), () {
          plan.loading.value = false;
          isSubscriptionLoading.value = false;
        });
      }
    }
  }

  purchaseSubscriptionPlan(SubscriptionPlan plan) async {
    selectedSubscriptionPlan = plan;
    selectedInAppProductType = InAppProductType.nonConsumable;
    isSubscriptionLoading.value = true;
    final productId = Platform.isAndroid ? plan.androidPlanId : plan.iosPlanId;

    if (productId == null) {
      return;
    }

    final ProductDetails? productDetails = await queryProductDetail(productId);

    if (productDetails != null) {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);

      bool result =
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      debugPrint('result ---- $result');

      if (result) {
        selectedInAppProductType = InAppProductType.nonConsumable;
        selectedSubscriptionPlan = plan;
        debugPrint('Subscription Purchase successful, handle accordingly');
        Future.delayed((Duration(seconds: 2)), () {
          isSubscriptionLoading.value = false;
        });
      } else {
        clearSelectedPlans();
        isSubscriptionLoading.value = false;
        debugPrint('Subscription Purchase failed, handle accordingly');
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.error) {
        clearSelectedPlans();
        await _inAppPurchase.completePurchase(purchaseDetails);
        AppAlerts.alert(
            message: '${'message_purchase_error'.tr} ${purchaseDetails.error}');
        //  handleError(purchaseDetails.error!);
        debugPrint('sdfsdfs================= ${purchaseDetails.error}');
      } else if (purchaseDetails.status == PurchaseStatus.pending) {
        // clearSelectedPlans();
        debugPrint("PurchasePending");
        // AppAlerts.alert(message: 'message_purchase_pending'.tr);
        // await _inAppPurchase.completePurchase(purchaseDetails);
        //  handleError(purchaseDetails.error!);
        // showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        clearSelectedPlans();
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
        //  handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        debugPrint("Item Purchased! => Need to verify purchase");
        debugPrint("PurchaseDetail = $purchaseDetails");
        debugPrint("SelectedInAppProductType = $selectedInAppProductType");

        if (selectedInAppProductType == InAppProductType.consumable) {
          Map<String, dynamic> requestBody = {
            'oneTimeProductId': selectedOneTimePlan?.id
          };
          debugPrint("oneTimeProductId = ${selectedOneTimePlan?.id}");
          updateOneTimePurchaseSuccess(requestBody);
        } else if (selectedInAppProductType == InAppProductType.nonConsumable) {
          Map<String, dynamic> requestBody = Platform.isAndroid
              ? {
                  'planId': selectedSubscriptionPlan?.id,
                  'purchaseToken':
                      purchaseDetails.verificationData.serverVerificationData,
                }
              : {
                  'iosPlanId': purchaseDetails.productID,
                  'originalTransactionId':
                      purchaseDetails.verificationData.localVerificationData,
                  // 'originalTransactionId': purchaseDetails.verificationData.serverVerificationData,
                };
          debugPrint("planId = ${selectedSubscriptionPlan?.id}");
          debugPrint("productID = ${purchaseDetails.productID}");
          debugPrint("purchaseID = ${purchaseDetails.purchaseID}");
          updateSubscriptionPurchaseSuccess(requestBody);
        }
        clearSelectedPlans();
      }
    }
  }

  //   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
  //     final url = Uri.parse('http://serverIp:8080/verifypurchase');
  //     const headers = {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //     };
  //     final response = await http.post(
  //       url,
  //       body: jsonEncode({
  //         'source': purchaseDetails.verificationData.source,
  //         'productId': purchaseDetails.productID,
  //         'verificationData':
  //         purchaseDetails.verificationData.serverVerificationData,
  //        // 'userId': firebaseNotifier.user?.uid,
  //       }),
  //       headers: headers,
  //     );
  //     if (response.statusCode == 200) {
  //       print('Successfully verified purchase');
  //       return true;
  //     } else {
  //       print('failed request: ${response.statusCode} - ${response.body}');
  //       return false;
  //     }
  //   }
  // }

  getOneTimePlans() async {
    try {
      isLoadingOneTimePurchase.value = true;
      var result = await GetRequests.fetchOneTimePlans();
      if (result != null) {
        if (result.success) {
          oneTimePlans.assignAll(result.oneTimePlansData ?? []);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoadingOneTimePurchase.value = false;
    }
  }

  updateOneTimePurchaseSuccess(Map<String, dynamic> requestBody) async {
    try {
      isLoadingPage.value = true;
      final result =
          await PostRequests.updateOneTimePurchaseSuccess(requestBody);
      if (result != null) {
        if (result.success) {
          Get.find<ProfileController>().getUserProfile();
          debugPrint("updated Profile");
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoadingPage.value = false;
    }
  }

  updateSubscriptionPurchaseSuccess(Map<String, dynamic> requestBody) async {
    try {
      isLoadingPage.value = true;
      final result =
          await PostRequests.updateSubscriptionPurchaseSuccess(requestBody);
      if (result != null) {
        if (result.success) {
          Get.find<ProfileController>().getUserProfile();
          debugPrint("updated Profile");
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoadingPage.value = false;
    }
  }

  getSubscriptions() async {
    try {
      isLoadingSubscriptions.value = true;
      final result = await GetRequests.fetchSubscriptions();
      if (result != null) {
        if (result.success) {
          subscriptionPlans.assignAll(result.subscriptionPlans ?? []);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoadingSubscriptions.value = false;
    }
  }

  clearSelectedPlans() {
    selectedSubscriptionPlan = null;
    selectedOneTimePlan = null;
    selectedInAppProductType = null;
  }
}
