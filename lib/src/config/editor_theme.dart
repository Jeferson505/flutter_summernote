/*
 * Flutter Summernote 2.0 - Editor Theme Configuration
 * 
 * Theming system for customizing the appearance of the editor
 */

import 'package:flutter/material.dart';

/// Editor theme configuration
class EditorTheme {
  const EditorTheme({
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderRadius = 4.0,
    this.focusBorderColor = Colors.blue,
    this.errorBorderColor = Colors.red,
    this.placeholderColor = Colors.grey,
    this.selectionColor = Colors.blue,
    this.toolbarBackgroundColor = Colors.grey,
    this.toolbarTextColor = Colors.black87,
    this.toolbarBorderColor = Colors.grey,
    this.loadingOverlayColor = Colors.white,
    this.loadingIndicatorColor = Colors.blue,
    this.errorOverlayColor = Colors.red,
    this.fontFamily = 'Arial, sans-serif',
    this.fontSize = 14.0,
    this.lineHeight = 1.5,
    this.padding = const EdgeInsets.all(12.0),
    this.shadows,
    this.customCss,
  });

  /// Editor background color
  final Color backgroundColor;

  /// Text color
  final Color textColor;

  /// Border color
  final Color borderColor;

  /// Border width
  final double borderWidth;

  /// Border radius
  final double borderRadius;

  /// Focus border color
  final Color focusBorderColor;

  /// Error border color
  final Color errorBorderColor;

  /// Placeholder text color
  final Color placeholderColor;

  /// Text selection color
  final Color selectionColor;

  /// Toolbar background color
  final Color toolbarBackgroundColor;

  /// Toolbar text color
  final Color toolbarTextColor;

  /// Toolbar border color
  final Color toolbarBorderColor;

  /// Loading overlay color
  final Color loadingOverlayColor;

  /// Loading indicator color
  final Color loadingIndicatorColor;

  /// Error overlay color
  final Color errorOverlayColor;

  /// Font family
  final String fontFamily;

  /// Font size
  final double fontSize;

  /// Line height
  final double lineHeight;

  /// Editor padding
  final EdgeInsets padding;

  /// Box shadows
  final List<BoxShadow>? shadows;

  /// Custom CSS to inject
  final String? customCss;

  /// Generate CSS for the editor
  String generateCss() {
    final buffer = StringBuffer();

    // Editor container styles
    buffer.writeln('.summernote-editor {');
    buffer.writeln('  background-color: ${_colorToCss(backgroundColor)};');
    buffer.writeln('  color: ${_colorToCss(textColor)};');
    buffer.writeln('  border: ${borderWidth}px solid ${_colorToCss(borderColor)};');
    buffer.writeln('  border-radius: ${borderRadius}px;');
    buffer.writeln('  font-family: $fontFamily;');
    buffer.writeln('  font-size: ${fontSize}px;');
    buffer.writeln('  line-height: $lineHeight;');
    buffer.writeln('  padding: ${_edgeInsetsToCSS(padding)};');
    
    if (shadows != null && shadows!.isNotEmpty) {
      buffer.writeln('  box-shadow: ${_shadowsToCSS(shadows!)};');
    }
    
    buffer.writeln('}');

    // Focus state
    buffer.writeln('.summernote-editor:focus {');
    buffer.writeln('  border-color: ${_colorToCss(focusBorderColor)};');
    buffer.writeln('  outline: none;');
    buffer.writeln('}');

    // Error state
    buffer.writeln('.summernote-editor.error {');
    buffer.writeln('  border-color: ${_colorToCss(errorBorderColor)};');
    buffer.writeln('}');

    // Placeholder
    buffer.writeln('.summernote-editor::placeholder {');
    buffer.writeln('  color: ${_colorToCss(placeholderColor)};');
    buffer.writeln('}');

    // Selection
    buffer.writeln('.summernote-editor ::selection {');
    buffer.writeln('  background-color: ${_colorToCss(selectionColor.withOpacity(0.3))};');
    buffer.writeln('}');

    // Toolbar styles
    buffer.writeln('.note-toolbar {');
    buffer.writeln('  background-color: ${_colorToCss(toolbarBackgroundColor)};');
    buffer.writeln('  color: ${_colorToCss(toolbarTextColor)};');
    buffer.writeln('  border-bottom: 1px solid ${_colorToCss(toolbarBorderColor)};');
    buffer.writeln('}');

    // Custom CSS
    if (customCss != null) {
      buffer.writeln(customCss);
    }

    return buffer.toString();
  }

