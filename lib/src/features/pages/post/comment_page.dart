import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outerboxadmin/src/models/post_details_model.dart';
import 'package:outerboxadmin/src/models/post_model.dart';
import 'package:outerboxadmin/src/models/comment_model.dart';
import 'package:outerboxadmin/src/models/FirebaseUser.dart';
import 'package:outerboxadmin/src/utils/user_sessions.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:outerboxadmin/src/utils/themes.dart';
import 'package:outerboxadmin/src/widget/video_playerwidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:outerboxadmin/src/api_connection/firebase_google_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:outerboxadmin/src/widget/chewie_widget.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:timeago/timeago.dart' as timeago;

class CommentPage extends StatefulWidget {
  final String uid;
  final PostDetailsModel postData;
  final String displayName;

  const CommentPage({Key key, @required this.uid, @required this.postData, @required this.displayName}) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState(uid, postData);

}

class _CommentPageState extends State<CommentPage> {
  final String uid;
  final PostDetailsModel postData;
  final databaseReference = FirebaseDatabase.instance.reference();
  DatabaseReference postReference;
  final List<PostModel> _postModel = List();
  TextEditingController postController = TextEditingController();
  TextEditingController editController = TextEditingController();
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference postItems, profileReference;
  Query _todoQuery;
  StreamSubscription<Event> _onCommentAddedSubscription;
  StreamSubscription<Event> _onCommentChangedSubscription;
  FirebaseUser firebaseUser = new FirebaseUser();
  List<FirebaseUser> firebaseUserList = new List();
  Map<String, String> onlineIds = new HashMap<String, String>();
  SharedPreferences preferences;

  String updatedImage, updatedText, updatedMyUserFullname;
  StreamSubscription<Event> _onUserAddedSubscription;
  StreamSubscription<Event> _onUserChangedSubscription;
  Query _todoUserQuery, _todoUpdateQuery;

  StreamSubscription<Event> _onUserAdded;
  StreamSubscription<Event> _UserUpdate;

  Asset images;
  String imageUrls;
  NetworkImage _listOfImages;
  File video, image;
  String videosStrUrl;

  final _controller = ScrollController();

  _CommentPageState(this.uid, this.postData);

