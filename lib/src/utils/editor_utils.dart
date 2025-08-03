/*
 * Flutter Summernote 2.0 - Editor Utilities
 * 
 * Utility functions for content processing, validation, and helper methods
 */

import 'dart:convert';
import 'dart:math' as math;
import '../types/editor_types.dart';

/// Utility class for editor operations
class EditorUtils {
  EditorUtils._();

  /// Extract plain text from HTML content
  static String htmlToText(String html) {
    if (html.isEmpty) return '';
    
    // Remove HTML tags using regex
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    String text = html.replaceAll(htmlTagRegex, '');
    
    // Decode HTML entities
    text = _decodeHtmlEntities(text);
    
    // Clean up whitespace
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return text;
  }

  /// Check if HTML content is empty (only contains empty tags or whitespace)
  static bool isHtmlEmpty(String html) {
    if (html.isEmpty) return true;
    
    // Remove HTML tags and check if any meaningful content remains
    final text = htmlToText(html);
    return text.isEmpty;
  }

  /// Count words in text
  static int countWords(String text) {
    if (text.isEmpty) return 0;
    
    // Split by whitespace and filter out empty strings
    final words = text.split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    
    return words.length;
  }

  /// Count characters in text (excluding whitespace)
  static int countCharacters(String text, {bool includeSpaces = true}) {
    if (text.isEmpty) return 0;
    
    if (includeSpaces) {
      return text.length;
    } else {
      return text.replaceAll(RegExp(r'\s'), '').length;
    }
  }

  /// Create EditorContent from HTML
  static EditorContent createContent(String html) {
    final text = htmlToText(html);
    final isEmpty = isHtmlEmpty(html);
    final wordCount = countWords(text);
    final characterCount = countCharacters(text);

    return EditorContent(
      html: html,
      text: text,
      isEmpty: isEmpty,
      wordCount: wordCount,
      characterCount: characterCount,
    );
  }

  /// Sanitize HTML content (basic sanitization)
  static String sanitizeHtml(String html) {
    if (html.isEmpty) return html;

    // Remove potentially dangerous tags and attributes
    final dangerousTags = ['script', 'iframe', 'object', 'embed', 'form'];
    final dangerousAttributes = ['onclick', 'onload', 'onerror', 'javascript:'];

    String sanitized = html;

    // Remove dangerous tags
    for (final tag in dangerousTags) {
      final regex = RegExp('<$tag[^>]*>.*?</$tag>', 
          multiLine: true, caseSensitive: false);
      sanitized = sanitized.replaceAll(regex, '');
    }

    // Remove dangerous attributes
    for (final attr in dangerousAttributes) {
      final regex = RegExp('$attr\\s*=\\s*["\'][^"\']*["\']', 
          caseSensitive: false);
      sanitized = sanitized.replaceAll(regex, '');
    }

    return sanitized;
  }

  /// Validate HTML structure (basic validation)
  static bool isValidHtml(String html) {
    if (html.isEmpty) return true;

    try {
      // Basic tag matching validation
      final openTags = <String>[];
      final tagRegex = RegExp(r'<(/?)(\w+)[^>]*>', caseSensitive: false);
      final matches = tagRegex.allMatches(html);

      for (final match in matches) {
        final isClosing = match.group(1) == '/';
        final tagName = match.group(2)?.toLowerCase() ?? '';

        // Skip self-closing tags
        if (['br', 'hr', 'img', 'input', 'meta', 'link'].contains(tagName)) {
          continue;
        }

        if (isClosing) {
          if (openTags.isEmpty || openTags.last != tagName) {
            return false; // Mismatched closing tag
          }
          openTags.removeLast();
        } else {
          openTags.add(tagName);
        }
      }

      return openTags.isEmpty; // All tags should be closed
    } catch (e) {
      return false;
    }
  }

  /// Generate unique ID for editor instances
  static String generateEditorId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = math.Random().nextInt(999999);
    return 'summernote_${timestamp}_$random';
  }

  /// Escape string for JavaScript
  static String escapeForJs(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  /// Create JavaScript function call
  static String createJsCall(String functionName, List<dynamic> args) {
    final escapedArgs = args.map((arg) {
      if (arg is String) {
        return '"${escapeForJs(arg)}"';
      } else if (arg is bool) {
        return arg.toString();
      } else if (arg is num) {
        return arg.toString();
      } else if (arg == null) {
        return 'null';
      } else {
        return '"${escapeForJs(arg.toString())}"';
      }
    }).join(', ');

    return '$functionName($escapedArgs);';
  }

  /// Decode common HTML entities
  static String _decodeHtmlEntities(String text) {
    final entities = {
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&apos;': "'",
      '&nbsp;': ' ',
      '&#39;': "'",
    };

    String decoded = text;
    entities.forEach((entity, replacement) {
      decoded = decoded.replaceAll(entity, replacement);
    });

    return decoded;
  }

  /// Format file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (math.log(bytes) / math.log(1024)).floor();
    final size = bytes / math.pow(1024, i);
    
    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Extract URLs from text
  static List<String> extractUrls(String text) {
    final urlRegex = RegExp(
      r'https?://[^\s<>"{}|\\^`\[\]]+',
      caseSensitive: false,
    );
    
    return urlRegex.allMatches(text)
        .map((match) => match.group(0) ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  /// Truncate text to specified length
  static String truncateText(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    
    final truncated = text.substring(0, maxLength - ellipsis.length);
    return '$truncated$ellipsis';
  }

  /// Check if content exceeds maximum length
  static bool exceedsMaxLength(String content, int? maxLength) {
    if (maxLength == null) return false;
    
    final text = htmlToText(content);
    return text.length > maxLength;
  }

  /// Get content statistics
  static Map<String, dynamic> getContentStats(String html) {
    final text = htmlToText(html);
    final urls = extractUrls(text);
    
    return {
      'htmlLength': html.length,
      'textLength': text.length,
      'wordCount': countWords(text),
      'characterCount': countCharacters(text),
      'characterCountNoSpaces': countCharacters(text, includeSpaces: false),
      'isEmpty': isHtmlEmpty(html),
      'urlCount': urls.length,
      'urls': urls,
      'isValidHtml': isValidHtml(html),
    };
  }

  /// Debug helper to log content information
  static void debugContent(String html, {String? label}) {
    final stats = getContentStats(html);
    final prefix = label != null ? '[$label] ' : '';
    
    print('${prefix}Content Stats:');
    print('  HTML Length: ${stats['htmlLength']}');
    print('  Text Length: ${stats['textLength']}');
    print('  Word Count: ${stats['wordCount']}');
    print('  Character Count: ${stats['characterCount']}');
    print('  Is Empty: ${stats['isEmpty']}');
    print('  Is Valid HTML: ${stats['isValidHtml']}');
    print('  URL Count: ${stats['urlCount']}');
  }
}
