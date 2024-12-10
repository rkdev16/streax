import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/web_view/common_web_view_screen.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_card_widget.dart';

class LegalNoticeScreen extends StatelessWidget {
  const LegalNoticeScreen({Key? key}) : super(key: key);


  openWebView(String title,String url){
    Get.to(() =>CommonWebViewScreen(
        title: title,
        url: url),
      curve: Curves.easeIn,
      transition: Transition.downToUp
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.white),
      child: Scaffold(
        appBar: CommonAppBar(
          backgroundColor: Colors.white,
          title: 'legal_notice'.tr,
          onBackTap: () {
            Get.back();
          },
        ),
        body: Column(
          children: [
            CommonCardWidget(
              margin: const EdgeInsets.all(16),

              child: Column(
                children: [
                 _OptionTile(title: 'support'.tr, onTap: (){
                   openWebView('support', ApiUrls.privacyPolicy);
                 }),
               const   Divider(height: 0,),
                 _OptionTile(title: 'privacy_policy'.tr, onTap: () {
                        openWebView('privacy_policy', ApiUrls.privacyPolicy);
                 }),
                  const   Divider(height: 0,),
                 _OptionTile(title: 'terms_of_use'.tr, onTap: (){
                   openWebView('terms_of_use', ApiUrls.termsOfUse);
                 }),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


}

class _OptionTile extends StatelessWidget {
  const _OptionTile({super.key,
    required this.title,
    required this.onTap
  });
 final  VoidCallback onTap;
 final String title;


  @override
  Widget build(BuildContext context) {
    return   InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 16.fontMultiplier)),
            Icon(
              Icons.navigate_next_rounded,
              color: Colors.black.withOpacity(0.9),
            ),
          ],
        ),
      ),
    );
  }
}


