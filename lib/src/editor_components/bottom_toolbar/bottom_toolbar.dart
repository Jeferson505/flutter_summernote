import 'package:flutter/material.dart';
import 'package:flutter_summernote/src/editor_components/bottom_toolbar/items_functions/attachment_functions.dart';
import 'package:flutter_summernote/src/editor_components/bottom_toolbar/bottom_toolbar_item.dart';
import 'package:flutter_summernote/src/editor_components/bottom_toolbar/items_functions/paste_functions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottomToolbar extends StatelessWidget {
  final WebViewController webviewController;
  final bool hasAttachment;
  final String widthImage;
  final void Function() copyText;

  const BottomToolbar({
    Key? key,
    required this.webviewController,
    required this.hasAttachment,
    required this.widthImage,
    required this.copyText,
  }) : super(key: key);

  List<BottomToolbarItem> _generateBottomToolbar(BuildContext context) {
    var _toolbar = [
      BottomToolbarItem(
        onTap: copyText,
        icon: Icons.content_copy,
        label: "Copy",
      ),
      BottomToolbarItem(
        onTap: () => pasteText(webviewController),
        icon: Icons.content_paste,
        label: "Paste",
      ),
    ];

    if (hasAttachment) {
      _toolbar.add(
        BottomToolbarItem(
          onTap: () => attach(context, webviewController, widthImage),
          icon: Icons.attach_file,
          label: "Attach",
        ),
      );
    }

    return _toolbar;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: _generateBottomToolbar(context)),
    );
  }
}
