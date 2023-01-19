import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';
import 'package:multiplatform_solutions_1/app_platform.dart';
import 'package:multiplatform_solutions_1/widgets/find_panel.dart';


Future<String> htmlText = Future.error('');
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();


  String getHtmlTitle(String htmlCode) {
    var doc = parse(htmlCode);
    String title = doc.getElementsByTagName('title')[0].innerHtml;
    return title;
  }

  Future<String> getHtmlCode(String text) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(text);
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

  @override
  void initState() {
    super.initState();
    textController.text='http://kdrc.ru';
  }

  @override
  Widget build(BuildContext context) {
    //textController.text = 'http://kdrc.ru';
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
                                  getHtmlTitle(snapshot.data!.trim()),
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
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
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
                          height: 60,
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
                  ),
                  Text(
                    'APPLICATION RUNNING ON ${AppPlatform.platform.toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              )),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    //textController.dispose();
    super.dispose();
  }
}
