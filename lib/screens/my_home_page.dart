import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';
import 'package:multiplatform_solutions_1/widgets/find_panel.dart';
import 'package:multiplatform_solutions_1/widgets/html_view.dart';
import '../app_platform.dart';

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

  void load(String s) {
    setState(() {
      htmlText = getHtmlCode(s);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HtmlView(
            htmlText: htmlText,
            getHtmlTitle: getHtmlTitle,
          ),
          //Divider(thickness: 2,color: Colors.black45,),
          Container(color: Colors.black45, height: 1),
          FindPanel(load: load),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'APPLICATION RUNNING ON ${AppPlatform.platform.toUpperCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    ));
  }
}
