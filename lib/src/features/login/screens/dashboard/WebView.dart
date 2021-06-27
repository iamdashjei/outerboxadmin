import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';
//import 'package:webview_flutter/webview_flutter.dart';


class WebViewPage extends StatefulWidget {

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> with AfterLayoutMixin<WebViewPage>{
  // final Completer<WebViewController> _controller =
  // Completer<WebViewController>();
  //
  // WebViewController _webViewController;

  //String url = '';

  //InAppWebViewController webViewController;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  double opacityValue = 0;
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: EdgeInsets.only(top: 25),
    //   child: WebView(
    //     onWebViewCreated: (WebViewController webViewController) {
    //       _webViewController = webViewController;
    //     },
    //     javascriptMode: JavascriptMode.unrestricted,
    //     gestureNavigationEnabled: true,
    //     initialUrl: new Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),//new Uri.dataFromString(_loadHtml(), mimeType: 'text/html').toString()//'https://pos.outerboxcloud.com',
    //   ),
    // );
    // return Container(
    //   margin: EdgeInsets.only(top: 25),
    //   child: WebviewScaffold(
    //     withJavascript: true,
    //     appCacheEnabled: true,
    //     url: 'https://pos.outerboxcloud.com'
    //   ),
    // );

    return Scaffold(
      body: Opacity(
        opacity: 1,
        child: Container(
        margin: opacityValue == 0 ? EdgeInsets.only(top: MediaQuery.of(context).size.height) : EdgeInsets.only(top: 25),
        child: WebviewScaffold(
          withJavascript: true,
          appCacheEnabled: true,
          url: 'https://pos.outerboxcloud.com',
        ),
      ),)
    );
  }



  void postUrl() async {
    String email = await UserSessions.getUserEmail();
    String password = await UserSessions.getUserPassword();

    //print("Email => " + email);
    //print("Password => " + password);
    String toExecute = "document.getElementById('email').value = \'"+ email +
        "\'; document.getElementById('password').value = \'"+ password +"\'; document.getElementsByTagName('form')[0].submit();";

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {

        flutterWebViewPlugin.evalJavascript(toExecute);

      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {

          opacityValue = 1;
        });

      });

    });




  }


  @override
  void initState() {
    super.initState();
    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    postUrl();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.
   // postUrl();
  }
}
