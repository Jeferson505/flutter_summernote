/*
 * Flutter Summernote 2.0 - Toolbar Configuration
 * 
 * Comprehensive toolbar configuration with predefined layouts and custom options
 */

import '../types/editor_types.dart';

/// Toolbar button definition
class ToolbarButton {
  const ToolbarButton({
    required this.name,
    required this.icon,
    this.tooltip,
    this.enabled = true,
    this.visible = true,
    this.customAction,
  });

  /// Button identifier
  final String name;
  
  /// Button icon (can be text, Unicode, or icon name)
  final String icon;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Whether button is enabled
  final bool enabled;
  
  /// Whether button is visible
  final bool visible;
  
  /// Custom action handler
  final String? customAction;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolbarButton &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          icon == other.icon &&
          tooltip == other.tooltip &&
          enabled == other.enabled &&
          visible == other.visible &&
          customAction == other.customAction;

  @override
  int get hashCode =>
      name.hashCode ^
      icon.hashCode ^
      tooltip.hashCode ^
      enabled.hashCode ^
      visible.hashCode ^
      customAction.hashCode;

  @override
  String toString() => 'ToolbarButton{name: $name, enabled: $enabled, visible: $visible}';
}

/// Toolbar group (collection of related buttons)
class ToolbarGroup {
  const ToolbarGroup({
    required this.name,
    required this.buttons,
    this.separator = true,
  });

  /// Group name
  final String name;
  
  /// Buttons in this group
  final List<ToolbarButton> buttons;
  
  /// Whether to show separator after this group
  final bool separator;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolbarGroup &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          buttons == other.buttons &&
          separator == other.separator;

  @override
  int get hashCode => name.hashCode ^ buttons.hashCode ^ separator.hashCode;

  @override
  String toString() => 'ToolbarGroup{name: $name, buttonCount: ${buttons.length}}';
}

/// Main toolbar configuration
class ToolbarConfig {
  const ToolbarConfig({
    this.position = ToolbarPosition.top,
    this.groups = const [],
    this.customGroups = const [],
    this.showLabels = false,
    this.compact = false,
    this.sticky = false,
    this.theme,
  });

  /// Toolbar position
  final ToolbarPosition position;
  
  /// Standard toolbar groups
  final List<ToolbarGroup> groups;
  
  /// Custom toolbar groups
  final List<ToolbarGroup> customGroups;
  
  /// Whether to show button labels
  final bool showLabels;
  
  /// Use compact layout
  final bool compact;
  
  /// Make toolbar sticky
  final bool sticky;
  
  /// Custom theme for toolbar
  final String? theme;

  /// Get all groups (standard + custom)
  List<ToolbarGroup> get allGroups => [...groups, ...customGroups];

  /// Get all buttons from all groups
  List<ToolbarButton> get allButtons {
    return allGroups.expand((group) => group.buttons).toList();
  }

  /// Check if toolbar has any buttons
  bool get hasButtons => allButtons.isNotEmpty;

  /// Create a copy with updated values
  ToolbarConfig copyWith({
    ToolbarPosition? position,
    List<ToolbarGroup>? groups,
    List<ToolbarGroup>? customGroups,
    bool? showLabels,
    bool? compact,
    bool? sticky,
    String? theme,
  }) {
    return ToolbarConfig(
      position: position ?? this.position,
      groups: groups ?? this.groups,
      customGroups: customGroups ?? this.customGroups,
      showLabels: showLabels ?? this.showLabels,
      compact: compact ?? this.compact,
      sticky: sticky ?? this.sticky,
      theme: theme ?? this.theme,
    );
  }

  @override
  String toString() => 
      'ToolbarConfig{position: $position, groupCount: ${allGroups.length}, buttonCount: ${allButtons.length}}';
}

/// Predefined toolbar buttons
class ToolbarButtons {
  ToolbarButtons._();

  // Text formatting
  static const bold = ToolbarButton(name: 'bold', icon: 'B', tooltip: 'Bold');
  static const italic = ToolbarButton(name: 'italic', icon: 'I', tooltip: 'Italic');
  static const underline = ToolbarButton(name: 'underline', icon: 'U', tooltip: 'Underline');
  static const strikethrough = ToolbarButton(name: 'strikethrough', icon: 'S', tooltip: 'Strikethrough');
  static const clear = ToolbarButton(name: 'clear', icon: '⌫', tooltip: 'Clear formatting');

  // Font styling
  static const superscript = ToolbarButton(name: 'superscript', icon: 'x²', tooltip: 'Superscript');
  static const subscript = ToolbarButton(name: 'subscript', icon: 'x₂', tooltip: 'Subscript');
  static const fontColor = ToolbarButton(name: 'fontColor', icon: 'A', tooltip: 'Font color');
  static const backColor = ToolbarButton(name: 'backColor', icon: '🎨', tooltip: 'Background color');

