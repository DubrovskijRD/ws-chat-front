import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/base.dart';
import 'package:flutter_application_1/entity/users.dart';

class Room extends Entity {
  late String? name;
  List<int> members = [];
  List<Message> messages = [];
  late bool isPrivate;
  DateTime? lastMessageDate;
  Room(int? id, this.name, {this.isPrivate = true, required this.members})
      : super(id);

  factory Room.fromJson(roomData) {
    return Room(
      roomData['id'],
      roomData['name'] = roomData['name'],
      isPrivate: roomData['private'],
      members: roomData['members_id'].cast<int>(),
    );
  }

  void addMessage(Message message) {
    messages.add(message);
    lastMessageDate = DateTime.fromMillisecondsSinceEpoch(messages.last.createdAt * 1000);
  }

  void addMember(int userId) {
    if (isPrivate) {
      throw Exception("Can't add member to private room");
    }
    members.add(userId);
  }

  bool containsMember(int userId) {
    return members.contains(userId);
  }
}

class Message extends Entity {
  String body;
  int messageType;
  int creatorId;
  int roomId;
  int createdAt;
  bool own = false;

  Message(int? id, this.body, this.messageType, this.roomId, this.creatorId,
      this.createdAt)
      : super(id);

  factory Message.fromJson(messageData) {
    return Message(
      messageData['id'],
      messageData['msg_body'],
      messageData['msg_type'],
      messageData['room_id'],
      messageData['creator_id'],
      messageData['created_at'],
    );
  }
}
