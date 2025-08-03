/*
 * Flutter Summernote 2.0 - Core Types and Enums
 * 
 * Defines all the core types, enums, and data structures used throughout the package
 */

/// Editor state enumeration
enum EditorState {
  /// Editor is initializing
  initializing,
  /// Editor is ready for use
  ready,
  /// Editor encountered an error
  error,
  /// Editor is loading content
  loading,
  /// Editor is disposed
  disposed,
}

/// Editor mode enumeration
enum EditorMode {
  /// Online mode - loads Summernote from CDN
  online,
  /// Offline mode - uses bundled assets
  offline,
}

/// Editor language support
enum EditorLanguage {
  english('en-US'),
  spanish('es-ES'),
  french('fr-FR'),
  german('de-DE'),
  portuguese('pt-BR'),
  italian('it-IT'),
  japanese('ja-JP'),
  korean('ko-KR'),
  chinese('zh-CN');

  const EditorLanguage(this.code);
  final String code;
}

/// Editor toolbar position
enum ToolbarPosition {
  top,
  bottom,
  floating,
}

/// Editor focus state
enum FocusState {
  focused,
  blurred,
}

/// Content change type
enum ContentChangeType {
  text,
  html,
  user,
  api,
}

/// Editor error types
enum EditorErrorType {
  initialization,
  webview,
  javascript,
  network,
  timeout,
  unknown,
}

/// Represents the current content of the editor
class EditorContent {
  const EditorContent({
    required this.html,
    required this.text,
    required this.isEmpty,
    this.wordCount = 0,
    this.characterCount = 0,
  });

  /// HTML content
  final String html;
  
  /// Plain text content (HTML stripped)
  final String text;
  
  /// Whether the editor is empty
  final bool isEmpty;
  
  /// Word count
  final int wordCount;
  
  /// Character count
  final int characterCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorContent &&
          runtimeType == other.runtimeType &&
          html == other.html &&
          text == other.text &&
          isEmpty == other.isEmpty &&
          wordCount == other.wordCount &&
          characterCount == other.characterCount;

  @override
  int get hashCode =>
      html.hashCode ^
      text.hashCode ^
      isEmpty.hashCode ^
      wordCount.hashCode ^
      characterCount.hashCode;

  @override
  String toString() {
    return 'EditorContent{html: $html, text: $text, isEmpty: $isEmpty, wordCount: $wordCount, characterCount: $characterCount}';
  }

  EditorContent copyWith({
    String? html,
    String? text,
    bool? isEmpty,
    int? wordCount,
    int? characterCount,
  }) {
    return EditorContent(
      html: html ?? this.html,
      text: text ?? this.text,
      isEmpty: isEmpty ?? this.isEmpty,
      wordCount: wordCount ?? this.wordCount,
      characterCount: characterCount ?? this.characterCount,
    );
  }
}

/// Represents editor dimensions and sizing
class EditorDimensions {
  const EditorDimensions({
    this.height,
    this.minHeight = 200.0,
    this.maxHeight,
    this.width,
  });

  final double? height;
  final double minHeight;
  final double? maxHeight;
  final double? width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorDimensions &&
          runtimeType == other.runtimeType &&
          height == other.height &&
          minHeight == other.minHeight &&
          maxHeight == other.maxHeight &&
          width == other.width;

  @override
  int get hashCode =>
      height.hashCode ^
      minHeight.hashCode ^
      maxHeight.hashCode ^
      width.hashCode;
}
