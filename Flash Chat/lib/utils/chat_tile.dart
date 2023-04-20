import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/screens/chat_screen.dart';

class ChatTile extends StatelessWidget {
  final Map<String, dynamic>? receiverUserMap;
  final Map<String, dynamic>? senderUserMap;
  final String chatId;
  final TextEditingController controller;
  final bool isSearch;
  final VoidCallback add;

  const ChatTile({super.key, required this.receiverUserMap, required this.senderUserMap, required this.chatId, required this.controller, this.isSearch=false, required this.add});

  void onLongPress()async{
    FirebaseFirestore.instance.collection('messages').doc(chatId).collection('message');
    await deleteMessages();
  }

  Future<void> deleteMessages() async{
    await FirebaseFirestore.instance.collection('userUI').doc(senderUserMap!['uid']).collection("chats").doc(receiverUserMap!['uid']).delete();
    await FirebaseFirestore.instance.collection('userUI').doc(receiverUserMap!['uid']).collection("chats").doc(senderUserMap!['uid']).delete();

    var collection = FirebaseFirestore.instance.collection('messages').doc(chatId).collection('message');
    var snapshots = await collection.get();

    for(var doc in snapshots.docs){
      await doc.reference.delete();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
      child: MaterialButton(
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(controller, receiverUserMap!['Name'], receiverUserMap!['uid'], senderUserMap!['Name'], senderUserMap!['uid'], chatId)));
        },
        onLongPress: onLongPress,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: ClipOval(
                  child: Image.asset(
                    'images/single_user.png',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(receiverUserMap!['Name'], style: const TextStyle(fontSize: 20),),
                  Text(receiverUserMap!['Email'], style: const TextStyle(fontSize: 10, color: Colors.grey),)
                ],
              ),
            ),
            const SizedBox(width: 20,),
            isSearch? GestureDetector(onTap: add,child: const Icon(Icons.add),):
                Container()
          ],
        ),
      ),
    );
  }
}
