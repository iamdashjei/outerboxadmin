import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:outerboxadmin/src/features/pages/chatroom/chat_page_mobile.dart';

class ChannelListWidget extends StatelessWidget {
  final Channel channel;

  const ChannelListWidget({
    Key key,
    @required this.channel,
  }) : super(key: key);

  Future<void> _showNotification(String message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, String id, String channelId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String notify = prefs.getString("notify") ?? null;

    if(notify == null){
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelId, 'outerboxchannel', 'outerbox',
          importance: Importance.Max, priority: Priority.High, ticker: 'ticker', sound: RawResourceAndroidNotificationSound('swiftly'),  playSound: true );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          int.parse(id), 'Outerbox', message, platformChannelSpecifics,
          payload: 'item x');
      //AudioPlayer audioPlayer;

      playLocalAsset();

      prefs.setString(notify, "notified");

    } else {
      if(notify != "notified"){
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            channelId, 'outerboxchannel', 'outerbox',
            importance: Importance.Max, priority: Priority.High, ticker: 'ticker', sound: RawResourceAndroidNotificationSound('swiftly'),  playSound: true );
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            int.parse(id), 'outerbox', message, platformChannelSpecifics,
            payload: 'item x');
        //AudioPlayer audioPlayer;

        playLocalAsset();

        prefs.setString(notify, "notified");
      }
    }


  }

  Future<AudioPlayer> playLocalAsset() async {
    AudioCache cache = new AudioCache();
    return await cache.play("swiftly.mp3");
  }



  @override
  Widget build(BuildContext context) {
    final idUser = StreamChat.of(context).user.id;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final name = channel.createdBy.id == idUser ? channel.extraData['name'].toString() : channel.createdBy.extraData["fullName"].toString();
    final urlImage = channel.extraData['image'];
    //final userStatus = channel.createdBy.id == idUser &&  channel.state.members.first.user.name == channel.extraData['name'].toString() ? channel.createdBy.extraData["status"].toString() : "";
    bool hasMessage, isOnline;
    String lastMessage;
    String lastMessageAt;
    String nameChannel;
    String userStatus;

    //print(channel.lastMessageAt);

    if(channel.state.messages.isNotEmpty){

      if(channel.state.messages.last.attachments?.isNotEmpty == true && channel.state.messages.last.attachments.first.type == "image"){
        lastMessage = channel.state.messages.last.user.extraData["fullName"] +": sent a photo";
      } else if(channel.state.messages.last.attachments?.isNotEmpty == true && channel.state.messages.last.attachments.first.type == "video"){
        lastMessage = channel.state.messages.last.user.extraData["fullName"]  +": sent a video";
      } else {
        lastMessage = channel.state.messages.last.user.extraData["fullName"]  +": "+ channel.state.messages.last.text;
      }

      lastMessageAt = _formatDateTime(channel.lastMessageAt.toLocal());
      if(channel.state.unreadCount > 0){
        _showNotification(channel.state.messages.last.user.extraData["fullName"]  + ": " + channel.state.messages.last.text,
            flutterLocalNotificationsPlugin, channel.lastMessageAt.millisecond.toString(), channel.id);

      }
    } else {
      lastMessage = "No message";
      lastMessageAt = _formatDateTime(channel.createdAt.toLocal());
    }

    if(channel.createdBy.id == idUser){
      nameChannel = channel.extraData['name'].toString();
      if(channel.state.members.first.user.name == nameChannel){
        isOnline = channel.state.members.first.user.online;
        userStatus = channel.state.members.first.user.extraData["status"].toString();
      } else {
        isOnline = channel.state.members.last.user.online;
        userStatus = channel.state.members.last.user.extraData["status"].toString();
      }
    } else {
      nameChannel = channel.createdBy.extraData["fullName"].toString();
      isOnline = channel.createdBy.online;
      userStatus = channel.createdBy.extraData["status"].toString();
    }
    //final lastMessage = hasMessage ? channel.state.messages.last.user.extraData["fullName"] + ": " +channel.state.messages.last.text : '';
    //final lastMessageAt = _formatDateTime(channel.lastMessageAt);
    // final _auth = auth.FirebaseAuth.instance;
    // List<String> userEmailLoggedIn = _auth.currentUser.email.split("@");
    // String memberName = "";
    // String nameChannel;

    // if(channel.isGroup){
    //   nameChannel = name;
    // } else {
    //   if(channel.createdBy.id != userEmailLoggedIn[0].toString()){
    //     nameChannel = channel.createdBy.extraData["name"].toString();
    //     //print("True");
    //   } else {
    //     //print("Email => " + channel.createdBy.id);
    //     nameChannel = channel.state.members.last.user.extraData["name"].toString();
    //   }
    // }




    return buildChannel(
        context,
        channel: channel,
        name: name,
        urlImage: urlImage,
        lastMessage: lastMessage,
        lastMessageAt: lastMessageAt,
        isOnline: isOnline,
        userStatus: userStatus
    );
  }

  Widget buildChannel(
      BuildContext context, {
        @required Channel channel,
        @required String name,
        @required String urlImage,
        @required String lastMessage,
        @required String lastMessageAt,
        @required bool isOnline,
        @required String userStatus
      }) =>

      ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatPageMobile(channel: channel, userName: name),
          ));
        },
        //leading: Image.asset('assets/image/online_presence2.png', width: 25, height: 25),
        // leading: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //             Image.asset('assets/image/online_presence.png'),
        //                 SizedBox(
        //                    height: 4,
        //                 ),
        //             Container(),
        //         ],
        //     ),
        // title: Text(
        //   name,
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).textScaleFactor * 15,),
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            presenceStatus(userStatus),
            //FirebaseDatabasePresence().presence(name),
            //isOnline == true ? Image.asset('assets/image/online_presence2.png', width: 20, height: 20) : Image.asset('assets/image/offline_presence.png', width: 20, height: 20),
            SizedBox(width: 10),
            Text(name , style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).textScaleFactor * 15,),),
          ],
        ),
        // subtitle: Text("Status"),
        subtitle: Row(
          children: [
            SizedBox(width: 25),
            Expanded(child: channel.state.unreadCount > 0 ? Text(lastMessage,
              style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black), maxLines: 1,
              overflow: TextOverflow.ellipsis,) : Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis,)),

            Text(lastMessageAt),
            SizedBox(width: 5,),
            channel.state.unreadCount > 0
                ? CircleAvatar(
              radius: 10,
              child: Text(channel.state.unreadCount.toString()),
            ) : SizedBox(),

          ],
        ),
      );

  String _formatDateTime(DateTime lastMessageAt) {
    if (lastMessageAt == null) return '';

    final isRecently = lastMessageAt.difference(DateTime.now()).inDays == 0;
    final dateFormat = isRecently ? DateFormat.jm() : DateFormat.MMMd();

    return dateFormat.format(lastMessageAt);
  }

  Widget presenceStatus(String userStatus){

    if(userStatus == "Active"){
      return Image.asset('assets/images/online_presence2.png', width: 15, height: 15);
    }  else if(userStatus == "Idle"){
      return Image.asset('assets/images/idle_icon.png', width: 13, height: 16);
    } else{
      return Image.asset('assets/images/offline_presence.png', width: 18, height: 18);
    }

  }
}
