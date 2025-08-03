/*
 * Flutter Summernote 2.0 - Core Editor Widget
 * 
 * Modern, robust Summernote editor widget with comprehensive error handling,
 * clean architecture, and excellent developer experience
 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'config/editor_config.dart';
import 'config/toolbar_config.dart';
import 'config/editor_theme.dart';
import 'types/editor_types.dart';
import 'errors/editor_exceptions.dart';
import 'utils/editor_utils.dart';

/// Main Summernote editor widget
class SummernoteEditor extends StatefulWidget {
  const SummernoteEditor({
    super.key,
    this.config = const EditorConfig(),
    this.toolbarConfig = const ToolbarConfig(),
    this.theme = const EditorTheme(),
    this.onReady,
    this.onContentChanged,
    this.onStateChanged,
    this.onError,
    this.controller,
  });

  /// Editor configuration
  final EditorConfig config;

  /// Toolbar configuration
  final ToolbarConfig toolbarConfig;

  /// Editor theme
  final EditorTheme theme;

  /// Called when editor is ready
  final VoidCallback? onReady;

  /// Called when content changes
  final ValueChanged<EditorContent>? onContentChanged;

  /// Called when editor state changes
  final ValueChanged<EditorState>? onStateChanged;

  /// Called when an error occurs
  final ValueChanged<SummernoteException>? onError;

  /// Optional controller for programmatic access
  final SummernoteController? controller;

  @override
  State<SummernoteEditor> createState() => _SummernoteEditorState();
}

class _SummernoteEditorState extends State<SummernoteEditor> {
  late final WebViewController _webViewController;
  late final String _editorId;

  EditorState _state = EditorState.initializing;
  EditorContent _content = const EditorContent(
    html: '',
    text: '',
    isEmpty: true,
  );
  SummernoteException? _lastError;

  int _retryCount = 0;
  Timer? _retryTimer;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _editorId = EditorUtils.generateEditorId();

    if (widget.config.debugMode) {
      debugPrint('SummernoteEditor: Initializing editor $_editorId');
    }

    // Bind controller if provided
    widget.controller?._bind(this);

    _initializeEditor();
  }

  @override
  void dispose() {
    if (widget.config.debugMode) {
      debugPrint('SummernoteEditor: Disposing editor $_editorId');
    }

    _retryTimer?.cancel();
    _autoSaveTimer?.cancel();
    widget.controller?._unbind();
    _setState(EditorState.disposed);

    super.dispose();
  }

  /// Initialize the editor
  void _initializeEditor() {
    try {
      _setState(EditorState.initializing);
      _setupWebViewController();
      _startInitializationTimeout();

      if (widget.config.autoSave) {
        _startAutoSave();
      }
    } catch (e, stackTrace) {
      _handleError(
        EditorExceptions.initializationFailed(
          'Failed to initialize editor: $e',
          cause: e,
        ),
        stackTrace,
      );
    }
  }

  /// Setup WebView controller
  void _setupWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.theme.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onWebResourceError: _onWebResourceError,
        ),
      )
      ..addJavaScriptChannel(
        'SummernoteReady',
        onMessageReceived: _onSummernoteReady,
      )
      ..addJavaScriptChannel(
        'SummernoteContent',
        onMessageReceived: _onContentChanged,
      )
      ..addJavaScriptChannel(
        'SummernoteError',
        onMessageReceived: _onJavaScriptError,
      )
      ..addJavaScriptChannel(
        'SummernoteEvent',
        onMessageReceived: _onEditorEvent,
      );

    // Load the editor HTML
    _loadEditorHtml();
  }

  /// Load the editor HTML content
  void _loadEditorHtml() {
    final html = _generateEditorHtml();
    final uri = Uri.dataFromString(
      html,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );

    _webViewController.loadRequest(uri);
  }

  /// Generate complete HTML for the editor
  String _generateEditorHtml() {
    final summernoteVersion = '0.8.20';
    final jqueryVersion = '3.6.0';

    final cdnBase = widget.config.mode == EditorMode.online
        ? 'https://cdnjs.cloudflare.com/ajax/libs'
        : 'assets/packages/flutter_summernote/assets';

    final toolbarHtml = _generateToolbarHtml();
    final customCss = widget.theme.generateCss();

    return '''
<!DOCTYPE html>
<html lang="${widget.config.language.code}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Summernote Editor</title>
    
    <!-- jQuery -->
    <script src="$cdnBase/jquery/$jqueryVersion/jquery.min.js"></script>
    
    <!-- Bootstrap CSS (required for Summernote) -->
    <link href="$cdnBase/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Summernote CSS -->
    <link href="$cdnBase/summernote/$summernoteVersion/summernote-bs5.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <style>
        $customCss
        
        body {
            margin: 0;
            padding: 8px;
            font-family: ${widget.theme.fontFamily};
            background-color: #${widget.theme.backgroundColor.toARGB32().toRadixString(16).padLeft(8, '0')};
        }
        
        .editor-container {
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .error-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            color: red;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="editor-container">
        <div id="loading" class="loading-overlay">
            <div>Loading editor...</div>
        </div>
        
        <div id="error" class="error-overlay" style="display: none;">
            <div id="error-message">An error occurred</div>
        </div>
        
        <div id="summernote">${widget.config.initialContent}</div>
    </div>

    <!-- Bootstrap JS -->
    <script src="$cdnBase/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    
    <!-- Summernote JS -->
    <script src="$cdnBase/summernote/$summernoteVersion/summernote-bs5.min.js"></script>
    
    <!-- Editor Initialization Script -->
    <script>
        let editorReady = false;
        let initializationStartTime = Date.now();
        
        // Debug logging
        function debugLog(message) {
            if (${widget.config.debugMode}) {
                console.log('[SummernoteEditor] ' + message);
            }
        }
        
        // Error handling
        function handleError(error, context) {
            debugLog('Error in ' + context + ': ' + error);
            if (window.SummernoteError) {
                window.SummernoteError.postMessage(JSON.stringify({
                    error: error.toString(),
                    context: context,
                    timestamp: Date.now()
                }));
            }
        }
        
        // Initialize Summernote
        function initializeSummernote() {
            try {
                debugLog('Initializing Summernote...');
                
                \$('#summernote').summernote({
                    height: ${widget.config.dimensions.height ?? 300},
                    minHeight: ${widget.config.dimensions.minHeight},
                    maxHeight: ${widget.config.dimensions.maxHeight ?? 'null'},
                    focus: ${widget.config.autoFocus},
                    placeholder: '${EditorUtils.escapeForJs(widget.config.placeholder)}',
                    disableResizeEditor: ${!widget.config.enableAutoResize},
                    toolbar: $toolbarHtml,
                    lang: '${widget.config.language.code}',
                    callbacks: {
                        onInit: function() {
                            debugLog('Summernote initialized');
                            hideLoading();
                            notifyReady();
                        },
                        onChange: function(contents, \$editable) {
                            notifyContentChange(contents);
                        },
                        onFocus: function() {
                            notifyEvent('focus', {});
                        },
                        onBlur: function() {
                            notifyEvent('blur', {});
                        },
                        onKeyup: function(e) {
                            notifyEvent('keyup', {
                                key: e.key,
                                ctrlKey: e.ctrlKey,
                                shiftKey: e.shiftKey,
                                altKey: e.altKey
                            });
                        },
                        onPaste: function(e) {
                            notifyEvent('paste', {
                                clipboardData: e.originalEvent.clipboardData.getData('text/html') || e.originalEvent.clipboardData.getData('text/plain')
                            });
                        }
                    }
                });
                
                debugLog('Summernote setup completed');
                
            } catch (error) {
                handleError(error, 'initializeSummernote');
                showError('Failed to initialize editor: ' + error.message);
            }
        }
        
        // Notify Flutter that editor is ready
        function notifyReady() {
            if (!editorReady) {
                editorReady = true;
                const initTime = Date.now() - initializationStartTime;
                debugLog('Editor ready in ' + initTime + 'ms');
                
                if (window.SummernoteReady) {
                    window.SummernoteReady.postMessage(JSON.stringify({
                        ready: true,
                        initializationTime: initTime
                    }));
                }
            }
        }
        
        // Notify content changes
        function notifyContentChange(html) {
            if (window.SummernoteContent) {
                window.SummernoteContent.postMessage(JSON.stringify({
                    html: html,
                    timestamp: Date.now()
                }));
            }
        }
        
        // Notify events
        function notifyEvent(type, data) {
            if (window.SummernoteEvent) {
                window.SummernoteEvent.postMessage(JSON.stringify({
                    type: type,
                    data: data,
                    timestamp: Date.now()
                }));
            }
        }
        
        // Show/hide loading
        function hideLoading() {
            document.getElementById('loading').style.display = 'none';
        }
        
        function showLoading() {
            document.getElementById('loading').style.display = 'flex';
        }
        
        // Show/hide error
        function showError(message) {
            document.getElementById('error-message').textContent = message;
            document.getElementById('error').style.display = 'flex';
            document.getElementById('loading').style.display = 'none';
        }
        
        function hideError() {
            document.getElementById('error').style.display = 'none';
        }
        
        // Editor API functions
        window.editorAPI = {
            getContent: function() {
                return \$('#summernote').summernote('code');
            },
            
            setContent: function(html) {
                \$('#summernote').summernote('code', html);
            },
            
            insertText: function(text) {
                \$('#summernote').summernote('insertText', text);
            },
            
            focus: function() {
                \$('#summernote').summernote('focus');
            },
            
            blur: function() {
                \$('#summernote').summernote('blur');
            },
            
            enable: function() {
                \$('#summernote').summernote('enable');
            },
            
            disable: function() {
                \$('#summernote').summernote('disable');
            },
            
            isEmpty: function() {
                return \$('#summernote').summernote('isEmpty');
            },
            
            reset: function() {
                \$('#summernote').summernote('reset');
            }
        };
        
        // Initialize when DOM is ready
        \$(document).ready(function() {
            debugLog('DOM ready, initializing...');
            
            // Add small delay to ensure everything is loaded
            setTimeout(function() {
                initializeSummernote();
            }, 100);
        });
        
        // Global error handler
        window.addEventListener('error', function(e) {
            handleError(e.error || e.message, 'global');
        });
        
    </script>
</body>
</html>
    ''';
  }

  /// Generate toolbar HTML configuration
  String _generateToolbarHtml() {
    if (widget.toolbarConfig.allGroups.isEmpty) {
      return '[]';
    }

    final groups = widget.toolbarConfig.allGroups.map((group) {
      final buttons = group.buttons
          .where((button) => button.visible)
          .map((button) => "'${button.name}'")
          .toList();

      return "['${group.name}', [${buttons.join(', ')}]]";
    }).toList();

    return '[${groups.join(', ')}]';
  }

  /// Start initialization timeout
  void _startInitializationTimeout() {
    Timer(widget.config.timeout, () {
      if (_state == EditorState.initializing) {
        _handleError(
          EditorExceptions.timeout(
            'Editor initialization',
            widget.config.timeout,
          ),
          null,
        );
      }
    });
  }

  /// Start auto-save timer
  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(widget.config.autoSaveInterval, (timer) {
      if (_state == EditorState.ready && !_content.isEmpty) {
        _saveContent();
      }
    });
  }

  /// Save content (placeholder for auto-save functionality)
  void _saveContent() {
    if (widget.config.debugMode) {
      debugPrint('SummernoteEditor: Auto-saving content');
    }
    // Implementation would depend on storage requirements
  }

  /// Handle page started loading
  void _onPageStarted(String url) {
    if (widget.config.debugMode) {
      debugPrint('SummernoteEditor: Page started loading: $url');
    }
  }

  /// Handle page finished loading
  void _onPageFinished(String url) {
    if (widget.config.debugMode) {
      debugPrint('SummernoteEditor: Page finished loading: $url');
    }
  }

  /// Handle web resource errors
  void _onWebResourceError(WebResourceError error) {
    _handleError(
      EditorExceptions.webViewError(
        'WebView resource error: ${error.description}',
        cause: error,
      ),
      null,
    );
  }

  /// Handle Summernote ready message
  void _onSummernoteReady(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;

      if (data['ready'] == true) {
        final initTime = Duration(
          milliseconds: data['initializationTime'] ?? 0,
        );
        _setState(EditorState.ready);

        if (widget.config.debugMode) {
          debugPrint(
            'SummernoteEditor: Editor ready in ${initTime.inMilliseconds}ms',
          );
        }

        widget.onReady?.call();
        widget.config.callbacks.onReady?.call(initTime);
      }
    } catch (e) {
      _handleError(
        EditorExceptions.jsError('Failed to parse ready message: $e', cause: e),
        null,
      );
    }
  }

  /// Handle content change messages
  void _onContentChanged(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final html = data['html'] as String? ?? '';

      final newContent = EditorUtils.createContent(html);

      if (newContent != _content) {
        _content = newContent;

        widget.onContentChanged?.call(_content);
        widget.config.callbacks.onContentChanged?.call(
          _content,
          ContentChangeType.user,
        );

        if (widget.config.debugMode) {
          EditorUtils.debugContent(html, label: 'Content Changed');
        }
      }
    } catch (e) {
      _handleError(
        EditorExceptions.jsError(
          'Failed to parse content change: $e',
          cause: e,
        ),
        null,
      );
    }
  }

  /// Handle JavaScript errors
  void _onJavaScriptError(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final error = data['error'] as String? ?? 'Unknown error';
      final context = data['context'] as String? ?? 'Unknown context';

      _handleError(
        EditorExceptions.jsError('JavaScript error in $context: $error'),
        null,
      );
    } catch (e) {
      _handleError(
        EditorExceptions.jsError('Failed to parse error message: $e', cause: e),
        null,
      );
    }
  }

  /// Handle editor events
  void _onEditorEvent(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final type = data['type'] as String;
      final eventData = data['data'] as Map<String, dynamic>? ?? {};

      switch (type) {
        case 'focus':
          widget.config.callbacks.onFocusChanged?.call(FocusState.focused);
          break;
        case 'blur':
          widget.config.callbacks.onFocusChanged?.call(FocusState.blurred);
          break;
        case 'keyup':
          final key = eventData['key'] as String? ?? '';
          final ctrlKey = eventData['ctrlKey'] as bool? ?? false;
          final shiftKey = eventData['shiftKey'] as bool? ?? false;
          final altKey = eventData['altKey'] as bool? ?? false;

          widget.config.callbacks.onKeyEvent?.call(
            key,
            ctrlKey,
            shiftKey,
            altKey,
          );
          break;
        case 'paste':
          final clipboardData = eventData['clipboardData'] as String? ?? '';
          widget.config.callbacks.onPaste?.call(clipboardData, 'text/html');
          break;
      }
    } catch (e) {
      if (widget.config.debugMode) {
        debugPrint('SummernoteEditor: Failed to parse event: $e');
      }
    }
  }

  /// Set editor state and notify listeners
  void _setState(EditorState newState) {
    if (_state != newState) {
      final previousState = _state;
      _state = newState;

      if (mounted) {
        setState(() {});
      }

      widget.onStateChanged?.call(_state);
      widget.config.callbacks.onStateChanged?.call(previousState, _state);

      if (widget.config.debugMode) {
        debugPrint(
          'SummernoteEditor: State changed from $previousState to $newState',
        );
      }
    }
  }

  /// Handle errors with retry logic
  void _handleError(SummernoteException exception, StackTrace? stackTrace) {
    _lastError = exception;

    if (widget.config.debugMode) {
      debugPrint('SummernoteEditor: Error occurred: $exception');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    widget.onError?.call(exception);
    widget.config.callbacks.onError?.call(exception);

    // Retry logic for recoverable errors
    if (exception.recoverable && _retryCount < widget.config.retryAttempts) {
      _retryCount++;

      if (widget.config.debugMode) {
        debugPrint(
          'SummernoteEditor: Retrying initialization (attempt $_retryCount/${widget.config.retryAttempts})',
        );
      }

      _retryTimer = Timer(widget.config.retryDelay, () {
        _initializeEditor();
      });
    } else {
      _setState(EditorState.error);
    }
  }

  /// Execute JavaScript in the editor
  Future<String?> _executeJs(String script) async {
    try {
      final result = await _webViewController.runJavaScriptReturningResult(
        script,
      );
      return result.toString();
    } catch (e) {
      if (widget.config.debugMode) {
        debugPrint('SummernoteEditor: JavaScript execution failed: $e');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.config.dimensions.height,
      width: widget.config.dimensions.width,
      constraints: BoxConstraints(
        minHeight: widget.config.dimensions.minHeight,
        maxHeight: widget.config.dimensions.maxHeight ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: widget.theme.backgroundColor,
        border: Border.all(
          color: _state == EditorState.error
              ? widget.theme.errorBorderColor
              : (_state == EditorState.ready
                    ? widget.theme.focusBorderColor
                    : widget.theme.borderColor),
          width: widget.theme.borderWidth,
        ),
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
        boxShadow: widget.theme.shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
        child: Stack(
          children: [
            if (_state != EditorState.disposed)
              WebViewWidget(controller: _webViewController),

            if (_state == EditorState.initializing) _buildLoadingOverlay(),

            if (_state == EditorState.error) _buildErrorOverlay(),
          ],
        ),
      ),
    );
  }

  /// Build loading overlay
  Widget _buildLoadingOverlay() {
    return Container(
      color: widget.theme.loadingOverlayColor.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: widget.theme.loadingIndicatorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading editor...',
              style: TextStyle(color: widget.theme.textColor, fontSize: 16),
            ),
            if (_retryCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Retry attempt $_retryCount/${widget.config.retryAttempts}',
                style: TextStyle(
                  color: widget.theme.textColor.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build error overlay
  Widget _buildErrorOverlay() {
    return Container(
      color: widget.theme.errorOverlayColor.withValues(alpha: 0.1),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: widget.theme.errorBorderColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Editor Error',
                style: TextStyle(
                  color: widget.theme.errorBorderColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _lastError?.message ?? 'An unknown error occurred',
                style: TextStyle(
                  color: widget.theme.errorBorderColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _retryCount = 0;
                  _initializeEditor();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.theme.errorBorderColor,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controller for programmatic access to the editor
class SummernoteController {
  _SummernoteEditorState? _state;

  /// Bind to editor state
  void _bind(_SummernoteEditorState state) {
    _state = state;
  }

  /// Unbind from editor state
  void _unbind() {
    _state = null;
  }

  /// Check if controller is bound to an editor
  bool get isBound => _state != null;

  /// Get current editor state
  EditorState get state => _state?._state ?? EditorState.disposed;

  /// Get current content
  EditorContent get content =>
      _state?._content ??
      const EditorContent(html: '', text: '', isEmpty: true);

  /// Get last error
  SummernoteException? get lastError => _state?._lastError;

  /// Set content programmatically
  Future<bool> setContent(String html) async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      final script = EditorUtils.createJsCall('window.editorAPI.setContent', [
        html,
      ]);
      await _state!._executeJs(script);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get content programmatically
  Future<String?> getContent() async {
    if (_state == null || _state!._state != EditorState.ready) return null;

    try {
      final result = await _state!._executeJs('window.editorAPI.getContent()');
      return result?.replaceAll('"', ''); // Remove quotes from JSON string
    } catch (e) {
      return null;
    }
  }

  /// Insert text at cursor position
  Future<bool> insertText(String text) async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      final script = EditorUtils.createJsCall('window.editorAPI.insertText', [
        text,
      ]);
      await _state!._executeJs(script);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Focus the editor
  Future<bool> focus() async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      await _state!._executeJs('window.editorAPI.focus()');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Blur the editor
  Future<bool> blur() async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      await _state!._executeJs('window.editorAPI.blur()');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Enable the editor
  Future<bool> enable() async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      await _state!._executeJs('window.editorAPI.enable()');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Disable the editor
  Future<bool> disable() async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      await _state!._executeJs('window.editorAPI.disable()');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if editor is empty
  Future<bool?> isEmpty() async {
    if (_state == null || _state!._state != EditorState.ready) return null;

    try {
      final result = await _state!._executeJs('window.editorAPI.isEmpty()');
      return result == 'true';
    } catch (e) {
      return null;
    }
  }

  /// Reset editor content
  Future<bool> reset() async {
    if (_state == null || _state!._state != EditorState.ready) return false;

    try {
      await _state!._executeJs('window.editorAPI.reset()');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose the controller and unbind from editor
  void dispose() {
    _unbind();
  }
}
