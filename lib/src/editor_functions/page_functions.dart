import 'package:flutter_summernote/src/editor_components/css/bootstrap_css.dart';
import 'package:flutter_summernote/src/editor_components/css/summernote_css.dart';
import 'package:flutter_summernote/src/editor_components/default_popover.dart';
import 'package:flutter_summernote/src/editor_components/default_toolbar.dart';
import 'package:flutter_summernote/src/editor_components/js/bootstrap_js.dart';
import 'package:flutter_summernote/src/editor_components/js/jquery_js.dart';
import 'package:flutter_summernote/src/editor_components/js/summernote_js.dart';

String initPage(String? customToolbar, String? customPopover) {
  String toolbar = customToolbar ?? defaultToolbar;
  String popover = customPopover ?? defaultPopover;

  return '''
    <!DOCTYPE html>
    <html lang="pt-BR">
      <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

        <title>Summernote</title>
        <style type="text/css">$bootstrapCSS</style>
        <style type="text/css">$summernoteCSS</style>
        <script type="text/javascript">$jQueryJS</script>
        <script type="text/javascript">$bootstrapJS</script>
        <script type="text/javascript">$summernoteJS</script>
      </head>
      <body>
        <div id="summernote" contenteditable="true"></div>
        <script type="text/javascript">
          \$("#summernote").summernote({
            lang: 'pt-BR',
            tabsize: 2,
            placeholder: 'Your text here...',
            toolbar: $toolbar,
            popover: {$popover},
          });
        </script>
      </body>
    </html>
    ''';
}
