/*
 * Flutter Summernote 2.0 - Editor Events
 * 
 * Event system for editor state changes, content updates, and user interactions
 */

import 'dart:developer';

import '../types/editor_types.dart';
import '../errors/editor_exceptions.dart';

/// Base class for all editor events
abstract class EditorEvent {
  const EditorEvent({required this.timestamp});

  final DateTime timestamp;

  @override
  String toString() => '$runtimeType{timestamp: $timestamp}';
}

/// Editor state changed event
class EditorStateChangedEvent extends EditorEvent {
  const EditorStateChangedEvent({
    required this.previousState,
    required this.currentState,
    required super.timestamp,
  });

  final EditorState previousState;
  final EditorState currentState;

  @override
  String toString() =>
      'EditorStateChangedEvent{from: $previousState, to: $currentState, timestamp: $timestamp}';
}

/// Editor content changed event
class EditorContentChangedEvent extends EditorEvent {
  const EditorContentChangedEvent({
    required this.content,
    required this.changeType,
    required super.timestamp,
  });

  final EditorContent content;
  final ContentChangeType changeType;

  @override
  String toString() =>
      'EditorContentChangedEvent{changeType: $changeType, isEmpty: ${content.isEmpty}, timestamp: $timestamp}';
}

/// Editor focus changed event
class EditorFocusChangedEvent extends EditorEvent {
  const EditorFocusChangedEvent({
    required this.focusState,
    required super.timestamp,
  });

  final FocusState focusState;

  @override
  String toString() =>
      'EditorFocusChangedEvent{focusState: $focusState, timestamp: $timestamp}';
}

/// Editor error event
class EditorErrorEvent extends EditorEvent {
  const EditorErrorEvent({required this.exception, required super.timestamp});

  final SummernoteException exception;

  @override
  String toString() =>
      'EditorErrorEvent{exception: $exception, timestamp: $timestamp}';
}

/// Editor ready event (initialization completed)
class EditorReadyEvent extends EditorEvent {
  const EditorReadyEvent({
    required this.initializationTime,
    required super.timestamp,
  });

  final Duration initializationTime;

  @override
  String toString() =>
      'EditorReadyEvent{initializationTime: ${initializationTime.inMilliseconds}ms, timestamp: $timestamp}';
}

/// Editor loading event
class EditorLoadingEvent extends EditorEvent {
  const EditorLoadingEvent({required this.message, required super.timestamp});

  final String message;

  @override
  String toString() =>
      'EditorLoadingEvent{message: $message, timestamp: $timestamp}';
}

/// Editor command executed event
class EditorCommandEvent extends EditorEvent {
  const EditorCommandEvent({
    required this.command,
    required this.parameters,
    required this.success,
    required super.timestamp,
  });

  final String command;
  final Map<String, dynamic> parameters;
  final bool success;

  @override
  String toString() =>
      'EditorCommandEvent{command: $command, success: $success, timestamp: $timestamp}';
}

/// Editor attachment event
class EditorAttachmentEvent extends EditorEvent {
  const EditorAttachmentEvent({
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required super.timestamp,
  });

  final String fileName;
  final int fileSize;
  final String mimeType;

  @override
  String toString() =>
      'EditorAttachmentEvent{fileName: $fileName, fileSize: $fileSize, timestamp: $timestamp}';
}

/// Event listener function type
typedef EditorEventListener<T extends EditorEvent> = void Function(T event);

/// Event bus for managing editor events
class EditorEventBus {
  EditorEventBus._();

  static final EditorEventBus _instance = EditorEventBus._();
  static EditorEventBus get instance => _instance;

  final Map<Type, List<EditorEventListener>> _listeners = {};

  /// Subscribe to events of a specific type
  void on<T extends EditorEvent>(EditorEventListener<T> listener) {
    final type = T;
    _listeners[type] ??= [];
    _listeners[type]!.add(listener as EditorEventListener);
  }

  /// Unsubscribe from events
  void off<T extends EditorEvent>(EditorEventListener<T> listener) {
    final type = T;
    _listeners[type]?.remove(listener);
    if (_listeners[type]?.isEmpty == true) {
      _listeners.remove(type);
    }
  }

  /// Emit an event to all subscribers
  void emit<T extends EditorEvent>(T event) {
    final type = T;
    final listeners = _listeners[type];
    if (listeners != null) {
      for (final listener in listeners) {
        try {
          listener(event);
        } catch (e) {
          // Log error but don't break other listeners
          log('Error in event listener: $e');
        }
      }
    }
  }

  /// Clear all listeners
  void clear() {
    _listeners.clear();
  }

  /// Get listener count for a specific event type
  int getListenerCount<T extends EditorEvent>() {
    return _listeners[T]?.length ?? 0;
  }
}