  @override
  void initState() {
    super.initState();
    postReference = databaseReference.child("post").child(postData.id).child("comments");
    profileReference = FirebaseDatabase.instance.reference().child("users").child(uid);
    _todoQuery = databaseReference.reference().child("users").child(uid);
    _onUserAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onUserChangedSubscription = _todoQuery.onChildChanged.listen(onEntryChanged);

    _todoUpdateQuery = databaseReference.reference().child("users");
    _onUserAdded = _todoUpdateQuery.onChildAdded.listen(onEntryUserAdded);
    _UserUpdate = _todoUpdateQuery.onChildChanged.listen(onEntryUserChanged);
    //setCurrentAvatar();
    initSharedPref();
    postItems = FirebaseDatabase.instance.reference().child("post").child(postData.id).child("comments");
    _todoQuery = firebaseDatabase.reference().child("post").child(postData.id).child("comments");
    _onCommentAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAddedComment);
    _onCommentChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChangedComment);

  }

  _onEntryAddedComment(Event event) {

  }

  _onEntryChangedComment(Event event) {

  }

  onEntryAdded(Event event) {

    //print(event.snapshot.key);

    setState(() {
      if(event.snapshot.key == "avatar"){
        updatedImage = event.snapshot.value.toString();
      }
      //
    });
  }

  onEntryChanged(Event event) {
    setState(() {
      if(event.snapshot.key == "avatar"){
        updatedImage = event.snapshot.value.toString();
      }
    });
    // print("Snapshot value " + event.snapshot.value["avatar"]);
  }

  onEntryUserAdded(Event event) {

    if(event.snapshot.value != null){
      setState(() {
        onlineIds.putIfAbsent(event.snapshot.key, () => event.snapshot.value["status"].toString());
      });
    }

    //print("IDS => " + onlineIds.values.toString());
  }

  onEntryUserChanged(Event event) {

    if(event.snapshot.value != null){
      // print(event.snapshot.value["status"]);
      setState(() {
        onlineIds.update(event.snapshot.key, (v) => event.snapshot.value["status"].toString());
      });

    }


  }

  setCurrentAvatar() async{
    TransactionResult transactionResultForUser = await profileReference.runTransaction((MutableData mutableData) async {
      return mutableData;
    });
    _controller.jumpTo(_controller.position.maxScrollExtent);

    setState(() {
      updatedImage = "";
    });
  }

  initSharedPref() async {
    preferences = await SharedPreferences.getInstance();
    await UserSessions.getAdminDetails().then((value) {
      updatedMyUserFullname = value.cashierName;
      print("My user fullName => " + updatedMyUserFullname);
    });

  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OuterboxHR"),
      content: Text("Text Field cannot be empty."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.height / 2);
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text(postData.title), backgroundColor: HexColor("#0B1043")),

      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: commentList(),
            ),
            new Divider(height: 1.0),
            video != null || image != null ? new Container(
              decoration:
              new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildAttachmentComposer(),
            ) : Container(),
            new Container(
              decoration:
              new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(context),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentComposer() {

    return new IconTheme(
        data: new IconThemeData(
            color:Theme.of(context).accentColor
        ),
        child: new Container(
          padding: const EdgeInsets.all(30.0),
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          child: new Row(
            children: <Widget>[
              video != null ?
              Stack(children: [
                Container(
                  height: 150,
                  width: 150,
                  child: ChewieVideoPlayerWidget(video),
                ),
                Positioned(
                  left: 131.0,
                  child: GestureDetector(
                    onTap: (){

                      setState(() {
                        if(updatedText == " "){
                          updatedText = "";
                        }
                        video = null;
                      });

                    },
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.cancel,
                          color: Colors.blue,
                          size: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],)
                  : Container(),
              image != null ? Stack(
                children: [
                  // Container(
                  //   height: 100,
                  //   width: 100,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.all(Radius.circular(15)),
                  //     child: AssetThumb(
                  //       asset: asset,
                  //       width: 300,
                  //       height: 300,
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 75,
                    width: 75,
                    child: Image.file(image, height: 75, width: 75),
                  ),
                  Positioned(
                    top: 5.0,
                    left: 60.0,
                    child: GestureDetector(
                      onTap: (){

                        setState(() {
                          if(updatedText == " "){
                            updatedText = "";
                          }
                          image = null;
                        });

                      },
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.blue,
                            size: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ) : Container(),
              // image != null ? Container(
              //   height: 75,
              //   width: 75,
              //   child: Image.file(image, height: 75, width: 75),
              // ) : Container(),
              //Text("Right now uploading"),
              // new Container(
              //   margin: new EdgeInsets.symmetric(horizontal: 3.0),
              //   child: new IconButton(
              //       icon: new Icon(
              //         Icons.photo_camera,
              //         color: Theme.of(context).accentColor,
              //       ),
              //       onPressed: () async {
              //
              //       }),
              // ),
              // new Flexible(
              //   child: new TextField(
              //     autofocus: true,
              //     maxLines: 1,
              //     controller: postController,
              //     keyboardType: TextInputType.multiline,
              //     onChanged: (text) {
              //       setState(() {
              //         updatedText = text;
              //       });
              //     },
              //     decoration:
              //     new InputDecoration.collapsed(hintText: "Write a comment..."),
              //   ),
              // ),
            ],
          ),
        ));
  }

  Widget _buildTextComposer(BuildContext context) {

    return new IconTheme(
        data: new IconThemeData(
            color:Theme.of(context).accentColor
        ),
        child: new Container(
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 3.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.INFO,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Upload a file',
                        desc: '',
                        btnCancelColor: Colors.green,
                        btnCancelText: "Select Video",
                        btnCancelOnPress: () {
                          _openVideoGallery(context);
                        },
                        btnOkColor: Colors.green,
                        btnOkText: "Select Image",
                        btnOkOnPress: () {
                          _openImageGallery(context);
                        },
                      )..show();
                    }),
              ),
              new Flexible(
                child: new TextField(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  autofocus: true,
                  maxLines: 1,
                  controller: postController,
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    setState(() {
                      updatedText = text;
                    });
                  },
                  decoration:
                  new InputDecoration.collapsed(hintText: "Write a comment...", hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                ),
              ),
              new Container(
                //margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(context),
              ),
            ],
          ),
        ));
  }

  IconButton getDefaultSendButton(BuildContext context) {
    return IconButton(
      icon: updatedText != null && updatedText != "" ?  Icon(Icons.send,
        color: Colors.blue,
        size: 30.0,) : Icon(Icons.send,
        color: Colors.grey,
        size: 30.0,),
      onPressed: () {
        postComment(postData, postController, context);
      },
    );
  }

  Widget bannerImage(){
    return Container(
      child: Image.asset(
        postData.imageURL,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget summary(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        postData.summary,
        style: TextThemes.title,
      ),
    );
  }

  Widget postTimeStamp(){
    final TextStyle timeTheme = TextThemes.dateStyle;

    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text(postData.postTime, style: timeTheme),
    );
  }

  Widget postStats(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Icon(Icons.thumb_up, color: Colors.blueAccent),
        ),
        Text(postData.reacts.toString()),
        // Column(
        //     children: <Widget>[
        //       Padding(
        //         padding: const EdgeInsets.only(right: 2.0),
        //         child: Icon(Icons.thumb_up, color: Colors.blueAccent),
        //       ),
        //       Text(postData.reacts.toString()),
        //   ],
        //   )
      ],
    );
  }

  Widget presence(String userId){

    if(onlineIds.containsKey(userId)){
      if(onlineIds[userId] == "Active"){
        return Image.asset('assets/images/online_presence2.png', width: 15, height: 15);
      }  else if(onlineIds[userId] == "Idle"){
        return Image.asset('assets/images/idle_icon.png', width: 13, height: 16);
      } else{
        return Image.asset('assets/images/offline_presence.png', width: 18, height: 18);
      }
    } else {
      return Image.asset('assets/images/offline_presence.png', width: 18, height: 18);
    }
  }

  Widget commentList(){

    return Align(
      alignment: Alignment.center,
      child: Container(
          height: 500,
          padding: const EdgeInsets.all(8.0),
          child: new FirebaseAnimatedList(
              controller: _controller,
              //physics: NeverScrollableScrollPhysics(),
              query: postItems,
              reverse: false,
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                // return Expanded(
                //   child: Text("Test"),
                // );
                if(snapshot.value["status"] != "deleted"){
                  CommentModel commentModel = new CommentModel(comment: snapshot.value["comment"], time: snapshot.value["time"],
                      user: snapshot.value["user"], userId:  snapshot.value["userId"], status: snapshot.value["status"], userAvatar: snapshot.value["userAvatar"], timestamp: snapshot.value["timestamp"],
                      imgUrl: snapshot.value["imgUrl"],
                      videoUrl: snapshot.value["videoUrl"],
                      like: snapshot.value["like"],
                      comments: snapshot.value["comments"]
                  );

                  return commentContainer(commentModel, [], snapshot.key);
                } else {
                  return SizedBox();
                }

              }
          )
      ),
    );
  }

  Widget commentContainer(CommentModel commentParent, List<CommentModel> subComments, String key){

    return Container(
      child: CommentTreeWidget<CommentModel, CommentModel>(
        commentParent, subComments,
        //Comment(avatar: 'null', userName: 'null', content: 'felangel made felangel/cubit_and_beyond public asdsadsadsadsadsadasdasdsadsadasdsadsa '),
        //[
        //Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams'),
        // Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
        // Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams'),
        // Comment(avatar: 'null', userName: 'null', content: 'A Dart template generator which helps teams generator which helps teams '),
        //],
        // treeThemeData: TreeThemeData(
        //     lineColor: Colors.white,
        //     lineWidth: 3
        // ),
        avatarRoot: (context, data) => PreferredSize(
          // child: CircleAvatar(
          //   radius: 18,
          //   backgroundColor: Colors.grey,
          //   backgroundImage: AssetImage('assets/image/eagle.png'),
          // ),
          // preferredSize: Size.fromRadius(18),
          child: Container(),
          preferredSize: Size.fromRadius(6),
        ),
        avatarChild: (context, data) => PreferredSize(
          // child: CircleAvatar(
          //   radius: 6,
          //   backgroundColor: Colors.white,
          //   backgroundImage: AssetImage('assets/image/online_presence2.png'),
          // ),
          // preferredSize: Size.fromRadius(6),
          child: Container(),
          preferredSize: Size.fromRadius(6),
        ),
        contentChild: (context, data) {
          int commentText = 30;
          return GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     Image.asset('assets/image/offline_presence.png', width: 21, height: 21),
                      //     Text('Admin Outer Box', style: Theme.of(context).textTheme.caption.copyWith(
                      //         fontWeight: FontWeight.w600,
                      //         color: Colors.black
                      //     ),),
                      //   ]
                      // ),
                      Wrap(
                        children: <Widget>[
                          presence(data.userId),
                          Container(
                            margin: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                            child: Text(
                              //commentItem.user,
                              data.user,
                              style: TextStyle(
                                  color: HexColor("#2C7BE3"),
                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          commentText >= 50 ?
                          Container(
                            margin: const EdgeInsets.fromLTRB(21, 1, 0, 0),
                            child: ReadMoreText(
                              data.comment,
                              trimLines: 3,
                              colorClickableText: HexColor("#C8C8C8"),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'read more',
                              trimExpandedText: 'show less',
                              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#C8C8C8")),
                            ),
                          ) : Container(
                            margin: const EdgeInsets.fromLTRB(5, 1, 0, 0),
                            child: ReadMoreText(
                              data.comment,
                              trimLines: 3,
                              colorClickableText: HexColor("#C8C8C8"),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'read more',
                              trimExpandedText: 'show less',
                              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),

                          commentText >= 50 ?
                          Container(
                              margin: const EdgeInsets.fromLTRB(21, 1, 0, 0),
                              child: Text(
                                "1 d",
                                style: TextStyle(
                                    color: HexColor("#C8C8C8"),
                                    fontSize: MediaQuery.of(context).textScaleFactor * 11,
                                    fontWeight: FontWeight.normal),
                              )
                          ) : Container(
                              margin: const EdgeInsets.fromLTRB(5, 4, 0, 0),
                              child: Text(
                                "1hr",
                                style: TextStyle(
                                    color: HexColor("#C8C8C8"),
                                    fontSize: MediaQuery.of(context).textScaleFactor * 11,
                                    fontWeight: FontWeight.normal),
                              )
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Text('Like'),
                        SizedBox(width: 24,),
                        Text('Reply'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        contentRoot: (context, data) {
          String result = "";
          String timeAgoText = "";

          if(data.status == "edited"){
            var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(data.timestamp.toString()) * 1000);
            result = data.comment + " (edited) ";
            //result = "Test";
            timeAgoText = timeago.format(date , locale: 'en_short');
          } else{
            var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(data.timestamp.toString()) * 1000);
            result = data.comment;
            //result = "Test";
            timeAgoText = timeago.format(date , locale: 'en_short');
          }


          int commentText = data.user.length + result.length;
          return GestureDetector(
            onLongPress: () {

              if(widget.displayName == data.user){
                showMenu(
                  position: new RelativeRect.fromLTRB(100.0, 300.0, 50.0, 50.0),
                  context: context,
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      value: 1,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text("Edit Comment"),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: editController,
                                                cursorColor: Colors.black,
                                                // keyboardType: inputType,
                                                decoration: new InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    contentPadding:
                                                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                                    hintText: data.comment),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Save"),
                                                onPressed: () {
                                                  editComment(data, editController.text, context, key);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit),
                            Text("Edit"),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  content: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text("Are you sure to delete this comment?"),
                                            ),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                  child: Text("Yes"),
                                                  onPressed: () {
                                                    deleteComment(data, context, key);
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                  child: Text("No"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              )
                                            ],)

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              // showActionBtn(index);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: <Widget>[
                          presence(data.userId),
                          Container(
                            margin: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                            child: Text(
                              data.user,
                              style: TextStyle(
                                  color: HexColor("#2C7BE3"),
                                  fontSize: MediaQuery.of(context).textScaleFactor * 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),

                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 1, 0, 0),
                        child: ReadMoreText(
                          result,
                          trimLines: 3,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                          colorClickableText: HexColor("#C8C8C8"),
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'read more',
                          trimExpandedText: 'show less',
                          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#C8C8C8")),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(21, 1, 0, 0),
                          child: Text(
                            timeAgoText,
                            style: TextStyle(
                                color: HexColor("#C8C8C8"),
                                fontSize: MediaQuery.of(context).textScaleFactor * 12,
                                fontWeight: FontWeight.normal),
                          )
                      ),
                      // // SizedBox(height: 4,),
                      // Text('${data.content}', style: Theme.of(context).textTheme.caption.copyWith(
                      //     fontWeight: FontWeight.w300,
                      //     color: Colors.black
                      // ),),
                      data.imgUrl != "" ?  Container(
                        margin: EdgeInsets.only(left: 10.0),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(data.imgUrl),
                                fit: BoxFit.fill)),
                      ) : Container(),
                      data.videoUrl != ""  ? Container(
                        margin: EdgeInsets.only(left: 10.0),
                        height: 150,
                        width: 150,
                        child: VideoPlayerWidget(data.videoUrl),
                      ) : Container(),
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 8,),
                        Text('Like'),
                        SizedBox(width: 24,),
                        Text('Reply'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  void postComment(PostDetailsModel postData, TextEditingController postController, BuildContext context) async{
    if(postController.text.isNotEmpty){
      String videoUrl = "";
      String imgUrl = "";
      if(video != null){
        String documentID = DateTime.now().millisecondsSinceEpoch.toString();
        final videoUploadUrl = await FirebaseGoogleApi.uploadVideo('user-videos/$documentID', video);
        videoUrl = videoUploadUrl.toString();
      }

      if(image != null){
        String documentID = DateTime.now().millisecondsSinceEpoch.toString();
        final imgUploadUrl = await FirebaseGoogleApi.uploadImage('user-images/$documentID', image);
        imgUrl = imgUploadUrl;
      }


      DatabaseReference commentReference = databaseReference.child("post");
      String pushKey = commentReference.push().key;
      // print(pushKey);
      // print(postData.id);

      TransactionResult transactionResultForPost = await commentReference.child(postData.id).runTransaction((MutableData mutableData) async {
        return mutableData;
      });

      TransactionResult transactionResult = await commentReference.child(postData.id).child("comments").runTransaction((MutableData mutableData) async {
        return mutableData;
      });

      if(transactionResult.dataSnapshot.value != null){
        CommentModel commentModel = new CommentModel(user: updatedMyUserFullname, comment: postController.text,
            time: new DateTime.now().toString(), status: "posted", userId: widget.uid, userAvatar: updatedImage, timestamp: DateTime.now().millisecondsSinceEpoch,
            imgUrl: imgUrl,
            videoUrl: videoUrl,
            comments: null,
            like: null);
        Map<dynamic, dynamic> mapComment = transactionResult.dataSnapshot.value;
        mapComment.putIfAbsent(pushKey, () => commentModel.toJson());

        PostModel postModel = new PostModel();
        postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
        postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
        postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
        postModel.username = transactionResultForPost.dataSnapshot.value["username"];
        postModel.status = transactionResultForPost.dataSnapshot.value["status"];
        postModel.imgUrl = transactionResultForPost.dataSnapshot.value["imgUrl"];
        postModel.timestamp = transactionResultForPost.dataSnapshot.value["timestamp"];
        postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
        postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];
        postModel.comments = mapComment;


        if(transactionResultForPost.dataSnapshot.value["like"] != null){
          postModel.like = transactionResultForPost.dataSnapshot.value["like"];
        } else {
          postModel.like = null;
        }

        Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
        childUpdate.putIfAbsent(postData.id, () => postModel.toJson());
        commentReference.update(childUpdate);

        setState(() {
          postController.clear();
          video = null;
          image = null;
          updatedText = "";
          FocusScope.of(context).requestFocus(FocusNode());
          _controller.jumpTo(_controller.position.maxScrollExtent);
        });
      } else {
        CommentModel commentModel = new CommentModel(user: updatedMyUserFullname, comment: postController.text,
            time: new DateTime.now().toString(), status: "posted",userId: widget.uid, userAvatar: updatedImage, timestamp: DateTime.now().millisecondsSinceEpoch,
            imgUrl: imgUrl,
            videoUrl: videoUrl,
            comments: null,
            like: null);
        Map<dynamic, dynamic> mapComment = new HashMap<dynamic, dynamic>();
        mapComment.putIfAbsent(pushKey, () => commentModel.toJson());

        PostModel postModel = new PostModel();
        postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
        postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
        postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
        postModel.username = transactionResultForPost.dataSnapshot.value["username"];
        postModel.status = transactionResultForPost.dataSnapshot.value["status"];
        postModel.imgUrl = transactionResultForPost.dataSnapshot.value["imgUrl"];
        postModel.timestamp = transactionResultForPost.dataSnapshot.value["timestamp"];
        postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
        postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];
        postModel.comments = mapComment;


        if(transactionResultForPost.dataSnapshot.value["like"] != null){
          postModel.like = transactionResultForPost.dataSnapshot.value["like"];
        } else {
          postModel.like = null;
        }

        Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
        childUpdate.putIfAbsent(postData.id, () => postModel.toJson());
        commentReference.update(childUpdate);

        setState(() {
          postController.clear();
          video = null;
          image = null;
          updatedText = "";
          FocusScope.of(context).requestFocus(FocusNode());
          _controller.jumpTo(_controller.position.maxScrollExtent);

        });

      }

    } else {
      showAlertDialog(context);
    }

    //print(transactionResultForPost.dataSnapshot.value.toString());

  }

  editComment(CommentModel snapshot, String text, BuildContext context, String key) async{
    DatabaseReference commentReference = databaseReference.child("post");
    //String pushKey = commentReference.push().key;

    TransactionResult transactionResultForPost = await commentReference.child(postData.id).runTransaction((MutableData mutableData) async {
      return mutableData;
    });

    TransactionResult transactionResult = await commentReference.child(postData.id).child("comments").runTransaction((MutableData mutableData) async {
      return mutableData;
    });

    if(transactionResult.dataSnapshot.value != null){
      CommentModel commentModel = new CommentModel(user: snapshot.user, comment: text,
          time: snapshot.time, status: "edited", userId: uid,
          userAvatar: updatedImage,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          imgUrl: snapshot.imgUrl,
          videoUrl: snapshot.videoUrl,
          comments: snapshot.comments,
          like: snapshot.like);
      Map<dynamic, dynamic> mapComment = transactionResult.dataSnapshot.value;
      mapComment.update(key, (value) => commentModel.toJson());

      PostModel postModel = new PostModel();
      postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
      postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
      postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
      postModel.username = transactionResultForPost.dataSnapshot.value["username"];
      postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
      postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];
      postModel.comments = mapComment;

      if(transactionResultForPost.dataSnapshot.value["like"] != null){
        postModel.like = transactionResultForPost.dataSnapshot.value["like"];
      } else {
        postModel.like = null;
      }


      Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
      childUpdate.putIfAbsent(postData.id, () => postModel.toJson());
      commentReference.update(childUpdate);
      Navigator.pop(context);
    }
    //print("test " + index.toString());
  }

  deleteComment(CommentModel snapshot, BuildContext context, String key) async{
    DatabaseReference commentReference = databaseReference.child("post");
    //String pushKey = commentReference.push().key;

    TransactionResult transactionResultForPost = await commentReference.child(postData.id).runTransaction((MutableData mutableData) async {
      return mutableData;
    });

    TransactionResult transactionResult = await commentReference.child(postData.id).child("comments").runTransaction((MutableData mutableData) async {
      return mutableData;
    });

    if(transactionResult.dataSnapshot.value != null){
      CommentModel commentModel = new CommentModel(user: snapshot.user, comment: snapshot.comment,
          time: snapshot.time, status: "deleted",
          userId: uid,
          userAvatar: updatedImage,
          timestamp: DateTime.now().millisecondsSinceEpoch, imgUrl: snapshot.imgUrl,
          videoUrl: snapshot.videoUrl,
          comments: snapshot.comments,
          like: snapshot.like);
      Map<dynamic, dynamic> mapComment = transactionResult.dataSnapshot.value;
      mapComment.update(key, (value) => commentModel.toJson());

      PostModel postModel = new PostModel();
      postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
      postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
      postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
      postModel.username = transactionResultForPost.dataSnapshot.value["username"];
      postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
      postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];
      postModel.comments = mapComment;

      if(transactionResultForPost.dataSnapshot.value["like"] != null){
        postModel.like = transactionResultForPost.dataSnapshot.value["like"];
      } else {
        postModel.like = null;
      }


      Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
      childUpdate.putIfAbsent(postData.id, () => postModel.toJson());
      commentReference.update(childUpdate);
      Navigator.pop(context);
    }
    //print("test " + index.toString());
  }

  Future<String> userImage(String userId) async{
    DatabaseReference otherUserImage = databaseReference.child("retailers").child(userId);

    TransactionResult otherUserDetails = await otherUserImage.runTransaction((MutableData mutableData) async {
      return mutableData;
    });

    return otherUserDetails.dataSnapshot.value["avatar"];
  }

  String commentStatus(DataSnapshot dataSnapshot){
    String result = "";
    if(dataSnapshot.value != null){
      if(dataSnapshot.value["status"] == "edited"){
        var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(dataSnapshot.value["timestamp"].toString()) * 1000);
        result = dataSnapshot.value["comment"] + " (edited)";
      } else{
        result = dataSnapshot.value["comment"];
      }

    }
    return result;
  }

  String timeAgoText(DataSnapshot dataSnapshot){
    String result = "";
    var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(dataSnapshot.value["timestamp"].toString()) * 1000);
    result = timeago.format(date , locale: 'en_short');
    return result;
  }

  _openVideoGallery(BuildContext context) async {
    var video_file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    setState(() {
      video = video_file;
      updatedText = " ";
    });
  }

  _openImageGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = picture;
      updatedText = " ";
      //uploadImage(imageFile);
    });
  }
}
