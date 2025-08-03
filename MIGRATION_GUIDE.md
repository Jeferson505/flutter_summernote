# Migration Guide: Flutter Summernote v0.3.0

This guide helps you migrate from previous versions to v0.3.0, which includes significant improvements to DOM readiness handling, error management, and new callback APIs.

## Breaking Changes

### 1. Editor Functions Now Return `Future<bool>`

**Before (v0.2.x):**
```dart
final keyEditor = GlobalKey<FlutterSummernoteState>();

// These methods returned void
keyEditor.currentState?.setText("Hello World");
keyEditor.currentState?.setFocus();
keyEditor.currentState?.setEmpty();
keyEditor.currentState?.setFullContainer();
keyEditor.currentState?.setHint("Type here...");
```

**After (v0.3.0):**
```dart
final keyEditor = GlobalKey<FlutterSummernoteState>();

// These methods now return Future<bool>
final success = await keyEditor.currentState?.setText("Hello World");
if (success == true) {
  log("Text set successfully");
} else {
  log("Failed to set text");
}

await keyEditor.currentState?.setFocus();
await keyEditor.currentState?.setEmpty();
await keyEditor.currentState?.setFullContainer();
await keyEditor.currentState?.setHint("Type here...");
```

### 2. New Loading State Behavior

**Before (v0.2.x):**
- Editor was immediately available (but might fail silently)

**After (v0.3.0):**
- Editor shows a modern loading indicator until fully initialized
- Operations are blocked until editor is ready
- Clear visual feedback for initialization state

## New Features

### 1. Callback Functions

Add new callback functions to handle editor lifecycle events:

```dart
FlutterSummernote(
  key: keyEditor,
  offlineSupport: true,
  
  // NEW: Called when editor is fully ready
  onReady: () {
    log('Editor is ready for use!');
    // Safe to call editor methods now
  },
  
  // NEW: Called when errors occur
  onError: (String error) {
    log('Editor error: $error');
    // Handle errors appropriately
  },
  
  // NEW: Called when editor gains focus
  onFocus: () {
    log('Editor focused');
  },
  
  // NEW: Called when editor loses focus
  onBlur: () {
    log('Editor blurred');
  },
  
  // Existing callback (unchanged)
  returnContent: (String content) {
    log('Content changed: $content');
  },
)
```

### 2. Readiness Check

Check if the editor is ready before performing operations:

```dart
final keyEditor = GlobalKey<FlutterSummernoteState>();

// NEW: Check if editor is ready
if (keyEditor.currentState?.isReady == true) {
  await keyEditor.currentState?.setText("Safe to set text");
} else {
  log("Editor not ready yet");
}
```

### 3. Error Information

Access error information from the editor state:

```dart
final keyEditor = GlobalKey<FlutterSummernoteState>();

// NEW: Get last error message
final error = keyEditor.currentState?.errorMessage;
if (error != null) {
  log("Last error: $error");
}
```

## Migration Steps

### Step 1: Update Function Calls

1. Add `await` to all editor method calls
2. Handle the `Future<bool>` return values
3. Add error checking where needed

### Step 2: Add Callback Handlers

1. Add `onReady` callback to know when editor is initialized
2. Add `onError` callback for error handling
3. Optionally add `onFocus` and `onBlur` for UI feedback

### Step 3: Update Error Handling

Replace silent failures with proper error handling:

**Before:**
```dart
// Silent failure - no way to know if it worked
keyEditor.currentState?.setText("Hello");
```

**After:**
```dart
// Proper error handling
try {
  final success = await keyEditor.currentState?.setText("Hello");
  if (success != true) {
    // Handle failure
    showErrorDialog("Failed to set text");
  }
} catch (e) {
  // Handle exception
  showErrorDialog("Error: $e");
}
```

### Step 4: Handle Loading States

The editor now shows a loading indicator automatically, but you can customize your UI based on the ready state:

```dart
class MyEditorWidget extends StatefulWidget {
  @override
  _MyEditorWidgetState createState() => _MyEditorWidgetState();
}

class _MyEditorWidgetState extends State<MyEditorWidget> {
  final keyEditor = GlobalKey<FlutterSummernoteState>();
  bool editorReady = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Your custom UI can react to editor state
        if (!editorReady)
          Text("Please wait, editor is loading..."),
        
        Expanded(
          child: FlutterSummernote(
            key: keyEditor,
            offlineSupport: true,
            onReady: () {
              setState(() {
                editorReady = true;
              });
            },
            onError: (error) {
              setState(() {
                editorReady = false;
              });
              // Show error to user
            },
          ),
        ),
        
        // Buttons are disabled until editor is ready
        ElevatedButton(
          onPressed: editorReady ? () async {
            await keyEditor.currentState?.setText("Hello");
          } : null,
          child: Text("Set Text"),
        ),
      ],
    );
  }
}
```

## Common Migration Issues

### Issue 1: Synchronous Code Expecting Immediate Results

**Problem:**
```dart
// This won't work anymore
keyEditor.currentState?.setText("Hello");
final text = keyEditor.currentState?.getText(); // May be empty
```

**Solution:**
```dart
// Wait for operations to complete
await keyEditor.currentState?.setText("Hello");
final text = await keyEditor.currentState?.getText();
```

### Issue 2: No Error Handling

**Problem:**
```dart
// Silent failures
keyEditor.currentState?.setText("Hello");
```

**Solution:**
```dart
// Proper error handling
final success = await keyEditor.currentState?.setText("Hello");
if (success != true) {
  // Handle the error
  log("Failed to set text");
}
```

### Issue 3: Calling Methods Before Editor is Ready

**Problem:**
```dart
// Called immediately after widget creation
keyEditor.currentState?.setText("Hello"); // May fail
```

**Solution:**
```dart
// Wait for onReady callback
FlutterSummernote(
  onReady: () async {
    // Now safe to call methods
    await keyEditor.currentState?.setText("Hello");
  },
)
```

## Benefits of Migration

1. **Reliability**: No more silent failures due to DOM timing issues
2. **Better UX**: Clear loading states and error feedback
3. **Debugging**: Detailed error information and logging
4. **Future-proof**: Robust foundation for future features

## Testing Your Migration

Use the new stress test example to verify your implementation:

```dart
import 'package:flutter_summernote/example/stress_test_example.dart';

// Run stress tests to ensure reliability
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => StressTestExample()),
);
```

## Need Help?

- Check the new error handling example for implementation patterns
- Use the stress test to verify your implementation
- Enable debug mode to see detailed error information
- Check the console for initialization and error logs

For more examples, see:
- `example/lib/error_handling_example.dart`
- `example/lib/stress_test_example.dart`
