import 'package:cloud_firestore/cloud_firestore.dart';

class InboxUserModel {
  String name;
  String message;
  Timestamp time;
  String sender;
  String id;
  List userList;
  bool known;
  int index;
  bool readStatus;
  String type;

  InboxUserModel(
      {required this.name,
      required this.message,
      required this.time,
      required this.sender,
      required this.id,
      required this.userList,
      required this.known,
      required this.index,
      required this.readStatus,
      required this.type});
}
