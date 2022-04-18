import 'package:flutter/material.dart';
import 'package:flutter_summernote/src/editor_components/widgets/bottom_toolbar/bottom_toolbar_labels.dart';
import 'package:flutter_summernote/src/enums/langs/langs_available.dart';
import 'package:flutter_summernote/src/flutter_summernote_state.dart';

class FlutterSummernote extends StatefulWidget {
  /// **Boolean representing if the editor should support offline mode.**
  ///
  /// If true, it will be loaded with local js and css files. Otherwise, it will be loaded with online resources
  /// provided by Bootstrap, jQuery, Popper and Summernote teams.
  ///
  /// In the case of offline mode, the following only languages are supported:
  ///
  /// - en-US
  /// - en-US
  /// - es-ES
  /// - es-EU
  /// - fr-FR
  /// - pt-BR
  /// - pt-PT
  ///
  /// The property to edit the language in offline mode is [offlineModeLang].
  ///
  /// Default language is en-US.
  final bool offlineSupport;

  /// **Editor's initial HTML text content.**
  ///
  /// Example:
  ///
  /// ```dart
  /// "<p>Hello World!</p>"
  /// ```
  ///
  /// If null, the editor will start with empty text.
  ///
  /// Default value is null.
  final String? value;

  /// **Editor's height.**
  ///
  /// If null, the editor will fill all available height space.
  ///
  /// Default value is null.
  final double? height;

  /// **Editor's decoration.**
  ///
  /// If null, a standard decoration will be applied.
  ///
  /// Default value is null.
  final BoxDecoration? decoration;

  /// **Screen width percentage that all images to be added in the editor will have as their initial width.**
  ///
  /// Example:
  ///
  /// ```dart
  /// "80%"
  /// ```
  ///
  /// Default value is:
  /// ```dart
  /// "100%"
  /// ```
  final String widthImage;

  /// **Hint text to be displayed when the editor is empty.**
  ///
  /// If null, the editor will not display any hint.
  ///
  /// Default value is null.
  final String? hint;

  /// **Summernote Toolbar**
  ///
  /// Editor's toolbar.
  ///
  /// Example:
  ///
  /// ```dart
  /// """[
  ///   ['style', ['bold', 'italic', 'underline', 'clear']],
  ///   ['font', ['strikethrough', 'superscript', 'subscript']],
  /// ]"""
  /// ```
  ///
  /// To more details, see:
  ///   * Summernote - Custom toolbar, popover:
  ///   <https://summernote.org/deep-dive/#custom-toolbar-popover>
  ///
  /// If null, a standard toolbar will be used.
  ///
  /// Default value is null.
  final String? customToolbar;

  /// **Summernote Popover**
  ///
  /// Example:
  /// ```dart
  /// """{
  ///   table: [
  ///     ['add', ['addRowDown', 'addRowUp', 'addColLeft', 'addColRight']],
  ///     ['delete', ['deleteRow', 'deleteCol', 'deleteTable']],
  ///   ],
  /// }"""
  /// ```
  ///
  /// To more details, see:
  ///   * Summernote - Custom toolbar, popover:
  ///   <https://summernote.org/deep-dive/#custom-toolbar-popover>
  ///
  /// If null, a standard popover will be used.
  ///
  /// Default value is null.
  final String? customPopover;

  /// **Boolean representing if the bottom toolbar should have the Attach button.**
  ///
  /// If true, the bottom toolbar will show the Attach button. Otherwise, the option will be not displayed.
  ///
  /// Default value is false.
  final bool hasAttachment;

  /// **Boolean representing if the bottom toolbar should be displayed.**
  ///
  /// If true, the bottom toolbar will be displayed. Otherwise, it will be hidden.
  ///
  /// The bottom toolbar is composed of:
  ///
  /// - Copy button
  /// - Paste button
  /// - If [hasAttachment] is true, Attach button
  ///
  /// Default value is true.
  final bool showBottomToolbar;

  /// **Callback function to get text content from editor**
  ///
  /// Callback function used to return text content on `keyEditor.currentState.getText`
  /// function call. Where keyEditor is the key provided for this Widget.
  ///
  /// Default is null.
  final Function(String)? returnContent;

  /// **Labels to be displayed in the bottom toolbar.**
  ///
  /// The labels on the bottom toolbar are currently unaffected by languages propertys ([lang], [offlineModeLang]).
  /// So, to change the labels to preferred words, it's necessary set one by one using BottomToolbarLabels class.
  ///
  /// If null, default labels in English will be used.
  ///
  /// The default labels are:
  ///
  /// - copyLabel:
  ///   ```dart
  ///     "Copy"
  ///   ```
  /// - pasteLabel:
  ///   ```dart
  ///     "Paste"
  ///   ```
  /// - attachmentLabel:
  ///   ```dart
  ///     "Attach"
  ///   ```
  /// - cameraLabel:
  ///   ```dart
  ///     "Camera"
  ///   ```
  /// - galleryLabel:
  ///   ```dart
  ///     "Gallery"
  ///   ```
  /// - cameraAttachmentDescriptionLabel:
  ///   ```dart
  ///     "Attach image from camera"
  ///   ```
  /// - galleryAttachmentDescriptionLabel:
  ///   ```dart
  ///     "Attach image from gallery"
  ///   ```
  final BottomToolbarLabels bottomToolbarLabels;

  /// **Supported language in offline mode to be used in editor.**
  ///
  /// If null, the editor will use the lang property. If the lang property selected is not supported
  /// in offline mode and [offlineSupport] is true, the editor will use the default lang.
  ///
  /// Default value is null.
  final langsAvailableOffline? offlineModeLang;

  /// **Supported language by the editor to be used.**
  ///
  /// If [offlineSupport] is true **and** [offlineModeLang] is not set **and**
  /// the selected [lang] is not present in the list of supported by offline mode,
  /// then the editor will be loaded with the default language.
  ///
  /// If [offlineModeLang] has been set, this property will be ignored.
  ///
  /// Default value is: offlineModeLang.enUS
  final allLangsAvailable lang;

  const FlutterSummernote({
    Key? key,
    required this.offlineSupport,
    this.value,
    this.height,
    this.decoration,
    this.widthImage = "100%",
    this.hint,
    this.customToolbar,
    this.customPopover,
    this.hasAttachment = false,
    this.showBottomToolbar = true,
    this.returnContent,
    this.bottomToolbarLabels = const BottomToolbarLabels(),
    this.offlineModeLang,
    this.lang = allLangsAvailable.enUS,
  }) : super(key: key);

  @override
  FlutterSummernoteState createState() => FlutterSummernoteState();
}
