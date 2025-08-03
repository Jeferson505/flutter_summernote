/*
 * Flutter Summernote 2.0 - Modern Example App
 * 
 * Demonstrates the latest Flutter best practices with our modern rich text editor:
 * - Material 3 design system
 * - Responsive layouts
 * - State management
 * - Modern navigation
 * - Accessibility features
 * - Performance optimizations
 */

import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

void main() {
  runApp(const SummernoteExampleApp());
}

class SummernoteExampleApp extends StatelessWidget {
  const SummernoteExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Summernote 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const EditorHomePage(),
    );
  }
}

class EditorHomePage extends StatefulWidget {
  const EditorHomePage({super.key});

  @override
  State<EditorHomePage> createState() => _EditorHomePageState();
}

class _EditorHomePageState extends State<EditorHomePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final List<SummernoteController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize controllers for different examples
    for (int i = 0; i < 4; i++) {
      _controllers.add(SummernoteController());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Summernote 2.0',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About Flutter Summernote 2.0',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => {}, // Tab selection handled by TabController
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: 'Basic'),
            Tab(icon: Icon(Icons.palette), text: 'Themed'),
            Tab(icon: Icon(Icons.settings), text: 'Advanced'),
            Tab(icon: Icon(Icons.code), text: 'API Demo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicExample(),
          _buildThemedExample(),
          _buildAdvancedExample(),
          _buildApiDemoExample(),
        ],
      ),
    );
  }

  Widget _buildBasicExample() {
    return _EditorExample(
      title: 'Basic Rich Text Editor',
      description: 'Simple, clean editor with essential formatting tools',
      controller: _controllers[0],
      config: const EditorConfig(
        placeholder: 'Start writing your content here...',
        debugMode: true,
        mode: EditorMode.online,
        enableWordCount: true,
        autoFocus: false,
      ),
      toolbarConfig: ToolbarConfigs.basic,
      theme: EditorThemes.light,
    );
  }

  Widget _buildThemedExample() {
    return _EditorExample(
      title: 'Dark Theme Editor',
      description: 'Beautiful dark theme with modern styling',
      controller: _controllers[1],
      config: const EditorConfig(
        placeholder: 'Experience the dark side of editing...',
        debugMode: true,
        mode: EditorMode.online,
        enableWordCount: true,
        enableCharacterCount: true,
      ),
      toolbarConfig: ToolbarConfigs.full,
      theme: EditorThemes.dark,
    );
  }

  Widget _buildAdvancedExample() {
    return _EditorExample(
      title: 'Advanced Configuration',
      description: 'Full-featured editor with all available tools',
      controller: _controllers[2],
      config: const EditorConfig(
        placeholder: 'Advanced editing with all features enabled...',
        debugMode: true,
        mode: EditorMode.online,
        enableWordCount: true,
        enableCharacterCount: true,
        enableAutoResize: true,
        maxLength: 5000,
        initialContent: '''
<h2>Welcome to Flutter Summernote 2.0! 🎉</h2>
<p>This is a <strong>completely rewritten</strong> version with:</p>
<ul>
  <li>Modern Flutter architecture</li>
  <li>Comprehensive error handling</li>
  <li>Type-safe APIs</li>
  <li>Excellent developer experience</li>
</ul>
<p>Try editing this content and explore all the features!</p>
''',
      ),
      toolbarConfig: ToolbarConfigs.full,
      theme: EditorThemes.material,
    );
  }

  Widget _buildApiDemoExample() {
    return _ApiDemoExample(controller: _controllers[3]);
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flutter Summernote 2.0'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🚀 Complete Rewrite',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Built from scratch with modern Flutter patterns'),
              SizedBox(height: 16),
              Text(
                '✨ Key Features',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Type-safe APIs with full IntelliSense'),
              Text('• Comprehensive error handling'),
              Text('• Modern state management'),
              Text('• Flexible theming system'),
              Text('• Controller-based architecture'),
              Text('• CDN-based resources'),
              SizedBox(height: 16),
              Text(
                '🎯 Performance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Fast initialization (~200ms)'),
              Text('• No more silent failures'),
              Text('• Excellent debugging experience'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _EditorExample extends StatefulWidget {
  const _EditorExample({
    required this.title,
    required this.description,
    required this.controller,
    required this.config,
    required this.toolbarConfig,
    required this.theme,
  });

  final String title;
  final String description;
  final SummernoteController controller;
  final EditorConfig config;
  final ToolbarConfig toolbarConfig;
  final EditorTheme theme;

  @override
  State<_EditorExample> createState() => _EditorExampleState();
}

class _EditorExampleState extends State<_EditorExample> {
  EditorState _editorState = EditorState.initializing;
  EditorContent _content = const EditorContent(html: '', text: '', isEmpty: true);
  String _statusMessage = 'Initializing...';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        // Status Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: _getStatusColor(context),
          child: Row(
            children: [
              Icon(
                _getStatusIcon(),
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (_content.wordCount > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_content.wordCount} words',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Editor
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SummernoteEditor(
              controller: widget.controller,
              config: widget.config,
              toolbarConfig: widget.toolbarConfig,
              theme: widget.theme,
              onReady: () {
                setState(() {
                  _editorState = EditorState.ready;
                  _statusMessage = 'Editor ready! Start typing...';
                });
              },
              onContentChanged: (content) {
                setState(() {
                  _content = content;
                  _statusMessage = content.isEmpty 
                      ? 'Editor ready! Start typing...'
                      : 'Content: ${content.characterCount} chars, ${content.wordCount} words';
                });
              },
              onStateChanged: (state) {
                setState(() {
                  _editorState = state;
                  _statusMessage = switch (state) {
                    EditorState.initializing => 'Initializing editor...',
                    EditorState.loading => 'Loading content...',
                    EditorState.ready => 'Editor ready!',
                    EditorState.error => 'Editor error occurred',
                    EditorState.disposed => 'Editor disposed',
                  };
                });
              },
              onError: (exception) {
                setState(() {
                  _statusMessage = 'Error: ${exception.message}';
                });
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Editor Error: ${exception.message}'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BuildContext context) {
    return switch (_editorState) {
      EditorState.initializing || EditorState.loading => 
        Theme.of(context).colorScheme.tertiary,
      EditorState.ready => 
        Theme.of(context).colorScheme.primary,
      EditorState.error => 
        Theme.of(context).colorScheme.error,
      EditorState.disposed => 
        Theme.of(context).colorScheme.outline,
    };
  }

  IconData _getStatusIcon() {
    return switch (_editorState) {
      EditorState.initializing || EditorState.loading => Icons.hourglass_empty,
      EditorState.ready => Icons.check_circle,
      EditorState.error => Icons.error,
      EditorState.disposed => Icons.block,
    };
  }
}

class _ApiDemoExample extends StatefulWidget {
  const _ApiDemoExample({required this.controller});

  final SummernoteController controller;

  @override
  State<_ApiDemoExample> createState() => _ApiDemoExampleState();
}

class _ApiDemoExampleState extends State<_ApiDemoExample> {
  String _lastAction = 'No actions performed yet';
  bool _isEditorReady = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API Demonstration',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Explore programmatic control with the SummernoteController',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        // Action Buttons
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                context,
                'Set Sample Content',
                Icons.edit,
                _setSampleContent,
              ),
              _buildActionButton(
                context,
                'Get HTML',
                Icons.code,
                _getHtml,
              ),
              _buildActionButton(
                context,
                'Insert Text',
                Icons.text_fields,
                _insertText,
              ),
              _buildActionButton(
                context,
                'Focus Editor',
                Icons.center_focus_strong,
                _focusEditor,
              ),
              _buildActionButton(
                context,
                'Clear Content',
                Icons.clear,
                _clearContent,
              ),
              _buildActionButton(
                context,
                'Check Empty',
                Icons.help_outline,
                _checkEmpty,
              ),
            ],
          ),
        ),
        
        // Last Action Display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Text(
            'Last Action: $_lastAction',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        
        // Editor
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SummernoteEditor(
              controller: widget.controller,
              config: const EditorConfig(
                placeholder: 'Use the buttons above to interact with this editor programmatically...',
                debugMode: true,
                mode: EditorMode.online,
              ),
              toolbarConfig: ToolbarConfigs.full,
              theme: EditorThemes.material,
              onReady: () {
                setState(() {
                  _isEditorReady = true;
                  _lastAction = 'Editor initialized and ready';
                });
              },
              onError: (exception) {
                setState(() {
                  _lastAction = 'Error: ${exception.message}';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return FilledButton.icon(
      onPressed: _isEditorReady ? onPressed : null,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  void _setSampleContent() async {
    const content = '''
<h3>🎯 API Demo Content</h3>
<p>This content was set programmatically using <code>controller.setContent()</code></p>
<blockquote>
  <p>"The new Flutter Summernote 2.0 provides excellent programmatic control!"</p>
</blockquote>
<p>Features demonstrated:</p>
<ol>
  <li><strong>HTML Content Setting</strong> - Rich formatted content</li>
  <li><strong>Controller API</strong> - Programmatic access</li>
  <li><strong>Modern Architecture</strong> - Clean, maintainable code</li>
</ol>
''';
    
    final success = await widget.controller.setContent(content);
    setState(() {
      _lastAction = success 
          ? 'Successfully set sample content'
          : 'Failed to set content';
    });
  }

  void _getHtml() async {
    final html = await widget.controller.getContent();
    setState(() {
      _lastAction = 'Retrieved HTML: ${html?.length ?? 0} characters';
    });
    
    if (html != null && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('HTML Content'),
          content: SingleChildScrollView(
            child: SelectableText(
              html,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _insertText() async {
    final success = await widget.controller.insertText(
      '\n\n✨ This text was inserted programmatically! ✨\n\n',
    );
    setState(() {
      _lastAction = success 
          ? 'Successfully inserted text'
          : 'Failed to insert text';
    });
  }

  void _focusEditor() async {
    final success = await widget.controller.focus();
    setState(() {
      _lastAction = success 
          ? 'Editor focused successfully'
          : 'Failed to focus editor';
    });
  }

  void _clearContent() async {
    final success = await widget.controller.reset();
    setState(() {
      _lastAction = success 
          ? 'Content cleared successfully'
          : 'Failed to clear content';
    });
  }

  void _checkEmpty() async {
    final isEmpty = await widget.controller.isEmpty();
    setState(() {
      _lastAction = isEmpty != null 
          ? 'Editor is ${isEmpty ? "empty" : "not empty"}'
          : 'Failed to check if empty';
    });
  }
}
