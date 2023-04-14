import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController _webViewController;
  late WebMessage _webMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.tryParse('http://localhost:80'),
              ),
//               initialData: InAppWebViewInitialData(data: """
//           <!DOCTYPE html>
// <html lang="en">
//   <head>
//     <meta charset="UTF-8" />
//     <meta
//       name="viewport"
//       content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
//     />
//   </head>
//   <body>
//     <h1>JavaScript Handlers (Channels) TEST</h1>
//     <button onclick="onclick">Hehe</button>
//     <script>
//       var a = 0;
//       var onclick = () => {
//         a += 1;
//         window.flutter_inappwebview.callHandler(
//           "handlerFooWithArgs",
//           1,
//           true,
//           ["bar", a],
//           { foo: "baz" }
//         );
//       };
//       /**
//        * @param {int} a - The date
//        * @param {string} b - The string
//        */
//       var onChangeFlutterCallback = (a, b) => {
//         console.log(`a: \${a + 1} str -> \${b}`);
//       };
//       window.addEventListener(
//         "flutterInAppWebViewPlatformReady",
//         function (event) {
//           // func call when ready
//           window.flutter_inappwebview
//             .callHandler("handlerFoo")
//             .then(function (result) {
//               console.log(JSON.stringify(result));
//             });
//         }
//       );
//     </script>
//   </body>
// </html>

//           """),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
                _webViewController.addJavaScriptHandler(
                    handlerName: 'handlerFooWithArgs',
                    callback: (args) {
                      print(args);
                    });
                _webViewController.addJavaScriptHandler(
                  handlerName: 'handlerFoo',
                  callback: (args) => {'sdfsdf': 'asdfsdfs'},
                );
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _webViewController.evaluateJavascript(
                  source: "onChangeFlutterCallback(2, 'hehe')");

              _webViewController.addJavaScriptHandler(
                handlerName: 'handlerFoo',
                callback: (args) => {'sdfsdf': 'asdfsdfs'},
              );
            },
            child: const Text('hihi'),
          )
        ],
      ),
    );
  }
}
