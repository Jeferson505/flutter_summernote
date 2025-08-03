/*
 * Flutter Summernote 2.0 - Editor Callbacks
 * 
 * Type-safe callback definitions for editor events and interactions
 */

import '../types/editor_types.dart';
import '../errors/editor_exceptions.dart';

/// Callback for when editor state changes
typedef OnEditorStateChanged = void Function(EditorState previousState, EditorState currentState);

/// Callback for when editor content changes
typedef OnEditorContentChanged = void Function(EditorContent content, ContentChangeType changeType);

/// Callback for when editor focus changes
typedef OnEditorFocusChanged = void Function(FocusState focusState);

/// Callback for when editor encounters an error
typedef OnEditorError = void Function(SummernoteException exception);

/// Callback for when editor is ready
typedef OnEditorReady = void Function(Duration initializationTime);

/// Callback for editor loading states
typedef OnEditorLoading = void Function(String message);

/// Callback for when a command is executed
typedef OnEditorCommand = void Function(String command, Map<String, dynamic> parameters, bool success);

/// Callback for file attachments
typedef OnEditorAttachment = void Function(String fileName, int fileSize, String mimeType);

/// Callback for custom toolbar actions
typedef OnToolbarAction = void Function(String action, Map<String, dynamic>? data);

/// Callback for editor height changes (auto-resize)
typedef OnEditorHeightChanged = void Function(double height);

/// Callback for editor selection changes
typedef OnEditorSelectionChanged = void Function(int start, int end, String selectedText);

/// Callback for editor paste events
typedef OnEditorPaste = bool Function(String content, String mimeType);

/// Callback for editor key events
typedef OnEditorKeyEvent = bool Function(String key, bool ctrlKey, bool shiftKey, bool altKey);

/// Comprehensive callback configuration for the editor
class EditorCallbacks {
  const EditorCallbacks({
    this.onStateChanged,
    this.onContentChanged,
    this.onFocusChanged,
    this.onError,
    this.onReady,
    this.onLoading,
    this.onCommand,
    this.onAttachment,
    this.onToolbarAction,
    this.onHeightChanged,
    this.onSelectionChanged,
    this.onPaste,
    this.onKeyEvent,
  });

  /// Called when editor state changes
  final OnEditorStateChanged? onStateChanged;

  /// Called when editor content changes
  final OnEditorContentChanged? onContentChanged;

  /// Called when editor focus changes
  final OnEditorFocusChanged? onFocusChanged;

  /// Called when editor encounters an error
  final OnEditorError? onError;

  /// Called when editor is ready for use
  final OnEditorReady? onReady;

  /// Called during loading operations
  final OnEditorLoading? onLoading;

  /// Called when a command is executed
  final OnEditorCommand? onCommand;

  /// Called when a file is attached
  final OnEditorAttachment? onAttachment;

  /// Called when a toolbar action is triggered
  final OnToolbarAction? onToolbarAction;

  /// Called when editor height changes (auto-resize)
  final OnEditorHeightChanged? onHeightChanged;

  /// Called when text selection changes
  final OnEditorSelectionChanged? onSelectionChanged;

  /// Called when content is pasted (return false to prevent)
  final OnEditorPaste? onPaste;

  /// Called on key events (return false to prevent default)
  final OnEditorKeyEvent? onKeyEvent;

  /// Create a copy with updated callbacks
  EditorCallbacks copyWith({
    OnEditorStateChanged? onStateChanged,
    OnEditorContentChanged? onContentChanged,
    OnEditorFocusChanged? onFocusChanged,
    OnEditorError? onError,
    OnEditorReady? onReady,
    OnEditorLoading? onLoading,
    OnEditorCommand? onCommand,
    OnEditorAttachment? onAttachment,
    OnToolbarAction? onToolbarAction,
    OnEditorHeightChanged? onHeightChanged,
    OnEditorSelectionChanged? onSelectionChanged,
    OnEditorPaste? onPaste,
    OnEditorKeyEvent? onKeyEvent,
  }) {
    return EditorCallbacks(
      onStateChanged: onStateChanged ?? this.onStateChanged,
      onContentChanged: onContentChanged ?? this.onContentChanged,
      onFocusChanged: onFocusChanged ?? this.onFocusChanged,
      onError: onError ?? this.onError,
      onReady: onReady ?? this.onReady,
      onLoading: onLoading ?? this.onLoading,
      onCommand: onCommand ?? this.onCommand,
      onAttachment: onAttachment ?? this.onAttachment,
      onToolbarAction: onToolbarAction ?? this.onToolbarAction,
      onHeightChanged: onHeightChanged ?? this.onHeightChanged,
      onSelectionChanged: onSelectionChanged ?? this.onSelectionChanged,
      onPaste: onPaste ?? this.onPaste,
      onKeyEvent: onKeyEvent ?? this.onKeyEvent,
    );
  }

  /// Check if any callbacks are defined
  bool get hasCallbacks {
    return onStateChanged != null ||
        onContentChanged != null ||
        onFocusChanged != null ||
        onError != null ||
        onReady != null ||
        onLoading != null ||
        onCommand != null ||
        onAttachment != null ||
        onToolbarAction != null ||
        onHeightChanged != null ||
        onSelectionChanged != null ||
        onPaste != null ||
        onKeyEvent != null;
  }

  @override
  String toString() {
    final callbackCount = [
      onStateChanged,
      onContentChanged,
      onFocusChanged,
      onError,
      onReady,
      onLoading,
      onCommand,
      onAttachment,
      onToolbarAction,
      onHeightChanged,
      onSelectionChanged,
      onPaste,
      onKeyEvent,
    ].where((callback) => callback != null).length;

    return 'EditorCallbacks{callbackCount: $callbackCount}';
  }
}
