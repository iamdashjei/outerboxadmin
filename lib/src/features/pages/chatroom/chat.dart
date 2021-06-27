
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:outerboxadmin/src/widget/chat_widget.dart';
class Chat extends StatelessWidget {

  const Chat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>

      Scaffold(

        body: ChatsWidget(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     final idUser = StreamChat.of(context).user.id;
        //     //print("My id " + idUser);
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => ParticipantsPage(idUser: idUser)),
        //     );
        //   },
        //   child: Icon(Icons.add),
        // ),
      );
// Column(
//   children: [
//     const SizedBox(height: 12),
//     Container(
//       height: 100,
//       child: ActiveUsersRowWidget(),
//     ),
//     Divider(),
//     Expanded(child: ChatsWidget()),
//   ],
// );
}
