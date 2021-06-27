import 'dart:async';
import 'dart:collection';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart' as fdtb;
import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:outerboxadmin/src/features/pages/call/audio_call.dart';
import 'package:outerboxadmin/src/services/push_notif_manager.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:outerboxadmin/src/widget/video_playerwidget.dart';

class ChatPageMobile extends StatefulWidget {
  final Channel channel;
  final userName;

  const ChatPageMobile({
    @required this.channel,
    @required this.userName
  });

  @override
  _ChatPageMobileState createState() => _ChatPageMobileState();
}

class _ChatPageMobileState extends State<ChatPageMobile> {
  VideoPlayerController _controller;
  ClientRole _role = ClientRole.Broadcaster;
  Map<String, String> onlineIds = new HashMap<String, String>();
  fdtb.DatabaseReference userReference;
  final databaseReference = fdtb.FirebaseDatabase.instance.reference();
  StreamSubscription<fdtb.Event> _onUserAdded;
  StreamSubscription<fdtb.Event>  _UserUpdate;
  fdtb.Query _todoQuery;


  Future<void> onJoin() async {
    // update input validation
    // setState(() {
    //   _channelController.text.isEmpty
    //       ? _validateError = true
    //       : _validateError = false;
    // });

    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioCall(
          channelName: "messaging",
          role: _role,
        ),
      ),
    );

  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> displayIncomingCall(BuildContext context) async {
    await CallKeep.askForPermissionsIfNeeded(context);
    final callUUID = '0783a8e5-8353-4802-9448-c6211109af51';
    final number = '+46 70 123 45 67';

    await CallKeep.displayIncomingCall(
        callUUID, number, number, HandleType.number, false);
  }

  Widget presence(String fullName){
    String getFullName = fullName.split(":")[1];
    String strFullName = getFullName.substring(1, getFullName.length);
    if(onlineIds.containsKey(strFullName)){
      if(onlineIds[strFullName] == "Active"){
        return Image.asset('assets/images/online_presence2.png', width: 15, height: 15);
      }  else if(onlineIds[strFullName] == "Idle"){
        return Image.asset('assets/images/idle_icon.png', width: 13, height: 16);
      } else{
        return Image.asset('assets/images/offline_presence.png', width: 18, height: 18);
      }
    } else {
      return Image.asset('assets/images/offline_presence.png', width: 18, height: 18);
    }
  }


  @override
  Widget build(BuildContext context) => StreamChannel(
    channel: widget.channel,
    child: Scaffold(
      // appBar: ChannelHeader(
      //
      // ),
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: MessageListView(
            threadBuilder: (_, parentMessage) {
              return ThreadPage(
                parent: parentMessage,
              );
            },
            messageBuilder: _messageBuilder,

          )),
          MessageInput(
            // onMessageSent:    messageSent(widget.channel),
            sendButtonLocation: SendButtonLocation.outside,
            animationDuration: Duration(milliseconds: 0),
          ),
        ],
      ),
    ),
  );

  Widget buildAppBar(BuildContext context) {
    final channelName = widget.channel.extraData['name'];
    final idUser = StreamChat.of(context).user.id;
    bool isOnline;
    String userName;

    if(widget.channel.createdBy.id == idUser){
      userName = widget.channel.extraData['name'].toString();
      if(widget.channel.state.members.first.user.name == userName){
        isOnline = widget.channel.state.members.first.user.online;
      } else {
        isOnline = widget.channel.state.members.last.user.online;
      }
    } else {
      userName = widget.channel.createdBy.extraData["fullName"].toString();
      isOnline = widget.channel.createdBy.online;
    }

    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      //title: Text(widget.userName),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          presence(widget.userName),
          SizedBox(width: 10),
          Expanded(
            child: Text(widget.userName ,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: MediaQuery.of(context).textScaleFactor * 16,),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // IconButton(
        //   onPressed: () {
        //     displayIncomingCall(context);
        //   },
        //   icon: Icon(Icons.phone_callback),
        // ),
        IconButton(
          onPressed: onJoin,
          icon: Icon(Icons.phone, color: Colors.black,),
          //color: Colors.black,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _messageBuilder(
      BuildContext context,
      MessageDetails details,
      List<Message> messages,
      ) {
    final message = details.message;
    final isCurrentUser = StreamChat.of(context).user.id == message.user.id;
    final textAlign = isCurrentUser ? TextAlign.right : TextAlign.left;
    final color = isCurrentUser ? Colors.blueGrey : Colors.blue;
    final isRead = widget.channel.state.read.last.user.name != message.user.name;

    if(details.message.status.index == 0){

      // if(message.){
      //   PushNotificationsManager().sendAndRetrieveMessage(widget.channel.state.,
      //       channel.lastMessageAt.millisecond.toString(), details., channel.state.messages.last.user.extraData["fullName"]);
      // }

      if(widget.channel.isGroup){
        for(int x = 0; x < widget.channel.state.members.length; x++){
          Member memb = widget.channel.state.members[x];

          if(memb.user.id != StreamChat.of(context).user.id){
            if(memb.user.extraData["deviceToken"] != null){
              PushNotificationsManager().sendAndRetrieveMessage(memb.user.extraData["deviceToken"],
                  widget.channel.lastMessageAt.millisecond.toString(), details.message.text, details.message.user.extraData["fullName"]);
              print(memb.user.id);
            }
          }
        }
        playLocalAsset();
      } else {

        for(Member m in widget.channel.state.members){
          if(m.user.id != StreamChat.of(context).user.id){
            PushNotificationsManager().sendAndRetrieveMessage(m.user.extraData["deviceToken"],
                widget.channel.lastMessageAt.millisecond.toString(), details.message.text, details.message.user.extraData["fullName"]);
          }
        }
        playLocalAsset();
      }

    }

    if(isCurrentUser){
      if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "video" && message.attachments.first.assetUrl == null){
        return Container();
      } else if(message.attachments?.isNotEmpty == true && message.attachments.first.imageUrl == null && message.attachments.first.type == "image"){
        return Container();
      } else {
        Color bubbleColors = HexColor("#0A85E2");
        if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "image"){
          bubbleColors = HexColor("#fafafa");
        } else if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "video"){
          bubbleColors = HexColor("#fafafa");
        } else {
          bubbleColors = HexColor("#0A85E2");
        }

        return _buildMessageLayout(message,
            _formatDateTime(message.createdAt.toLocal()),
            isRead,
            TextAlign.left,
            CrossAxisAlignment.end,
            bubbleColors,
            BubbleType.sendBubble,
            Alignment.topRight,
            Colors.white,
            true
        );
      }


    }else{
      if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "video" && message.attachments.first.assetUrl == null){
        return Container();
      } else if(message.attachments?.isNotEmpty == true && message.attachments.first.imageUrl == null && message.attachments.first.type == "image"){
        return Container();
      } else {
        Color bubbleColors = HexColor("#D9D9D9");
        if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "image"){
          bubbleColors = HexColor("#fafafa");
        } else if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "video"){
          bubbleColors = HexColor("#fafafa");
        } else {
          bubbleColors = HexColor("#D9D9D9");
        }
        return _buildMessageLayout(message,
            _formatDateTime(message.createdAt.toLocal()),
            false,
            TextAlign.left,
            CrossAxisAlignment.start,
            bubbleColors,
            BubbleType.receiverBubble,
            Alignment.topLeft,
            Colors.black,
            false
        );
      }

    }

  }

  @override
  void initState() {
    super.initState();
    _todoQuery = databaseReference.reference().child("users");
    _onUserAdded = _todoQuery.onChildAdded.listen(onEntryUserAdded);
    _UserUpdate = _todoQuery.onChildChanged.listen(onEntryUserChanged);
    //PushNotificationsManager().init();
  }

  @override
  void dispose() {
    super.dispose();
    _onUserAdded.cancel();
    _UserUpdate.cancel();
  }

  onEntryUserAdded(fdtb.Event event) {

    if(event.snapshot.value != null){
      setState(() {
        onlineIds.putIfAbsent(event.snapshot.value["name"].toString(), () => event.snapshot.value["status"].toString());
      });


    }

    //print("IDS => " + onlineIds.values.toString());
  }

  onEntryUserChanged(fdtb.Event event) {

    if(event.snapshot.value != null){
      // print(event.snapshot.value["status"]);
      setState(() {
        onlineIds.update(event.snapshot.value["name"].toString(), (v) => event.snapshot.value["status"].toString());
      });

    }


  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("facebook_pop.mp3");
  }

  Widget _buildMessageLayout(Message message,
      String time,
      bool isRead,
      TextAlign textAlign,
      CrossAxisAlignment crossAxis,
      Color colors,
      BubbleType bubbleType,
      Alignment align,
      Color textColors,
      bool isCurrentUser
      ){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20),
        child: ChatBubble(
          clipper: ChatBubbleClipper5(type: bubbleType),
          alignment: align,
          margin: EdgeInsets.only(top: 5),
          backGroundColor: colors,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: Column(
              crossAxisAlignment:  crossAxis,
              mainAxisSize: MainAxisSize.min,
              children: [
                messageContent(message, textAlign, textColors),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          iconStatus(isRead, isCurrentUser),
                          // align == Alignment.topRight && isRead ?
                          // Icon(
                          //   Icons.done_all,
                          //   size: 18.0,
                          //   color: Colors.blue,
                          // ) : Icon(
                          //   Icons.done_outlined,
                          //   size: 18.0,
                          //   color: Colors.grey,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget iconStatus(isRead, isCurrentUser){

    if(isCurrentUser){

      if(isRead){
        return Icon(
          Icons.done_all,
          size: 18.0,
          color: HexColor("#DF00FE"),
        );
      } else {
        return Icon(
          Icons.done_outlined,
          size: 18.0,
          color: HexColor("#DF00FE"),
        );
      }
    } else {
      return Container();
    }

  }

  Widget messageContent(Message message, TextAlign textAlign, Color color){
    if(message.attachments?.isNotEmpty == true && message.attachments.first.type == "image"){
      String imageUrl = message.attachments.first.imageUrl;
      List<String> splitItem = imageUrl.split("?");
      //print("Image");
      return CachedNetworkImage(
          imageUrl: splitItem[0].toString()
      );
    } else if (message.attachments?.isNotEmpty == true && message.attachments.first.type == "video") {
      String imageUrl = message.attachments.first.assetUrl != null ? message.attachments.first.assetUrl : null;

      if(imageUrl != null){
        List<String> splitItem = imageUrl.split("?");
        //return VideoPlayerWidget(splitItem[0].toString());
        return Text("(Video Attachment)");
      } else {
        return Container();
      }

    } else {
      return Text(
        message.text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 16 , color: color),
      );
    }

  }

  String _formatDateTime(DateTime lastMessageAt) {
    if (lastMessageAt == null) return '';

    final isRecently = lastMessageAt.difference(DateTime.now()).inDays == 0;
    final dateFormat = isRecently ? DateFormat.jm() : DateFormat.MMMd();

    return dateFormat.format(lastMessageAt);
  }
}

class ThreadPage extends StatelessWidget {
  final Message parent;

  ThreadPage({
    Key key,
    this.parent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(
        parent: parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              parentMessage: parent,
            ),
          ),
          MessageInput(
            parentMessage: parent,
          ),
        ],
      ),
    );
  }
}
