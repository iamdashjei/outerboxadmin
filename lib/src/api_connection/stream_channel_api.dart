import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:outerboxadmin/src/api_connection/stream_api.dart';

class StreamChannelApi {

  static Future<Channel> createChannel(
      BuildContext context, {
        @required String name,
        @required String fromName,
        @required String toName,
        //@required File imageFile,
        @required String urlImage,
        List<String> idMembers = const [],
      }) async {
    final idChannel = Uuid().v4();


    // final urlImage =
    // await FirebaseGoogleApi.uploadImage('images/$idChannel', imageFile);

    return createGroupChannel(
      context,
      name: name,
      fromName: fromName,
      toName: toName,
      urlImage: urlImage,
      idMembers: idMembers,
      idChannel: idChannel,
    );
  }

  static Future<Channel> createGroupChannel(
      BuildContext context, {
        @required String name,
        @required String fromName,
        @required String toName,
        @required String urlImage,
        List<String> idMembers = const [],
        String idChannel,
      }) async {
    final id = idChannel ?? Uuid().v4();

    if(urlImage.isEmpty){
      urlImage = "https://raw.githubusercontent.com/socialityio/laravel-default-profile-image/master/docs/images/profile.png";
    }

    final idSelfUser = StreamChat.of(context).user.id;
    final channel = StreamApi.client.channel(
      'messaging',
      id: id,
      extraData: {
        'name': name,
        'from': fromName,
        'to': toName,
        'image': urlImage,
        'members': idMembers..add(idSelfUser),
      },
    );

    await channel.create();

    await channel.watch();
    return channel;
  }

  static Future<Channel> createChannelWithUsers({
    @required String name,
    @required String urlImage,
    List<String> idMembers = const [],
    String idChannel,
  }) async {
    final id = idChannel ?? Uuid().v4();
    if(urlImage.isEmpty){
      urlImage = "https://raw.githubusercontent.com/socialityio/laravel-default-profile-image/master/docs/images/profile.png";
    }

    final channel = StreamApi.client.channel(
      'messaging',
      id: id,
      extraData: {
        'name': name,
        'image': urlImage,
        'members': idMembers,
      },
    );

    await channel.create();

    await channel.watch();


    return channel;
  }
}
