import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/bottom_toolbar.dart';
import 'package:flutter_summernote/src/enums/langs/langs_available.dart';
import 'package:flutter_summernote/src/flutter_summernote.dart';
import 'package:flutter_summernote/src/style/default_decoration.dart';
import 'package:flutter_summernote/src/webview/webview_callbacks.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_summernote/src/editor_functions/editor_functions.dart'
    as lib_functions;

class FlutterSummernoteState extends State<FlutterSummernote> {
  WebViewController? _webViewController;
  String text = "";
  final Key _mapKey = UniqueKey();

  void _setWebViewController(WebViewController webViewController) {
    setState(() => _webViewController = webViewController);
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
  void dispose() {
    if (_webViewController != null) _webViewController = null;
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
            child: WebView(
              key: _mapKey,
              onWebResourceError: onWebResourceError,
              onWebViewCreated: (webViewController) => onWebViewCreated(
                webViewController,
                _setWebViewController,
                widget.offlineSupport,
                widget.customToolbar,
                widget.customPopover,
              ),
              javascriptMode: JavascriptMode.unrestricted,
              gestureNavigationEnabled: true,
              gestureRecognizers: gestureRecognizers,
              javascriptChannels: {getTextJavascriptChannel(context)},
              onPageFinished: (String url) {
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
              },
            ),
          ),
          widget.showBottomToolbar && _webViewController != null
              ? BottomToolbar(
                  webviewController: _webViewController!,
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

  JavascriptChannel getTextJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'GetTextSummernote',
      onMessageReceived: (JavascriptMessage message) {
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
      },
    );
  }

  void _copyText() {
    getText().then((value) => Clipboard.setData(ClipboardData(text: value)));
  }

  Future<String> getText() {
    String jsExpression =
        "setTimeout(function(){GetTextSummernote.postMessage(document.getElementsByClassName('note-editable')[0].innerHTML)}, 0);";

    return _webViewController!.runJavascript(jsExpression).then((_) {
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
