import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebViewScreen extends StatefulWidget {
  const CommonWebViewScreen(
      {super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<CommonWebViewScreen> createState() => _CommonWebViewScreenState();
}

class _CommonWebViewScreenState extends State<CommonWebViewScreen> {
  late WebViewController controller;
  bool isLoading = true;

  initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {
            //update loading bar
          },
          onPageStarted: (String url) {
            debugPrint("OnPageStarted");
            setState(() {
              isLoading = true;
            });

          },
          onPageFinished: (String url) {
            debugPrint("OnPageFinished");
            setState(() {
              isLoading = false;
            });

          },
          onWebResourceError: (WebResourceError error) {}))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.title.tr,onBackTap: (){
        Navigator.of(context).pop();
      },),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
      child: isLoading? const  CommonProgressBar():  WebViewWidget(controller: controller),)
    );
  }
}
