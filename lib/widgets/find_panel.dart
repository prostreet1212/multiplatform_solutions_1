import 'package:flutter/material.dart';

import '../app_platform.dart';


class FindPanel extends StatefulWidget {
   FindPanel({Key? key,required this.load}) : super(key: key);

  Function(String url) load;

  @override
  State<FindPanel> createState() => _FindPanelState();
}

class _FindPanelState extends State<FindPanel> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text='https://google.com';
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                          widget.load(textController.text);
                          //htmlText = getHtmlCode(textController.text);
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
        ));
  }
}
