import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/bottom_toolbar.dart';
import 'package:flutter_summernote/src/enums/langs/langs_available.dart';
import 'package:flutter_summernote/src/flutter_summernote.dart';
import 'package:flutter_summernote/src/style/default_decoration.dart';
import 'package:flutter_summernote/src/webview/webview_callbacks.dart';
import 'package:flutter_summernote/src/editor_functions/editor_functions.dart'
    as lib_functions;
import 'package:webview_flutter/webview_flutter.dart';

// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class FlutterSummernoteState extends State<FlutterSummernote> {
  late WebViewController _webViewController;

  final Key _mapKey = UniqueKey();
  String text = "";

  PlatformWebViewControllerCreationParams get _params {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebKitWebViewControllerCreationParams();
    }

    return const PlatformWebViewControllerCreationParams();
  }

  WebKitWebViewController get _webKitWebViewController =>
      WebKitWebViewController(_params)
        ..setAllowsBackForwardNavigationGestures(true);

  void _initWebViewController() {
    setState(() {
      _webViewController =
          WebViewController.fromPlatform(_webKitWebViewController)
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..addJavaScriptChannel(
              'GetTextSummernote',
              onMessageReceived: _onMessageReceived,
            )
            ..setNavigationDelegate(
              NavigationDelegate(
                onWebResourceError: onWebResourceError,
                onPageStarted: _onPageStarted,
                onPageFinished: _onPageFinished,
              ),
            );
    });
  }

  void _onPageStarted(String _) {
    onWebViewCreated(
      _webViewController,
      widget.offlineSupport,
      widget.customToolbar,
      widget.customPopover,
    );
  }

  void _onMessageReceived(JavaScriptMessage message) {
    String isi = message.message;

    if (isi.isEmpty ||
        isi == "<p></p>" ||
        isi == "<p><br></p>" ||
        isi == "<p><br/></p>") {
      isi = "";
    }

    setState(() => text = isi);

    if (widget.returnContent != null) {
      widget.returnContent!(text);
    }
  }

  void _onPageFinished(String url) {
    lib_functions.initSummernote(
      _webViewController,
      widget.customToolbar,
      widget.customPopover,
      _getSelectedLang(),
    );

    setHint(widget.hint ?? "");
    setFullContainer();

    if (widget.value != null) {
      setText(widget.value!);
    }
  }

  allLangsAvailable _getSelectedLang() {
    if (widget.offlineModeLang != null) {
      return allLangsAvailable.values.firstWhere((element) {
        return element.name == widget.offlineModeLang?.name;
      });
    }
    return widget.lang;
  }

  @override
  void initState() {
    _initWebViewController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.height,
      decoration: widget.decoration ?? defaultDecoration,
      child: Column(
        children: [
          Expanded(
            child: WebViewWidget(
              key: _mapKey,
              controller: _webViewController,
              gestureRecognizers: gestureRecognizers,
            ),
          ),
          widget.showBottomToolbar
              ? BottomToolbar(
                  webviewController: _webViewController,
                  hasAttachment: widget.hasAttachment,
                  widthImage: widget.widthImage,
                  copyText: _copyText,
                  bottomToolbarLabels: widget.bottomToolbarLabels,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  void _copyText() {
    getText().then((value) => Clipboard.setData(ClipboardData(text: value)));
  }

  Future<String> getText() {
    String jsExpression =
        "setTimeout(function(){GetTextSummernote.postMessage(document.getElementsByClassName('note-editable')[0].innerHTML)}, 0);";

    return _webViewController.runJavaScript(jsExpression).then((_) {
      return Future.delayed(const Duration(milliseconds: 500))
          .then((_) => text);
    });
  }

  void setText(String text) => lib_functions.setText(_webViewController, text);
  void setHint(String hint) => lib_functions.setHint(_webViewController, hint);
  void setFullContainer() => lib_functions.setFullContainer(_webViewController);
  void setFocus() => lib_functions.setFocus(_webViewController);
  void setEmpty() => lib_functions.setEmpty(_webViewController);
}
