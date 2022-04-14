import 'package:flutter/material.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/bottom_toolbar_item.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/bottom_toolbar_labels.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/items_functions/attachment_functions.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/items_functions/paste_functions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BottomToolbar extends StatelessWidget {
  final WebViewController webviewController;
  final bool hasAttachment;
  final String widthImage;
  final void Function() copyText;
  final BottomToolbarLabels bottomToolbarLabels;

  const BottomToolbar({
    Key? key,
    required this.webviewController,
    required this.hasAttachment,
    required this.widthImage,
    required this.copyText,
    required this.bottomToolbarLabels,
  }) : super(key: key);

  List<BottomToolbarItem> _generateBottomToolbar(BuildContext context) {
    var _toolbar = [
      BottomToolbarItem(
        onTap: copyText,
        icon: Icons.content_copy,
        label: bottomToolbarLabels.copyLabel,
      ),
      BottomToolbarItem(
        onTap: () => pasteText(webviewController),
        icon: Icons.content_paste,
        label: bottomToolbarLabels.pasteLabel,
      ),
    ];

    if (hasAttachment) {
      _toolbar.add(
        BottomToolbarItem(
          onTap: () => attach(
            context,
            webviewController,
            widthImage,
            bottomToolbarLabels,
          ),
          icon: Icons.attach_file,
          label: bottomToolbarLabels.attachmentLabel,
        ),
      );
    }

    return _toolbar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey[350]!),
          bottom: BorderSide(color: Colors.grey[350]!),
        ),
      ),
      child: Row(children: _generateBottomToolbar(context)),
    );
  }
}
