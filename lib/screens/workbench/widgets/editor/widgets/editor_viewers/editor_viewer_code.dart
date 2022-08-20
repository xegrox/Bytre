import 'dart:convert';
import 'dart:typed_data';

import 'package:bytre/styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'editor_viewer_impl.dart';

class EditorViewerCode extends EditorViewer {
  EditorViewerCode({Key? key}) : super(key: key);
  
  @override
  bool acceptMimeType(String mimeType) => true;

  @override
  EditorViewerState createState() => EditorViewCodeState();
}

class EditorViewCodeState extends EditorViewerState<EditorViewerCode> {

  WebViewController? controller;

  @override
  void create(String path, String extension) {
    final data = jsonEncode({'id': path, 'extension': extension});
    controller?.runJavascript('globalThis.events.emit("createBuffer", $data)');
  }

  @override
  void update(String path, Uint8List content) {
    final data = jsonEncode({
      'id': path,
      'content': String.fromCharCodes(content)
    });
    controller?.runJavascript('globalThis.events.emit("updateBuffer", $data)');
  }

  @override
  void focus(String path) {
    final data = jsonEncode({'id': path});
    controller?.runJavascript('globalThis.events.emit("switchBuffer", $data)');
  }

  @override
  void remove(String path) {
    final data = jsonEncode({'id': path});
    controller?.runJavascript('globalThis.events.emit("deleteBuffer", $data)');
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    // TODO: indicate loading
    return WebView(
      debuggingEnabled: true,
      zoomEnabled: false,
      backgroundColor: theme.elevatedBackground,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: {
        JavascriptChannel(
          name: 'BufferContent',
          onMessageReceived: (msg) {
            final data = jsonDecode(msg.message) as Map<String, dynamic>;
            final path = data['id']! as String;
            final content = data['content']! as String;
            setContent(path, Uint8List.fromList(content.codeUnits));
          }
        )
      },
      onWebViewCreated: (c) {
        c.loadFlutterAsset('assets/editor/dist/index.html');
        controller = c;
      }
    );
  }

}