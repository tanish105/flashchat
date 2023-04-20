import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/chat_tile.dart';

class AddUsers extends StatefulWidget {
  final String groupName;
  final Map<String, dynamic> currUserMap;
  const AddUsers({super.key, required this.groupName, required this.currUserMap});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  TextEditingController search = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  bool isEmpty = true;

  late List<Widget> results=[];

  String chatId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async{
    results = [];
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore
        .collection('users')
        .where("Name", isEqualTo: search.text)
        .get()
        .then((querySnapshot) => {
      if(querySnapshot.size>1) {
        setState(()=>{
          isLoading = false,
        }),
        for(var doc in querySnapshot.docs){
          if(doc.data()['uid']!=widget.currUserMap['uid']){
            setState(()=>{
              results.add(ChatTile(receiverUserMap: doc.data(), senderUserMap: widget.currUserMap, chatId: chatId(doc.data()['uid'],widget.currUserMap['uid']), controller: _controller, isSearch: true, add: () async{
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                firestore.collection('userUI').doc(widget.currUserMap['uid']).collection('chats').doc(widget.currUserMap['uid']+widget.groupName).collection('members').doc(doc.data()['uid']).set(doc.data());
                firestore.collection('userUI').doc(doc.data()['uid']).collection('chats').doc(widget.currUserMap['uid']+widget.groupName).set({
                  'Group Name': widget.groupName,
                  'Admin': widget.currUserMap['uid']
                });

              },)),
              isEmpty = false
            })
          }
        }
      }
      else if(querySnapshot.size==1){
        setState(()=>{
          isLoading = false,
        }),
        for(var doc in querySnapshot.docs){
          if(doc.data()['uid']!=widget.currUserMap['uid']){
            setState(()=>{
              results.add(ChatTile(receiverUserMap: doc.data(), senderUserMap: widget.currUserMap, chatId: chatId(doc.data()['uid'],widget.currUserMap['uid']), controller: _controller, isSearch: true, add: () async{
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                firestore.collection('userUI').doc(widget.currUserMap['uid']).collection('chats').doc(widget.currUserMap['uid']+widget.groupName).collection('members').doc(doc.data()['uid']).set(doc.data());
              },)),
              isEmpty = false
            })
          }
          else{
            setState(()=>{
              isLoading = false,
            }),
            showDialog(
              context: context,
              builder: (BuildContext) {
                return AlertDialog(
                  content: Container(
                    child: Text("No such user found!!"),
                  ),
                );
              },
            )
          }
        }
      }
      else{
          setState(()=>{
            isLoading = false,
          }),
          showDialog(
            context: context,
            builder: (BuildContext) {
              return AlertDialog(
                content: Container(
                  child: Text("No such user found!!"),
                ),
              );
            },
          )
        }
    });
  }

  @override
  void dispose() {
    search.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        padding: const EdgeInsets.only(
            top: 30, left: 30, right: 30, bottom: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.height / 30,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: search,
                      decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                MaterialButton(
                  onPressed: onSearch,
                  color: Colors.lightBlueAccent,
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/1.4,
                  child: isEmpty?Container():
                  ListView(
                    addRepaintBoundaries: false,
                    children: results,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
