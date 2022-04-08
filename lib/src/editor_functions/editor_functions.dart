import 'package:webview_flutter/webview_flutter.dart';

void setText(WebViewController? _webViewController, String value) {
  String txtIsi = value
      .replaceAll("'", '\\"')
      .replaceAll('"', '\\"')
      .replaceAll("[", "\\[")
      .replaceAll("]", "\\]")
      .replaceAll("\n", "<br/>")
      .replaceAll("\n\n", "<br/>")
      .replaceAll("\r", " ")
      .replaceAll('\r\n', " ");

  String txt =
      "document.getElementsByClassName('note-editable')[0].innerHTML = '" +
          txtIsi +
          "';";

  _webViewController?.runJavascript(txt);
}

void setFullContainer(WebViewController? _webViewController) {
  _webViewController?.runJavascript(
    '\$("#summernote").summernote("fullscreen.toggle");',
  );
}

void setFocus(WebViewController? _webViewController) {
  _webViewController?.runJavascript(
    "\$('#summernote').summernote('focus');",
  );
}

void setEmpty(WebViewController? _webViewController) {
  _webViewController?.runJavascript(
    "\$('#summernote').summernote('reset');",
  );
}

void setHint(WebViewController? _webViewController, String? text) {
  String hint = '\$(".note-placeholder").html("$text");';
  _webViewController?.runJavascript(
    "setTimeout(function(){$hint}, 0);",
  );
}
