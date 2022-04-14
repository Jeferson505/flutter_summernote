import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:developer' as developer;

void onWebResourceError(WebResourceError e) {
  if (kDebugMode) {
    developer.log(
      "Flutter Summernote - WebViewResourceError (${DateTime.now()})",
      name: "Flutter Summernote",
      error:
          "${e.description}\nError Type:${e.errorType}\nError Code:${e.errorCode}\nDomain:${e.domain}\nFailingUrl:${e.failingUrl}",
    );
  }
}

void onWebViewCreated(
  WebViewController webViewController,
  void Function(WebViewController) setWebViewController,
  bool offlineMode,
  String? customToolbar,
  String? customPopover,
) {
  String htmlFile = offlineMode ? "offline_summernote.html" : "summernote.html";
  String key =
      "packages/flutter_summernote/src/editor_components/core/$htmlFile";

  webViewController.loadFlutterAsset(key).then((_) {
    setWebViewController(webViewController);
  });
}

Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
  Factory(
    () => VerticalDragGestureRecognizer()..onUpdate = (_) {},
  ),
};