  /// Convert Flutter Color to CSS color string
  String _colorToCss(Color color) {
    return 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.opacity})';
  }

  /// Convert EdgeInsets to CSS padding
  String _edgeInsetsToCSS(EdgeInsets insets) {
    return '${insets.top}px ${insets.right}px ${insets.bottom}px ${insets.left}px';
  }

  /// Convert BoxShadows to CSS box-shadow
  String _shadowsToCSS(List<BoxShadow> shadows) {
    return shadows.map((shadow) {
      return '${shadow.offset.dx}px ${shadow.offset.dy}px ${shadow.blurRadius}px ${_colorToCss(shadow.color)}';
    }).join(', ');
  }

  /// Create a copy with updated values
  EditorTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    Color? focusBorderColor,
    Color? errorBorderColor,
    Color? placeholderColor,
    Color? selectionColor,
    Color? toolbarBackgroundColor,
    Color? toolbarTextColor,
    Color? toolbarBorderColor,
    Color? loadingOverlayColor,
    Color? loadingIndicatorColor,
    Color? errorOverlayColor,
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    String? customCss,
  }) {
    return EditorTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      focusBorderColor: focusBorderColor ?? this.focusBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      placeholderColor: placeholderColor ?? this.placeholderColor,
      selectionColor: selectionColor ?? this.selectionColor,
      toolbarBackgroundColor: toolbarBackgroundColor ?? this.toolbarBackgroundColor,
      toolbarTextColor: toolbarTextColor ?? this.toolbarTextColor,
      toolbarBorderColor: toolbarBorderColor ?? this.toolbarBorderColor,
      loadingOverlayColor: loadingOverlayColor ?? this.loadingOverlayColor,
      loadingIndicatorColor: loadingIndicatorColor ?? this.loadingIndicatorColor,
      errorOverlayColor: errorOverlayColor ?? this.errorOverlayColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      padding: padding ?? this.padding,
      shadows: shadows ?? this.shadows,
      customCss: customCss ?? this.customCss,
    );
  }

  @override
  String toString() => 'EditorTheme{backgroundColor: $backgroundColor, textColor: $textColor}';
}

/// Predefined editor themes
class EditorThemes {
  EditorThemes._();

  /// Default light theme
  static const light = EditorTheme();

  /// Dark theme
  static const dark = EditorTheme(
    backgroundColor: Color(0xFF2D2D2D),
    textColor: Colors.white,
    borderColor: Color(0xFF404040),
    focusBorderColor: Colors.blueAccent,
    placeholderColor: Color(0xFF888888),
    toolbarBackgroundColor: Color(0xFF404040),
    toolbarTextColor: Colors.white,
    toolbarBorderColor: Color(0xFF555555),
    loadingOverlayColor: Color(0xFF2D2D2D),
  );

  /// Material Design theme
  static const material = EditorTheme(
    backgroundColor: Colors.white,
    textColor: Colors.black87,
    borderColor: Color(0xFFE0E0E0),
    borderRadius: 4.0,
    focusBorderColor: Colors.blue,
    shadows: [
      BoxShadow(
        color: Color(0x1F000000),
        offset: Offset(0, 1),
        blurRadius: 3,
      ),
    ],
  );

  /// Minimal theme
  static const minimal = EditorTheme(
    borderWidth: 0,
    borderRadius: 0,
    padding: EdgeInsets.all(8.0),
    toolbarBackgroundColor: Colors.transparent,
    toolbarBorderColor: Colors.transparent,
  );

  /// High contrast theme for accessibility
  static const highContrast = EditorTheme(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    borderColor: Colors.black,
    borderWidth: 2.0,
    focusBorderColor: Colors.blue,
    errorBorderColor: Colors.red,
    placeholderColor: Color(0xFF666666),
  );

  /// Rounded theme with soft appearance
  static const rounded = EditorTheme(
    borderRadius: 12.0,
    padding: EdgeInsets.all(16.0),
    shadows: [
      BoxShadow(
        color: Color(0x0F000000),
        offset: Offset(0, 2),
        blurRadius: 8,
      ),
    ],
  );
}
