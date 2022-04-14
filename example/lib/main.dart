import 'package:example/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Demo Flutter Summernote",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  final GlobalKey<FlutterSummernoteState> _secondKeyEditor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Flutter Summernote"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final value = (await _keyEditor.currentState?.getText());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 5),
                content: Text(value ?? "-"),
              ));
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomText("Simple example and without offline support:"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: FlutterSummernote(
                key: _keyEditor,
                offlineSupport: false,
                hint: "Start typing ...",
              ),
            ),
          ),
          const CustomText("Advanced example and with offline support:"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FlutterSummernote(
                key: _secondKeyEditor,
                offlineSupport: true,
                hasAttachment: true,
                customToolbar: """[
                  ['style', ['bold', 'italic', 'underline', 'clear']],
                  ['font', ['strikethrough', 'superscript', 'subscript']],
                  ['insert', ['link', 'table']]
                ]""",
                value: "<p>Hello There</p>",
                bottomToolbarLabels: const BottomToolbarLabels(
                  copyLabel: "Copy text",
                  attachmentLabel: "Attach file",
                  pasteLabel: "Paste text",
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
