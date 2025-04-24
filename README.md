# Flutter Summernote

Rich Text Editor in Flutter for Android and iOS to help free write WYSIWYG HTML code based on Summernote 0.8.20 javascript wrapper.

<img src="./screenshoot/home.png" width="250" alt="Example Project" /> &nbsp; <img src="./screenshoot/attach.png" width="250" alt="Attach Image Example" />

# NOTICE
> This package dependent to the [Official WebView Plugin](https://pub.dev/packages/webview_flutter). In this package can't add image, video, or another file using editor toolbar.
> To handle attach image this package give you another solution using image [Image Picker](https://pub.dev/packages/image_picker) at bottom of editor.
> This package can't use enableinteractiveSelection from TextField, to handle that this package give you another solution using copy paste at bottom of editor.
> Thank you for all your support.

## Setup

To use flutter_summernote dependency by this repository, add the following code to your pubspec.yaml in dependencies section:
```yaml
    flutter_summernote:
        git:
            url: https://github.com/Jeferson505/flutter_summernote.git
            ref: v2.0.0    
```

### iOS

Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

```xml
    <key>io.flutter.embedded_views_preview</key>
    <true/>

    <key>NSCameraUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Used to capture audio for image picker plugin</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Used to demonstrate image picker plugin</string>

    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
```

### Usage

1. import flutter html editor
```dart
    import 'package:flutter_summernote/flutter_summernote.dart';
```

2. Create Global key from HTML Editor State
```dart
    GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
```

3. Add HTML Editor to widget
```dart
    FlutterSummernote(
        key: _keyEditor,
        offlineSupport: true,
    )
```

4. Get text from Html Editor
```dart
    final _etEditor = await keyEditor.currentState.getText();
```


### Available option parameters

Parameter | Type | Default | Description
------------ | ------------- | ------------- | -------------
**key** | GlobalKey<FlutterSummernoteState> | **required** | For get method & reset
**offlineSupport** | bool | **required** | Boolean representing if the editor should support offline mode
**value** | String | null | Editor's initial HTML text content
**height** | double | null | Editor's height
**decoration** | BoxDecoration | null | Editor's decoration
**widthImage** | String | 100% | Screen width percentage that all images to be added in the editor will have as their initial width
**hint** | String | null | Hint text to be displayed when the editor is empty
**customToolbar** | String | null | Add all available [Toolbar](https://summernote.org/deep-dive/#custom-toolbar-popover). Don't use insert (video & picture), please use **hasAttachment** option.
**customPopover** | String | null | Add all available [Popover](https://summernote.org/deep-dive/#custom-toolbar-popover) (the same paragraph as for toolbar, but below)
**hasAttachment** | bool | false | Boolean representing if the bottom toolbar should have the Attach button
**showBottomToolbar** | bool | true | Boolean representing if the bottom toolbar should be displayed
**returnContent** | Function(String) | null | Callback function to get text content from editor
**bottomToolbarLabels** | BottomToolbarLabels | null | Labels to be displayed in the bottom toolbar
**offlineModeLang** | LangsAvailableOffline | null | Supported language in offline mode to be used in editor
**lang** | AllLangsAvailable | `AllLangsAvailable.enUS` | Supported language to be used in editor

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
