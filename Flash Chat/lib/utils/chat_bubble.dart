import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  String text;
  String sender;
  bool checkSender;

  ChatBubble(
      {super.key,
      required this.text,
      required this.sender,
      required this.checkSender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment:
            checkSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              sender,
              style: const TextStyle(fontSize: 10, color: Colors.black26),
            ),
          ),
          checkSender ? Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 25, 178, 238),
                  Color.fromARGB(255, 21, 236, 229)
                ],
              ),
              // elevation: 10,
              // color: checkSender ? Colors.blueAccent : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
              //     : const BorderRadius.only(
              //   topRight: Radius.circular(10),
              //   bottomLeft: Radius.circular(10),
              //   bottomRight: Radius.circular(10),
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: checkSender ? Colors.white : Colors.black54),
              ),
            ),
          ) :
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white
                  ],
                ),
                // elevation: 10,
                // color: checkSender ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              //     : const BorderRadius.only(
              //   topRight: Radius.circular(10),
              //   bottomLeft: Radius.circular(10),
              //   bottomRight: Radius.circular(10),
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: checkSender ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
