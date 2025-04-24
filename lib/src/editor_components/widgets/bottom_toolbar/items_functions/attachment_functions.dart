import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/bottom_toolbar_labels.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:webview_flutter/webview_flutter.dart';

final _imagePicker = ImagePicker();

void attach(
  BuildContext context,
  WebViewController _webViewController,
  String _widthImage,
  BottomToolbarLabels _bottomToolbarLabels,
) {
  Future<File?> _getImage(bool fromCamera) async {
    final picked = await _imagePicker.pickImage(
      source: (fromCamera) ? ImageSource.camera : ImageSource.gallery,
    );

    return picked != null ? File(picked.path) : null;
  }

  void _addImage(File image) async {
    String filename = basename(image.path);
    List<int> imageBytes = await image.readAsBytes();

    String base64Image =
        "<img width=\"$_widthImage\" src=\"data:image/png;base64, "
        "${base64Encode(imageBytes)}\" data-filename=\"$filename\">";

    String txt = "\$('.note-editable').append( '" + base64Image + "');";
    _webViewController.runJavaScript(txt);
  }

  SystemChannels.textInput.invokeMethod('TextInput.hide');

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(_bottomToolbarLabels.cameraLabel),
            subtitle: Text(
              _bottomToolbarLabels.cameraAttachmentDescriptionLabel,
            ),
            onTap: () async {
              Navigator.pop(context);
              final image = await _getImage(true);
              if (image != null) _addImage(image);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: Text(_bottomToolbarLabels.galleryLabel),
            subtitle: Text(
              _bottomToolbarLabels.galleryAttachmentDescriptionLabel,
            ),
            onTap: () async {
              Navigator.pop(context);
              final image = await _getImage(false);
              if (image != null) _addImage(image);
            },
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      );
    },
  );
}
