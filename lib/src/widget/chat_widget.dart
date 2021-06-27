import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:intl/intl.dart';

import 'channel_list_widget.dart';

class ChatsWidget extends StatelessWidget {

  const ChatsWidget({
    Key key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idUser = StreamChat.of(context).user.id;
    //final idUser = "admin";

    return ChannelListView(
      filter: {
        'members': {
          '\$in': [idUser],
        }
      },
      sort: [SortOption('last_message_at')],
      pagination: PaginationParams(limit: 20),
      //channelWidget: ChannelPage(),
      channelPreviewBuilder: (context, channel) =>
          ChannelListWidget(channel: channel),
      //channelPreviewBuilder: _channelPreviewBuilder,
    );
  }

  // Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
  //   final lastMessage = channel.state.messages.reversed
  //       .firstWhere((message) => !message.isDeleted);
  //
  //   final subtitle = (lastMessage == null ? "nothing yet" : lastMessage.text);
  //   final opacity = channel.state.unreadCount > .0 ? 1.0 : 0.5;
  //
  //   return ListTile(
  //     onTap: () {
  //       Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => ChatPageMobile(channel: channel),
  //       ));
  //     },
  //     leading: ChannelImage(
  //       channel: channel,
  //     ),
  //     title: ChannelName(
  //
  //       channel: channel,
  //       textStyle:
  //       StreamChatTheme.of(context).channelPreviewTheme.title.copyWith(
  //         color: Colors.black.withOpacity(opacity),
  //       ),
  //     ),
  //     subtitle: Text(subtitle),
  //     trailing: channel.state.unreadCount > 0
  //         ? CircleAvatar(
  //       radius: 10,
  //       child: Text(channel.state.unreadCount.toString()),
  //     )
  //         : SizedBox(),
  //   );
  // }

  String _formatDateTime(DateTime lastMessageAt) {
    if (lastMessageAt == null) return '';

    final isRecently = lastMessageAt.difference(DateTime.now()).inDays == 0;
    final dateFormat = isRecently ? DateFormat.jm() : DateFormat.MMMd();

    return dateFormat.format(lastMessageAt);
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
