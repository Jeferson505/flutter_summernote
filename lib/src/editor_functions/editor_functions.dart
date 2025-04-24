import 'package:flutter_summernote/src/editor_components/widgets/default_popover.dart';
import 'package:flutter_summernote/src/editor_components/widgets/default_toolbar.dart';
import 'package:flutter_summernote/src/enums/langs/langs_available_functions.dart';
import 'package:flutter_summernote/src/enums/langs/langs_available.dart';
import 'package:webview_flutter/webview_flutter.dart';

void initSummernote(
  WebViewController? webViewController,
  String? customToolbar,
  String? customPopover,
  AllLangsAvailable lang,
) {
  String toolbar = customToolbar ?? defaultToolbar;
  String popover = customPopover ?? defaultPopover;

  webViewController?.runJavaScript("""\$("#summernote").summernote({
    lang: '${langToString(lang)}',
    tabsize: 2,
    placeholder: 'Your text here...',
    toolbar: $toolbar,
    popover: $popover,
  });""");
}

void setText(WebViewController? webViewController, String value) {
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
      "document.getElementsByClassName('note-editable')[0].innerHTML = '$txtIsi';";

  webViewController?.runJavaScript(txt);
}

void setFullContainer(WebViewController? webViewController) {
  webViewController?.runJavaScript(
    '\$("#summernote").summernote("fullscreen.toggle");',
  );
}

void setFocus(WebViewController? webViewController) {
  webViewController?.runJavaScript("\$('#summernote').summernote('focus');");
}

void setEmpty(WebViewController? webViewController) {
  webViewController?.runJavaScript("\$('#summernote').summernote('reset');");
}

void setHint(WebViewController? webViewController, String? text) {
  String hint = '\$(".note-placeholder").html("$text");';
  webViewController?.runJavaScript("setTimeout(function(){$hint}, 0);");
}
