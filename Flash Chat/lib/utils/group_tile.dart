import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/group/group_chat_screen.dart';
import 'package:flutterchat/screens/chat_screen.dart';

class GroupTile extends StatelessWidget {
  final Map<String, dynamic>? senderUserMap;
  final String groupName;
  final TextEditingController controller;
  final bool isSearch;

  const GroupTile({super.key, required this.groupName, required this.senderUserMap, required this.controller, this.isSearch=false});

  void onLongPress()async{
    // FirebaseFirestore.instance.collection('messages').doc(chatId).collection('message');
    // await deleteMessages();
  }

  void onAdd()async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // await firestore.collection('userUI').doc(senderUserMap!['uid']).collection('chats').doc(receiverUserMap!['uid']).set(receiverUserMap!);
    // await firestore.collection('userUI').doc(receiverUserMap!['uid']).collection('chats').doc(senderUserMap!['uid']).set(senderUserMap!);
  }

  Future<void> deleteMessages() async{
    // await FirebaseFirestore.instance.collection('userUI').doc(senderUserMap!['uid']).collection("chats").doc(receiverUserMap!['uid']).delete();
    // await FirebaseFirestore.instance.collection('userUI').doc(receiverUserMap!['uid']).collection("chats").doc(senderUserMap!['uid']).delete();

    var collection = FirebaseFirestore.instance.collection('messages').doc(groupName).collection('message');
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
          print(groupName);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> GroupChatScreen(groupName: groupName, senderName: senderUserMap!['Name'], senderUid: senderUserMap!['uid'], controller: controller)));
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
                    'images/group.png',
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
                  Text(groupName, style: const TextStyle(fontSize: 20),),
                ],
              ),
            ),
            const SizedBox(width: 20,),
            isSearch? GestureDetector(onTap: onAdd,child: const Icon(Icons.add),):
            Container()
          ],
        ),
      ),
    );
  }
}
