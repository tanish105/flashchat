import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/group/add_users.dart';

class CreateGroup extends StatefulWidget {
  final Map<String, dynamic> currUserMap;
  const CreateGroup(this.currUserMap, {super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController group = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    group.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding:
            const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                      controller: group,
                      decoration: InputDecoration(
                          hintText: "Enter Group Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, size.width / 10, 0),
                  child: IconButton(
                    onPressed: () {
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      firestore.collection('userUI').doc(widget.currUserMap['uid']).collection('chats').doc(widget.currUserMap['uid']+group.text).set({
                        'Group Name': group.text,
                        'Admin': widget.currUserMap['uid']
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUsers(groupName: group.text, currUserMap: widget.currUserMap)));
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_right_circle_fill,
                      size: size.height / 10,
                    ),
                    color: Colors.blueAccent,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
