/*
 * Flutter Summernote 2.0 - Editor Configuration
 * 
 * Comprehensive configuration system for the Summernote editor
 */

import 'package:flutter/material.dart';
import '../types/editor_types.dart';
import '../events/editor_callbacks.dart';

/// Main configuration class for the Summernote editor
class EditorConfig {
  const EditorConfig({
    this.mode = EditorMode.online,
    this.language = EditorLanguage.english,
    this.initialContent = '',
    this.placeholder = 'Start typing...',
    this.dimensions = const EditorDimensions(),
    this.autoFocus = false,
    this.readOnly = false,
    this.spellCheck = true,
    this.autoSave = false,
    this.autoSaveInterval = const Duration(seconds: 30),
    this.maxLength,
    this.enableWordCount = false,
    this.enableCharacterCount = false,
    this.enableAutoResize = true,
    this.debugMode = false,
    this.timeout = const Duration(seconds: 30),
    this.retryAttempts = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.customCss,
    this.customJs,
    this.callbacks = const EditorCallbacks(),
  });

  /// Editor mode (online/offline)
  final EditorMode mode;

  /// Editor language
  final EditorLanguage language;

  /// Initial content to load
  final String initialContent;

  /// Placeholder text when editor is empty
  final String placeholder;

  /// Editor dimensions
  final EditorDimensions dimensions;

  /// Whether to auto-focus the editor on load
  final bool autoFocus;

  /// Whether the editor is read-only
  final bool readOnly;

  /// Enable spell checking
  final bool spellCheck;

  /// Enable auto-save functionality
  final bool autoSave;

  /// Auto-save interval
  final Duration autoSaveInterval;

  /// Maximum content length (null for unlimited)
  final int? maxLength;

  /// Show word count
  final bool enableWordCount;

  /// Show character count
  final bool enableCharacterCount;

  /// Enable auto-resize based on content
  final bool enableAutoResize;

  /// Enable debug mode with verbose logging
  final bool debugMode;

  /// Initialization timeout
  final Duration timeout;

  /// Number of retry attempts on failure
  final int retryAttempts;

  /// Delay between retry attempts
  final Duration retryDelay;

  /// Custom CSS to inject
  final String? customCss;

  /// Custom JavaScript to inject
  final String? customJs;

  /// Event callbacks
  final EditorCallbacks callbacks;

  /// Create a copy with updated values
  EditorConfig copyWith({
    EditorMode? mode,
    EditorLanguage? language,
    String? initialContent,
    String? placeholder,
    EditorDimensions? dimensions,
    bool? autoFocus,
    bool? readOnly,
    bool? spellCheck,
    bool? autoSave,
    Duration? autoSaveInterval,
    int? maxLength,
    bool? enableWordCount,
    bool? enableCharacterCount,
    bool? enableAutoResize,
    bool? debugMode,
    Duration? timeout,
    int? retryAttempts,
    Duration? retryDelay,
    String? customCss,
    String? customJs,
    EditorCallbacks? callbacks,
  }) {
    return EditorConfig(
      mode: mode ?? this.mode,
      language: language ?? this.language,
      initialContent: initialContent ?? this.initialContent,
      placeholder: placeholder ?? this.placeholder,
      dimensions: dimensions ?? this.dimensions,
      autoFocus: autoFocus ?? this.autoFocus,
      readOnly: readOnly ?? this.readOnly,
      spellCheck: spellCheck ?? this.spellCheck,
      autoSave: autoSave ?? this.autoSave,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
      maxLength: maxLength ?? this.maxLength,
      enableWordCount: enableWordCount ?? this.enableWordCount,
      enableCharacterCount: enableCharacterCount ?? this.enableCharacterCount,
      enableAutoResize: enableAutoResize ?? this.enableAutoResize,
      debugMode: debugMode ?? this.debugMode,
      timeout: timeout ?? this.timeout,
      retryAttempts: retryAttempts ?? this.retryAttempts,
      retryDelay: retryDelay ?? this.retryDelay,
      customCss: customCss ?? this.customCss,
      customJs: customJs ?? this.customJs,
      callbacks: callbacks ?? this.callbacks,
    );
  }

