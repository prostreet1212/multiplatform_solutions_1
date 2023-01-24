import 'package:flutter/material.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({Key? key, required this.htmlText, required this.getHtmlTitle})
      : super(key: key);

  final Future<String> htmlText;
  final Function(String text) getHtmlTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 11,
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
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
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
    );
  }
}
