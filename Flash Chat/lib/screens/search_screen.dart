import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/utils/chat_tile.dart';

class SearchScreen extends StatefulWidget {

  final String uid;
  final Map<String, dynamic> currUserMap;


  const SearchScreen(this.uid, this.currUserMap,{super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Size size = MediaQuery.of(context).size;
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  bool isEmpty = true;

  late List<Widget> results=[];
  final TextEditingController _search = TextEditingController();

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
        .where("Name", isEqualTo: _search.text)
        .get()
        .then((querySnapshot) => {
          if(querySnapshot.size>1) {
            setState(()=>{
              isLoading = false,
            }),
            for(var doc in querySnapshot.docs){
                if(doc.data()['uid']!=widget.currUserMap['uid']){
                  setState(()=>{
                    results.add(ChatTile(receiverUserMap: doc.data(), senderUserMap: widget.currUserMap, chatId: chatId(doc.data()['uid'],widget.uid), controller: _controller, isSearch: true, add: () async{
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      await firestore.collection('userUI').doc(widget.currUserMap!['uid']).collection('chats').doc(doc.data()!['uid']).set(doc.data()!);
                      await firestore.collection('userUI').doc(doc.data()!['uid']).collection('chats').doc(widget.currUserMap!['uid']).set(widget.currUserMap!);
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
                  results.add(ChatTile(receiverUserMap: doc.data(), senderUserMap: widget.currUserMap, chatId: chatId(doc.data()['uid'],widget.uid), controller: _controller, isSearch: true, add: () async{
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    await firestore.collection('userUI').doc(widget.currUserMap!['uid']).collection('chats').doc(doc.data()!['uid']).set(doc.data()!);
                    await firestore.collection('userUI').doc(doc.data()!['uid']).collection('chats').doc(widget.currUserMap!['uid']).set(widget.currUserMap!);
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
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
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
                      controller: _search,
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
                  color: Colors.blueAccent,
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
                  height: MediaQuery.of(context).size.height/3.5,
                    child: isEmpty?Container():
                    ListView(
                      addRepaintBoundaries: false,
                        children: results,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