  // Paragraph formatting
  static const justifyLeft = ToolbarButton(name: 'justifyLeft', icon: '⬅', tooltip: 'Align left');
  static const justifyCenter = ToolbarButton(name: 'justifyCenter', icon: '⬌', tooltip: 'Align center');
  static const justifyRight = ToolbarButton(name: 'justifyRight', icon: '➡', tooltip: 'Align right');
  static const justifyFull = ToolbarButton(name: 'justifyFull', icon: '⬌', tooltip: 'Justify');

  // Lists
  static const insertUnorderedList = ToolbarButton(name: 'insertUnorderedList', icon: '•', tooltip: 'Bullet list');
  static const insertOrderedList = ToolbarButton(name: 'insertOrderedList', icon: '1.', tooltip: 'Numbered list');

  // Insert elements
  static const insertLink = ToolbarButton(name: 'insertLink', icon: '🔗', tooltip: 'Insert link');
  static const insertImage = ToolbarButton(name: 'insertImage', icon: '🖼', tooltip: 'Insert image');
  static const insertTable = ToolbarButton(name: 'insertTable', icon: '📊', tooltip: 'Insert table');
  static const insertHorizontalRule = ToolbarButton(name: 'insertHorizontalRule', icon: '—', tooltip: 'Horizontal line');

  // History
  static const undo = ToolbarButton(name: 'undo', icon: '↶', tooltip: 'Undo');
  static const redo = ToolbarButton(name: 'redo', icon: '↷', tooltip: 'Redo');

  // View
  static const codeview = ToolbarButton(name: 'codeview', icon: '<>', tooltip: 'Code view');
  static const fullscreen = ToolbarButton(name: 'fullscreen', icon: '⛶', tooltip: 'Fullscreen');
  static const help = ToolbarButton(name: 'help', icon: '?', tooltip: 'Help');
}

/// Predefined toolbar groups
class ToolbarGroups {
  ToolbarGroups._();

  static const style = ToolbarGroup(
    name: 'style',
    buttons: [
      ToolbarButtons.bold,
      ToolbarButtons.italic,
      ToolbarButtons.underline,
      ToolbarButtons.clear,
    ],
  );

  static const font = ToolbarGroup(
    name: 'font',
    buttons: [
      ToolbarButtons.strikethrough,
      ToolbarButtons.superscript,
      ToolbarButtons.subscript,
    ],
  );

  static const color = ToolbarGroup(
    name: 'color',
    buttons: [
      ToolbarButtons.fontColor,
      ToolbarButtons.backColor,
    ],
  );

  static const para = ToolbarGroup(
    name: 'para',
    buttons: [
      ToolbarButtons.insertUnorderedList,
      ToolbarButtons.insertOrderedList,
    ],
  );

  static const align = ToolbarGroup(
    name: 'align',
    buttons: [
      ToolbarButtons.justifyLeft,
      ToolbarButtons.justifyCenter,
      ToolbarButtons.justifyRight,
      ToolbarButtons.justifyFull,
    ],
  );

  static const insert = ToolbarGroup(
    name: 'insert',
    buttons: [
      ToolbarButtons.insertLink,
      ToolbarButtons.insertImage,
      ToolbarButtons.insertTable,
    ],
  );

  static const history = ToolbarGroup(
    name: 'history',
    buttons: [
      ToolbarButtons.undo,
      ToolbarButtons.redo,
    ],
  );

  static const view = ToolbarGroup(
    name: 'view',
    buttons: [
      ToolbarButtons.codeview,
      ToolbarButtons.fullscreen,
      ToolbarButtons.help,
    ],
  );
}

/// Predefined toolbar configurations
class ToolbarConfigs {
  ToolbarConfigs._();

  /// Basic toolbar with essential formatting
  static const basic = ToolbarConfig(
    groups: [
      ToolbarGroups.style,
      ToolbarGroups.para,
      ToolbarGroups.insert,
    ],
  );

  /// Minimal toolbar with only basic formatting
  static const minimal = ToolbarConfig(
    groups: [
      ToolbarGroups.style,
    ],
    compact: true,
  );

  /// Full-featured toolbar with all options
  static const full = ToolbarConfig(
    groups: [
      ToolbarGroups.style,
      ToolbarGroups.font,
      ToolbarGroups.color,
      ToolbarGroups.para,
      ToolbarGroups.align,
      ToolbarGroups.insert,
      ToolbarGroups.history,
      ToolbarGroups.view,
    ],
  );

  /// Mobile-optimized toolbar
  static const mobile = ToolbarConfig(
    groups: [
      ToolbarGroups.style,
      ToolbarGroups.para,
      ToolbarGroups.insert,
    ],
    compact: true,
    showLabels: false,
  );

  /// Read-only toolbar (view only)
  static const readOnly = ToolbarConfig(
    groups: [
      ToolbarGroups.view,
    ],
  );

  /// Empty toolbar (no buttons)
  static const empty = ToolbarConfig();
}
