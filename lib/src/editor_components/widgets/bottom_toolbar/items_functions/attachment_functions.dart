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
  WebViewController webViewController,
  String widthImage,
  BottomToolbarLabels bottomToolbarLabels,
) {
  Future<File?> getImage(bool fromCamera) async {
    final picked = await _imagePicker.pickImage(
      source: (fromCamera) ? ImageSource.camera : ImageSource.gallery,
    );

    return picked != null ? File(picked.path) : null;
  }

  void addImage(File image) async {
    String filename = basename(image.path);
    List<int> imageBytes = await image.readAsBytes();

    String base64Image =
        "<img width=\"$widthImage\" src=\"data:image/png;base64, "
        "${base64Encode(imageBytes)}\" data-filename=\"$filename\">";

    String txt = "\$('.note-editable').append( '$base64Image');";
    webViewController.runJavaScript(txt);
  }

  SystemChannels.textInput.invokeMethod('TextInput.hide');

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(bottomToolbarLabels.cameraLabel),
            subtitle: Text(
              bottomToolbarLabels.cameraAttachmentDescriptionLabel,
            ),
            onTap: () async {
              Navigator.pop(context);
              final image = await getImage(true);
              if (image != null) addImage(image);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: Text(bottomToolbarLabels.galleryLabel),
            subtitle: Text(
              bottomToolbarLabels.galleryAttachmentDescriptionLabel,
            ),
            onTap: () async {
              Navigator.pop(context);
              final image = await getImage(false);
              if (image != null) addImage(image);
            },
          ),
        ],
      );
    },
  );
}