  /// Validate configuration
  bool get isValid {
    return retryAttempts >= 0 &&
        timeout.inMilliseconds > 0 &&
        retryDelay.inMilliseconds >= 0 &&
        (maxLength == null || maxLength! > 0) &&
        autoSaveInterval.inSeconds > 0;
  }

  /// Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];
    
    if (retryAttempts < 0) {
      errors.add('retryAttempts must be >= 0');
    }
    
    if (timeout.inMilliseconds <= 0) {
      errors.add('timeout must be > 0');
    }
    
    if (retryDelay.inMilliseconds < 0) {
      errors.add('retryDelay must be >= 0');
    }
    
    if (maxLength != null && maxLength! <= 0) {
      errors.add('maxLength must be > 0 when specified');
    }
    
    if (autoSaveInterval.inSeconds <= 0) {
      errors.add('autoSaveInterval must be > 0');
    }
    
    return errors;
  }

  @override
  String toString() {
    return 'EditorConfig{mode: $mode, language: $language, readOnly: $readOnly, debugMode: $debugMode}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorConfig &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          language == other.language &&
          initialContent == other.initialContent &&
          placeholder == other.placeholder &&
          dimensions == other.dimensions &&
          autoFocus == other.autoFocus &&
          readOnly == other.readOnly &&
          spellCheck == other.spellCheck &&
          autoSave == other.autoSave &&
          autoSaveInterval == other.autoSaveInterval &&
          maxLength == other.maxLength &&
          enableWordCount == other.enableWordCount &&
          enableCharacterCount == other.enableCharacterCount &&
          enableAutoResize == other.enableAutoResize &&
          debugMode == other.debugMode &&
          timeout == other.timeout &&
          retryAttempts == other.retryAttempts &&
          retryDelay == other.retryDelay &&
          customCss == other.customCss &&
          customJs == other.customJs;

  @override
  int get hashCode =>
      mode.hashCode ^
      language.hashCode ^
      initialContent.hashCode ^
      placeholder.hashCode ^
      dimensions.hashCode ^
      autoFocus.hashCode ^
      readOnly.hashCode ^
      spellCheck.hashCode ^
      autoSave.hashCode ^
      autoSaveInterval.hashCode ^
      maxLength.hashCode ^
      enableWordCount.hashCode ^
      enableCharacterCount.hashCode ^
      enableAutoResize.hashCode ^
      debugMode.hashCode ^
      timeout.hashCode ^
      retryAttempts.hashCode ^
      retryDelay.hashCode ^
      customCss.hashCode ^
      customJs.hashCode;
}

/// Predefined editor configurations for common use cases
class EditorConfigs {
  EditorConfigs._();

  /// Basic editor configuration
  static const EditorConfig basic = EditorConfig();

  /// Read-only editor configuration
  static const EditorConfig readOnly = EditorConfig(
    readOnly: true,
    autoFocus: false,
  );

  /// Minimal editor configuration (offline, basic features)
  static const EditorConfig minimal = EditorConfig(
    mode: EditorMode.offline,
    enableWordCount: false,
    enableCharacterCount: false,
    enableAutoResize: false,
  );

  /// Full-featured editor configuration
  static const EditorConfig fullFeatured = EditorConfig(
    enableWordCount: true,
    enableCharacterCount: true,
    enableAutoResize: true,
    autoSave: true,
    spellCheck: true,
  );

  /// Debug configuration for development
  static const EditorConfig debug = EditorConfig(
    debugMode: true,
    timeout: Duration(seconds: 60),
    retryAttempts: 1,
  );

  /// Mobile-optimized configuration
  static const EditorConfig mobile = EditorConfig(
    dimensions: EditorDimensions(minHeight: 150),
    enableAutoResize: true,
    autoFocus: false,
  );
}
