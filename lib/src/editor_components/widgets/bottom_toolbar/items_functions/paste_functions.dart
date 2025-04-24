import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

pasteText(WebViewController _webViewController) {
  Clipboard.getData(Clipboard.kTextPlain).then((data) {
    if (data?.text != null) {
      String txtIsi = data!.text!
          .replaceAll("'", '\\"')
          .replaceAll('"', '\\"')
          .replaceAll("[", "\\[")
          .replaceAll("]", "\\]")
          .replaceAll("\n", "<br/>")
          .replaceAll("\n\n", "<br/>")
          .replaceAll("\r", " ")
          .replaceAll('\r\n', " ");

      String txt = "\$('.note-editable').append( '$txtIsi');";
      _webViewController.runJavaScript(txt);
    }
  });
}
