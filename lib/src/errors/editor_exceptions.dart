/*
 * Flutter Summernote 2.0 - Error Handling
 * 
 * Comprehensive error handling with specific exception types and recovery strategies
 */

import '../types/editor_types.dart';

/// Base exception class for all Summernote editor errors
abstract class SummernoteException implements Exception {
  const SummernoteException({
    required this.message,
    required this.type,
    this.cause,
    this.stackTrace,
    this.recoverable = false,
  });

  /// Human-readable error message
  final String message;
  
  /// Type of error for categorization
  final EditorErrorType type;
  
  /// Original cause of the error (if any)
  final Object? cause;
  
  /// Stack trace when error occurred
  final StackTrace? stackTrace;
  
  /// Whether this error can potentially be recovered from
  final bool recoverable;

  @override
  String toString() {
    return 'SummernoteException{type: $type, message: $message, recoverable: $recoverable}';
  }
}

/// Editor initialization failed
class EditorInitializationException extends SummernoteException {
  const EditorInitializationException({
    required super.message,
    super.cause,
    super.stackTrace,
    super.recoverable = true,
  }) : super(type: EditorErrorType.initialization);
}

/// WebView related errors
class EditorWebViewException extends SummernoteException {
  const EditorWebViewException({
    required super.message,
    super.cause,
    super.stackTrace,
    super.recoverable = false,
  }) : super(type: EditorErrorType.webview);
}

/// JavaScript execution errors
class EditorJavaScriptException extends SummernoteException {
  const EditorJavaScriptException({
    required super.message,
    super.cause,
    super.stackTrace,
    super.recoverable = true,
  }) : super(type: EditorErrorType.javascript);
}

/// Network related errors (CDN loading, etc.)
class EditorNetworkException extends SummernoteException {
  const EditorNetworkException({
    required super.message,
    super.cause,
    super.stackTrace,
    super.recoverable = true,
  }) : super(type: EditorErrorType.network);
}

/// Timeout errors
class EditorTimeoutException extends SummernoteException {
  const EditorTimeoutException({
    required super.message,
    super.cause,
    super.stackTrace,
    super.recoverable = true,
  }) : super(type: EditorErrorType.timeout);
}

/// Unknown/unexpected errors
class EditorUnknownException extends SummernoteException {
  const EditorUnknownException({
    required super.message,
    super.cause,
    super.stackTrace,
    super.recoverable = false,
  }) : super(type: EditorErrorType.unknown);
}

/// Error recovery strategy
enum ErrorRecoveryStrategy {
  /// Retry the failed operation
  retry,
  /// Reset the editor to initial state
  reset,
  /// Reload the editor completely
  reload,
  /// Show error state to user
  showError,
  /// Ignore the error and continue
  ignore,
}

/// Error recovery information
class ErrorRecovery {
  const ErrorRecovery({
    required this.strategy,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.message,
  });

  final ErrorRecoveryStrategy strategy;
  final int maxRetries;
  final Duration retryDelay;
  final String? message;
}

/// Utility class for creating common exceptions
class EditorExceptions {
  EditorExceptions._();

  static EditorInitializationException initializationFailed(String reason, {Object? cause}) {
    return EditorInitializationException(
      message: 'Editor initialization failed: $reason',
      cause: cause,
      recoverable: true,
    );
  }

  static EditorWebViewException webViewError(String reason, {Object? cause}) {
    return EditorWebViewException(
      message: 'WebView error: $reason',
      cause: cause,
    );
  }

  static EditorJavaScriptException jsError(String reason, {Object? cause}) {
    return EditorJavaScriptException(
      message: 'JavaScript error: $reason',
      cause: cause,
    );
  }

  static EditorNetworkException networkError(String reason, {Object? cause}) {
    return EditorNetworkException(
      message: 'Network error: $reason',
      cause: cause,
    );
  }

  static EditorTimeoutException timeout(String operation, Duration duration) {
    return EditorTimeoutException(
      message: 'Operation "$operation" timed out after ${duration.inSeconds}s',
    );
  }

  static EditorUnknownException unknown(String reason, {Object? cause}) {
    return EditorUnknownException(
      message: 'Unknown error: $reason',
      cause: cause,
    );
  }
}
