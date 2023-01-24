import 'package:flutter/material.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';

void main() {
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController receiverTextController = TextEditingController();
  TextEditingController senderTextController = TextEditingController();
  String result = 'Suggestions...';
  dynamic smartReply;

  @override
  void initState() {
    super.initState();
    smartReply = SmartReply();
  }

  @override
  void dispose() {
    smartReply.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 13, right: 13),
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextField(
                              controller: receiverTextController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Received Text here...',
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          smartReply.addMessageToConversationFromRemoteUser(
                              receiverTextController.text,
                              DateTime.now().millisecondsSinceEpoch,
                              "userId");
                          receiverTextController.clear();

                          result = '';
                          final response = await smartReply.suggestReplies();
                          for (final suggestion in response.suggestions) {
                            print('suggestion: $suggestion');
                            result += '$suggestion \n';
                          }
                          setState(() {
                            result;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.red,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.only(
                              top: 13, left: 15, bottom: 13, right: 12),
                        ),
                        child: const Icon(
                          Icons.send,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  width: double.infinity,
                  height: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 30,
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        result,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 13,
                    right: 13,
                    bottom: 30,
                  ),
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: senderTextController,
                              decoration: const InputDecoration(
                                hintText: 'Sender Text here...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          smartReply.addMessageToConversationFromLocalUser(
                              senderTextController.text,
                              DateTime.now().millisecondsSinceEpoch);
                          senderTextController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          primary: Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.only(
                              top: 13, left: 15, bottom: 13, right: 12),
                        ),
                        child: const Icon(
                          Icons.send,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
