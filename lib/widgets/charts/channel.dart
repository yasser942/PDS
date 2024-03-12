import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
const String kLogExamplePage = '''
<!DOCTYPE html>
<html>
<head>
<title>Data Collection Dashboard</title>
</head>
<body>
<table border=2 bordercolor="#0000FF">
<tr><td colspan="2">
<h1 align="center" color="#00FFFF">Data Collection Dashboard</h1>
</td></tr>
<tr><td>
<iframe width="600" height="600" style="border: 1px solid #cccccc;" src="https://thingspeak.com/channels/320695/charts/1?bgcolor=%23ffffff&color=%23F62020&dynamic=true&results=800&type=line&update=15"></iframe>
</td>
<td><iframe width="450" height="260" style="border: 1px solid #cccccc;" src="https://thingspeak.com/apps/matlab_visualizations/166526?color=%23FFFFFF&dynamic=true"></iframe>
</td></tr>
<tr><td>
<iframe width="450" height="260" style="border: 1px solid #cccccc;" src="https://thingspeak.com/channels/12397/charts/2?results=720&dynamic=true&update=15"></iframe>
</td>
<td>
<iframe width="300" style="border: 1px solid #cccccc;" src="https://thingspeak.com/apps/matlab_visualizations/308777"></iframe>
<h3>Links</h3>
<a href="https://www.google.com">Google</a><br>
<a href="https://www.Mathworks.com">Mathworks</a><br>
<a href="https://en.wikipedia.org/wiki/Cleve_Moler">Wikipedia</a>
</td>
</html>
''';



class Channel extends StatefulWidget {
  Channel({super.key});

  @override
  State<Channel> createState() => _ChannelState();
}

class _ChannelState extends State<Channel> {
  final WebViewController webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..enableZoom(true)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ),
    )
    ..loadHtmlString(kLogExamplePage, );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebViewWidget(controller: webViewController)),
    );
  }
}
