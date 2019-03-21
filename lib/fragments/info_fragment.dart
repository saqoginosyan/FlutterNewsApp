import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InfoFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
      ),
      body: new WebView(
        initialUrl: 'https://techcrunch.com/2019/03/21/windows-virtual-desktop-is-now-in-public-preview/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
