import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';
import 'package:multiplatform_solutions_1/app_platform.dart';
import 'package:multiplatform_solutions_1/widgets/find_panel.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> htmlText = Future.error('');


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

  void load(String s){
    htmlText = getHtmlCode(s);
  }



  @override
  Widget build(BuildContext context) {
    print('aaaaaaaa');
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
          FindPanel(load: load),
        ],
      ),
    ));
  }


}
