import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();
  Future<String>? htmlText = null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 12,
            child: FutureBuilder(
              initialData: '',
              future: htmlText,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        //child: Text('Неккоректный url'),
                        child: Text(snapshot.error as String),
                      );
                    } else {
                      return Padding(
                          padding:
                              const EdgeInsets.only(top: 8, right: 8, left: 8),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getHtmlTitle(snapshot.data!),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const Text(
                                  'CORS Header: None',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.redAccent),
                                ),
                                Text(snapshot.data!),
                              ],
                            ),
                          ));
                    }
                  default:
                    return Container();
                }
              },
            ),
          ),
          //Divider(thickness: 2,color: Colors.black45,),
          Container(color: Colors.black45, height: 1),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      //width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      height: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //minimumSize: Size(100, 100),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        child: const Text('LOAD'),
                        onPressed: () {
                          setState(() {
                            htmlText = getHtmlCode(textController.text);
                            //htmlText = getHtmlCode('https://flutter.dev');
                          });
                        },
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    ));
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}

Future<String> getHtmlCode(String text) async {
  try {
    var response = await Dio().get(text);
    if (response.statusCode == 200) {
      String htmlToParse = response.data;
      return htmlToParse;
    } else {
      return 'Не удалось загрузить данные';
    }
  } on DioError catch (e) {
    throw e.error.message.toString();
  }
}

String getHtmlTitle(String htmlCode) {
  var doc = parse(htmlCode);
  String title = doc.getElementsByTagName('title')[0].innerHtml;
  return title;
}
