import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:outerboxadmin/src/widget/custom_chewie_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:outerboxadmin/src/api_connection/firebase_google_api.dart';
import 'package:outerboxadmin/src/models/FirebaseUser.dart';
import 'package:outerboxadmin/src/models/comment_model.dart';
import 'package:outerboxadmin/src/models/post_details_model.dart';
import 'package:outerboxadmin/src/models/post_model.dart';
import 'package:outerboxadmin/src/features/pages/post/comment_page.dart';
import 'package:outerboxadmin/src/utils/hex_color.dart';
import 'package:outerboxadmin/src/widget/chewie_widget.dart';
import 'package:outerboxadmin/src/widget/image_container_util.dart';
import 'package:outerboxadmin/src/widget/loader.dart';
import 'package:outerboxadmin/src/widget/video_playerwidget.dart';
import 'package:outerboxadmin/src/widget/video_widget_latest.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class NewsFeed extends StatefulWidget {
  final String uid, type, displayName;

  const NewsFeed({Key key, @required this.uid, @required this.type, @required this.displayName}) : super(key: key);
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  final databaseReference = FirebaseDatabase.instance.reference();
  DatabaseReference postReference;
  final List<PostModel> _postModel = List();
  TextEditingController postController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController editController = TextEditingController();
  DatabaseReference postItems, profileReference, userReference;
  FirebaseUser firebaseUser = new FirebaseUser();
  List<FirebaseUser> firebaseUserList = new List();
  Map<String, String> userAvatars = new HashMap<String, String>();
  Map<String, String> onlineIds = new HashMap<String, String>();

  String updatedImage, updatedText;
  StreamSubscription<Event> _onMerchantAddedSubscription, _onUserAdded;
  StreamSubscription<Event> _onMerchantChangedSubscription, _UserUpdate, _postUpdate;
  Query _todoQuery, _todoUpdateQuery, _postUpdateQuery;

  bool isUploading;

  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  List<File> videos = List<File>();
  List<String> videosStrUrl = List<String>();

  ScrollController _controller = ScrollController();
  ProgressDialog pr;
  double percentage = 0.0;


  @override
  void initState() {
    super.initState();
    print("UID => " + widget.uid);
    postReference = databaseReference.child("post");
    profileReference = FirebaseDatabase.instance.reference().child("users").child(widget.uid);
    _todoQuery = databaseReference.reference().child("users").child(widget.uid);
    _onMerchantAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onMerchantChangedSubscription = _todoQuery.onChildChanged.listen(onEntryChanged);

    _todoUpdateQuery = databaseReference.reference().child("users");
    _onUserAdded = _todoUpdateQuery.onChildAdded.listen(onEntryUserAdded);
    _UserUpdate = _todoUpdateQuery.onChildChanged.listen(onEntryUserChanged);

    _postUpdateQuery = databaseReference.child("post");
    _postUpdate = _postUpdateQuery.onChildChanged.listen(_onEntryPostUpdate);

    postItems = FirebaseDatabase.instance.reference().child("post");
    postItems.onChildAdded.listen(_onEntryAddedPost);
    postItems.onChildChanged.listen(_onEntryChangedPost);

  }


  @override
  void dispose() {
    super.dispose();
    _onMerchantAddedSubscription.cancel();
    _onMerchantChangedSubscription.cancel();
    _onUserAdded.cancel();
    _UserUpdate.cancel();
    postController.dispose();
    _controller.dispose();

  }




  _onEntryAddedPost(Event event) {

  }

  _onEntryChangedPost(Event event) async {
    print("Change in post");
    //print("Notifier in scroll => " +  _controller.position.pixels.toString());
    //print("Notifier in maxScroll => " +  _controller.position.maxScrollExtent.toString());
    // setState(() {
    //   _controller.jumpTo(_controller.position.minScrollExtent);
    // });

    // Future.delayed(Duration(seconds: 3)).then((onValue) {
    //   _controller.jumpTo(0.0);
    // });
    if(event.snapshot.key != null){

      //_controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      // setState(() {
      //  // _controller.jumpTo(0.0);
      //
      // });
    }
  }



  onEntryAdded(Event event) {

    //print(event.snapshot.key);
    // if(event.snapshot.key != null){
    //   setState(() {
    //     if(event.snapshot.key == "avatar"){
    //       updatedImage = event.snapshot.value.toString();
    //     }
    //     //
    //   });
    // }

  }

  onEntryChanged(Event event) {

    // if(event.snapshot.key != null){
    //   setState(() {
    //     if(event.snapshot.key == "avatar"){
    //       updatedImage = event.snapshot.value.toString();
    //     }
    //   });
    // }
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

  _onEntryPostUpdate(Event event){
    //print("Entry update on post");
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

    if(transactionResultForUser.dataSnapshot.value != null){
      setState(() {
        updatedImage = transactionResultForUser.dataSnapshot.value["avatar"];
      });
    }

  }

  @override
  Widget build(BuildContext context) {
   // pr = new ProgressDialog(context, type: ProgressDialogType.Normal);;
    return Scaffold(
      body: new NotificationListener(
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverList(
                delegate: new SliverChildListDelegate([

                  Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.grey.withOpacity(0.5),
                          //       spreadRadius: 2,
                          //       blurRadius: 7,
                          //       offset: Offset(0, 3), // changes position of shadow
                          //     ),
                          //   ],
                          // ),
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  controller: postController,
                                  minLines: 1,
                                  maxLines: 3,
                                  onChanged: (text){
                                    setState(() {
                                      updatedText = text;
                                    });
                                  },
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(color: HexColor("#BFBFBF")),
                                      border: InputBorder.none,
                                      hintText: 'Write a post here...'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {

                                  postComment(context);

                                },
                                child: updatedText != null && updatedText != "" ? Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                ) : Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.grey,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        images.length > 0 ? Container(
                          width: 200,
                          height: images.length > 3 ? 200 : 75,
                          padding: const EdgeInsets.all(8),
                          child: buildGridView(),
                        ) : Container(),
                        videos.length > 0 ? Container(
                          width: 400,
                          height: 150,
                          padding: const EdgeInsets.all(8),
                          child: buildVideoGridView(),
                        ) : Container(),
                         Divider(),
                        _addPostOptions(),
                        Container(
                            child: FirebaseAnimatedList(
                              //controller: _controller,
                                physics: NeverScrollableScrollPhysics(),
                                query: postItems,
                                reverse: true,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                                  if (snapshot == null) {
                                    return Expanded(
                                      child: Loader(),
                                    );
                                  } else {
                                    // if(_controller.position.pixels == _controller.position.maxScrollExtent){
                                    //     setState(() {
                                    //       _controller.jumpTo(_controller.position.minScrollExtent);
                                    //     });
                                    // }
                                    _listOfImages = [];
                                    videosStrUrl = [];
                                    Map<dynamic, dynamic> multipleImgUrl = snapshot.value["multipleImgUrl"];
                                    Map<dynamic, dynamic> videoUrl = snapshot.value["videoUrl"];
                                    if(multipleImgUrl != null){
                                      multipleImgUrl.forEach((k, v) => _listOfImages.add(NetworkImage(v.toString())));
                                    }

                                    if(videoUrl != null){
                                      videoUrl.forEach((k, v) => videosStrUrl.add(v.toString()));
                                    }
                                    return _getPost(snapshot, context, _listOfImages, videosStrUrl);
                                    // if(snapshot.value["multipleImgUrl"] != null){
                                    //
                                    //   Map<dynamic, dynamic> multipleImgUrl = snapshot.value["multipleImgUrl"];
                                    //   multipleImgUrl.forEach((k, v) => _listOfImages.add(NetworkImage(v.toString())));
                                    //   return _getPost(snapshot, context, _listOfImages);
                                    // } else {
                                    //   return _getPost(snapshot, context, _listOfImages);
                                    // }
                                    //_posts.add(_getPost(snapshot));
                                    //print(snapshot.value["multipleImgUrl"].toString());
                                    //return _getPost(snapshot, context);
                                  }
                                }
                            )
                        ),
                      ]
                  )
                ]
                ))
          ],
        ), onNotification: (notification) {
        if(notification is ScrollEndNotification){
          //print(_controller.position.pixels);
          //print(_controller.position.maxScrollExtent);
          if(_controller.position.pixels == _controller.position.maxScrollExtent){
            //_controller.jumpTo(0.0);
            //print("Reached the end scroll");
            // Future.delayed(Duration(milliseconds: 1), () {
            //   _controller.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
            // });
          }
          return true;
        } else {
          return false;
        }
      },
      ),
    );

  }

  void postComment(BuildContext context) async {
    bool isUploadingVideo, isUploadingImage;
    Map<dynamic, dynamic> mapImages = new HashMap<dynamic, dynamic>();
    Map<dynamic, dynamic> mapVideos = new HashMap<dynamic, dynamic>();

    // IF Images and videos have values
    if(images.length > 0 && videos.length > 0){
      for ( var imageFile in images) {
        final urlImage = await postImage(imageFile);
        imageUrls.add(urlImage);
        // imageUrls.add("image_" + counter.toString() );
        // counter++;
      }

      for(var videoFile in videos){
        //isUploadingVideo = true;
        String documentID = DateTime.now().millisecondsSinceEpoch.toString();
        final videoUploadUrl =
        await FirebaseGoogleApi.uploadVideo('user-videos/$documentID', videoFile);
        mapVideos.putIfAbsent(documentID, () => videoUploadUrl);
      }

      if(imageUrls.length > 0){
        int sequence = 1;
        for(var stringUrl in imageUrls){
          print("Accessing string images => " + stringUrl);
          //isUploadingImage = true;
          //String documentID = DateTime.now().millisecondsSinceEpoch.toString();
          //print(stringUrl + " Uploading");
          mapImages.putIfAbsent("file_sequence_"+sequence.toString(), () => stringUrl);
          sequence++;
        }
      }

      if(videos.length == mapVideos.length && images.length == imageUrls.length){
        print("Video and Image uploading");
        isUploadingVideo = false;
        PostModel postModel = new PostModel();
        postModel.userId = widget.uid;
        postModel.postTime = new DateTime.now().toString();
        postModel.postDescription = postController.value.text;
        postModel.like = null;
        postModel.comments = null;
        postModel.timestamp = DateTime.now().millisecondsSinceEpoch;
        postModel.imgUrl = "none";
        postModel.multipleImgUrl = mapImages;
        postModel.videoUrl = mapVideos;
        postModel.status = "posted";
        postModel.username = widget.displayName;
        postReference.push().set(postModel.toJson());
        postController.clear();

        setState(() {
          images = [];
          imageUrls = [];
          videos = [];
          percentage = 0.0;
          updatedText = "";
        });
        mapImages = null;
        mapVideos = null;
        FocusScope.of(context).requestFocus(FocusNode());
      }
    }
    else if(images.length > 0 && videos.length == 0){
      // IF Image only upload
      for ( var imageFile in images) {
        final urlImage = await postImage(imageFile);
        imageUrls.add(urlImage);
        // imageUrls.add("image_" + counter.toString() );
        // counter++;
      }

      if(imageUrls.length > 0){
        int sequence = 1;
        for(var stringUrl in imageUrls){
          print("Accessing string images => " + stringUrl);
          //isUploadingImage = true;
          //String documentID = DateTime.now().millisecondsSinceEpoch.toString();
          //print(stringUrl + " Uploading");
          mapImages.putIfAbsent("file_sequence_"+sequence.toString(), () => stringUrl);
          if(mapImages.length == images.length){
            print("Only image uploading");
            isUploadingImage = false;
            PostModel postModel = new PostModel();
            postModel.userId = widget.uid;
            postModel.postTime = new DateTime.now().toString();
            postModel.postDescription = postController.value.text;
            postModel.like = null;
            postModel.comments = null;
            postModel.timestamp = DateTime.now().millisecondsSinceEpoch;
            postModel.imgUrl = "none";
            postModel.multipleImgUrl = mapImages;
            postModel.videoUrl = null;
            postModel.status = "posted";
            postModel.username = widget.displayName;
            postReference.push().set(postModel.toJson());
            postController.clear();

            setState(() {
              images = [];
              imageUrls = [];
              videos = [];
              percentage = 0.0;
              updatedText = "";
              mapVideos = null;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          }

          // if(mapImages.length > 0){
          //   print("Map Images => "+mapImages.length.toString());
          // }
          sequence++;
        }
      }



    } else if(images.length == 0 && videos.length > 0){
      print("Video Uploading only");
      // IF Video upload only
      for(var videoFile in videos){
        //isUploadingVideo = true;
        String documentID = DateTime.now().millisecondsSinceEpoch.toString();
        final videoUploadUrl =
        await FirebaseGoogleApi.uploadVideo('user-videos/$documentID', videoFile);
        mapVideos.putIfAbsent(documentID, () => videoUploadUrl);
        if(videos.length == mapVideos.length){
          print("Only video uploading");
          isUploadingVideo = false;
          PostModel postModel = new PostModel();
          postModel.userId = widget.uid;
          postModel.postTime = new DateTime.now().toString();
          postModel.postDescription = postController.value.text;
          postModel.like = null;
          postModel.comments = null;
          postModel.timestamp = DateTime.now().millisecondsSinceEpoch;
          postModel.imgUrl = "none";
          postModel.multipleImgUrl = null;
          postModel.videoUrl = mapVideos;
          postModel.status = "posted";
          postModel.username = widget.displayName;
          postReference.push().set(postModel.toJson());
          postController.clear();

          setState(() {
            images = [];
            imageUrls = [];
            videos = [];
            percentage = 0.0;
            updatedText = "";
          });
          FocusScope.of(context).requestFocus(FocusNode());
        }
      }

    } else {
      print("No video and image upload");
      isUploadingVideo = false;
      isUploadingImage = false;
      PostModel postModel = new PostModel();
      postModel.userId = widget.uid;
      postModel.postTime = new DateTime.now().toString();
      postModel.postDescription = postController.value.text;
      postModel.like = null;
      postModel.comments = null;
      postModel.timestamp = DateTime.now().millisecondsSinceEpoch;
      postModel.imgUrl = "none";
      postModel.multipleImgUrl = null;
      postModel.videoUrl = null;
      postModel.status = "posted";
      postModel.username = widget.displayName;
      postReference.push().set(postModel.toJson());
      postController.clear();

      setState(() {
        images = [];
        imageUrls = [];
        videos = [];
        percentage = 0.0;
        updatedText = "";
      });
      FocusScope.of(context).requestFocus(FocusNode());

    }


  }


  void likePost(String keyValue, DataSnapshot dataSnapshot) async {
    String pushKey = postReference.push().key;
    TransactionResult transactionResult = await postReference.child(keyValue).child("like").runTransaction((MutableData mutableData) async {
      return mutableData;
    });
    print(pushKey);
    if(transactionResult.dataSnapshot.value != null){
      print("Current user " + widget.uid);
      Map<dynamic, dynamic> map = transactionResult.dataSnapshot.value;
      //print(map.values.toString());
      //print(map.values.contains(_auth.currentUser.uid));
      //print(map.values.toString());
      //print(map.values.contains(_auth.currentUser.uid));

      if(map.values.contains(widget.uid)){
        map.removeWhere((key, value) => value == widget.uid);

      } else {
        map.putIfAbsent(pushKey, () => widget.uid);
      }

      PostModel postModel = new PostModel();
      postModel.userId = dataSnapshot.value["userId"];
      postModel.postTime = dataSnapshot.value["postTime"];
      postModel.postDescription = dataSnapshot.value["postDescription"];
      postModel.username = dataSnapshot.value["username"];
      postModel.status = dataSnapshot.value["status"];
      postModel.imgUrl = dataSnapshot.value["imgUrl"];
      postModel.timestamp = dataSnapshot.value["timestamp"];
      postModel.comments = dataSnapshot.value["comments"];
      postModel.multipleImgUrl = dataSnapshot.value["multipleImgUrl"];
      postModel.videoUrl = dataSnapshot.value["videoUrl"];
      postModel.like = map;

      Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
      childUpdate.putIfAbsent(keyValue, () => postModel.toJson());
      postReference.update(childUpdate);

      // print(map.values.toString());
    } else {
      Map<dynamic, dynamic> likeUsers = new HashMap<dynamic, dynamic>();
      likeUsers.putIfAbsent(pushKey, () => widget.uid);

      PostModel postModel = new PostModel();
      postModel.userId = dataSnapshot.value["userId"];
      postModel.postTime = dataSnapshot.value["postTime"];
      postModel.postDescription = dataSnapshot.value["postDescription"];
      //postModel.like;
      postModel.username = dataSnapshot.value["username"];
      postModel.comments = dataSnapshot.value["comments"];
      postModel.status = dataSnapshot.value["status"];
      postModel.imgUrl = dataSnapshot.value["imgUrl"];
      postModel.timestamp = dataSnapshot.value["timestamp"];
      postModel.multipleImgUrl = dataSnapshot.value["multipleImgUrl"];
      postModel.videoUrl = dataSnapshot.value["videoUrl"];
      postModel.like = likeUsers;

      Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
      childUpdate.putIfAbsent(keyValue, () => postModel.toJson());
      postReference.update(childUpdate);
      //print(postModel.toJson());
    }

    // print(transactionResult.dataSnapshot.value);
  }

  // void userComment(PostDetailsModel postData, TextEditingController postController) async{
  //   DatabaseReference commentReference = databaseReference.child(localToken.domain).child("post");
  //   String pushKey = commentReference.push().key;
  //   // print(pushKey);
  //   // print(postData.id);
  //
  //   TransactionResult transactionResultForPost = await commentReference.child(postData.id).runTransaction((MutableData mutableData) async {
  //     return mutableData;
  //   });
  //
  //   TransactionResult transactionResult = await commentReference.child(postData.id).child("comments").runTransaction((MutableData mutableData) async {
  //     return mutableData;
  //   });
  //
  //   if(transactionResult.dataSnapshot.value != null){
  //     CommentModel commentModel = new CommentModel(user: _auth.currentUser.displayName, comment: postController.text,
  //         time: new DateTime.now().toString(), userId: _auth.currentUser.uid, status: "posted", userAvatar: updatedImage, timestamp: DateTime.now().millisecondsSinceEpoch);
  //     Map<dynamic, dynamic> mapComment = transactionResult.dataSnapshot.value;
  //     mapComment.putIfAbsent(pushKey, () => commentModel.toJson());
  //
  //     PostModel postModel = new PostModel();
  //     postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
  //     postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
  //     postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
  //     postModel.username = transactionResultForPost.dataSnapshot.value["username"];
  //     postModel.status = transactionResultForPost.dataSnapshot.value["status"];
  //     postModel.imgUrl = transactionResultForPost.dataSnapshot.value["imgUrl"];
  //     postModel.timestamp = transactionResultForPost.dataSnapshot.value["timestamp"];
  //     postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
  //     postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];
  //     postModel.comments = mapComment;
  //
  //
  //     if(transactionResultForPost.dataSnapshot.value["like"] != null){
  //       postModel.like = transactionResultForPost.dataSnapshot.value["like"];
  //     } else {
  //       postModel.like = null;
  //     }
  //
  //     Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
  //     childUpdate.putIfAbsent(postData.id, () => postModel.toJson());
  //     commentReference.update(childUpdate);
  //   } else {
  //     CommentModel commentModel = new CommentModel(user: postData.author, comment: postController.text,
  //         time: new DateTime.now().toString(), userId: _auth.currentUser.uid, status: "posted", userAvatar: updatedImage, timestamp: DateTime.now().millisecondsSinceEpoch);
  //     Map<dynamic, dynamic> mapComment = new HashMap<dynamic, dynamic>();
  //     mapComment.putIfAbsent(pushKey, () => commentModel.toJson());
  //
  //     PostModel postModel = new PostModel();
  //     postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
  //     postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
  //     postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
  //     postModel.username = transactionResultForPost.dataSnapshot.value["username"];
  //     postModel.status = transactionResultForPost.dataSnapshot.value["status"];
  //     postModel.imgUrl = transactionResultForPost.dataSnapshot.value["imgUrl"];
  //     postModel.timestamp = transactionResultForPost.dataSnapshot.value["timestamp"];
  //     postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
  //     postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];
  //     postModel.comments = mapComment;
  //
  //
  //     if(transactionResultForPost.dataSnapshot.value["like"] != null){
  //       postModel.like = transactionResultForPost.dataSnapshot.value["like"];
  //     } else {
  //       postModel.like = null;
  //     }
  //
  //     Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
  //     childUpdate.putIfAbsent(postData.id, () => postModel.toJson());
  //     commentReference.update(childUpdate);
  //
  //   }
  //   postController.clear();
  //   //print(transactionResultForPost.dataSnapshot.value.toString());
  //
  // }

  editPost(DataSnapshot snapshot, String text, BuildContext context) async{
    DatabaseReference commentReference = databaseReference.child("post");
    //String pushKey = commentReference.push().key;

    TransactionResult transactionResultForPost = await commentReference.child(snapshot.key).runTransaction((MutableData mutableData) async {
      return mutableData;
    });



    if(transactionResultForPost.dataSnapshot.value != null){
      PostModel postModel = new PostModel();
      postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
      postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
      postModel.postDescription = text;
      postModel.username = transactionResultForPost.dataSnapshot.value["username"];
      postModel.status = "edited";
      postModel.timestamp = transactionResultForPost.dataSnapshot.value["timestamp"];
      postModel.imgUrl = transactionResultForPost.dataSnapshot.value["imgUrl"];
      postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
      postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];


      if(transactionResultForPost.dataSnapshot.value["like"] != null){
        postModel.like = transactionResultForPost.dataSnapshot.value["like"];
      } else {
        postModel.like = null;
      }

      if(transactionResultForPost.dataSnapshot.value["comment"] != null){
        postModel.comments = transactionResultForPost.dataSnapshot.value["comment"];
      } else {
        postModel.comments = null;
      }


      Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
      childUpdate.putIfAbsent(snapshot.key, () => postModel.toJson());
      commentReference.update(childUpdate);
      Navigator.pop(context);
    }
    //print("test " + index.toString());
  }

  deletePost(DataSnapshot snapshot, BuildContext context) async{
    DatabaseReference commentReference = databaseReference.child("post");
    //String pushKey = commentReference.push().key;

    TransactionResult transactionResultForPost = await commentReference.child(snapshot.key).runTransaction((MutableData mutableData) async {
      return mutableData;
    });



    if(transactionResultForPost.dataSnapshot.value != null){


      PostModel postModel = new PostModel();
      postModel.userId = transactionResultForPost.dataSnapshot.value["userId"];
      postModel.postTime = transactionResultForPost.dataSnapshot.value["postTime"];
      postModel.postDescription = transactionResultForPost.dataSnapshot.value["postDescription"];
      postModel.username = transactionResultForPost.dataSnapshot.value["username"];
      postModel.status = "deleted";
      postModel.timestamp = transactionResultForPost.dataSnapshot.value["timestamp"];
      postModel.imgUrl = transactionResultForPost.dataSnapshot.value["imgUrl"];
      postModel.multipleImgUrl = transactionResultForPost.dataSnapshot.value["multipleImgUrl"];
      postModel.videoUrl = transactionResultForPost.dataSnapshot.value["videoUrl"];


      if(transactionResultForPost.dataSnapshot.value["like"] != null){
        postModel.like = transactionResultForPost.dataSnapshot.value["like"];
      } else {
        postModel.like = null;
      }

      if(transactionResultForPost.dataSnapshot.value["comment"] != null){
        postModel.comments = transactionResultForPost.dataSnapshot.value["comment"];
      } else {
        postModel.comments = null;
      }


      Map<String, dynamic> childUpdate = new HashMap<String, dynamic>();
      childUpdate.putIfAbsent(snapshot.key, () => postModel.toJson());
      commentReference.update(childUpdate);
      Navigator.pop(context);
    }
    //print("test " + index.toString());
  }

  // Widget getTheLatestComment(DataSnapshot dataSnapshot, BuildContext context) {
  //   //String pushKey = postReference.push().key;
  //   List<CommentModel> addThreeComment = [];
  //   List<CommentModel> comments = [];
  //     Map<dynamic, dynamic> map = dataSnapshot.value["comments"];
  //     map.values.forEach((element) {
  //       if(element["status"] != "deleted"){
  //         CommentModel commentModel = new CommentModel(comment: element["comment"], time: element["time"],
  //             user: element["user"], userId:  element["userId"], status: element["status"], userAvatar: element["userAvatar"], timestamp: element["timestamp"]);
  //         comments.add(commentModel);
  //         //print(element["comment"].toString());
  //       }
  //
  //     });
  //
  //     //CommentModel lastComment = comments.last;
  //     //print(comments.length);
  //
  //     if(comments.length != 0){
  //       int counter = 1;
  //       for(var commentItem in comments.reversed.toList()){
  //         if(counter <= 3){
  //           addThreeComment.add(commentItem);
  //           counter++;
  //         }
  //       }
  //
  //         String result = "";
  //         String timeAgoText = "";
  //
  //         if(commentItem.status == "edited"){
  //           var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(commentItem.timestamp.toString()) * 1000);
  //           result = commentItem.comment + " (edited) ";
  //           timeAgoText = timeago.format(date , locale: 'en_short');
  //         } else{
  //           var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(commentItem.timestamp.toString()) * 1000);
  //           result = commentItem.comment;
  //           timeAgoText = timeago.format(date , locale: 'en_short');
  //         }
  //
  //
  //         int commentText = commentItem.user.length + result.length;
  //
  //         return Padding(
  //           padding: const EdgeInsets.only(left: 5.0, right: 5.0),
  //           child: Wrap(
  //               children: <Widget>[
  //                 Container(
  //                   //margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                   child: presence(commentItem.userId),
  //                 ),
  //
  //                 Container(
  //                   margin: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
  //                   child: Text(
  //                     commentItem.user,
  //                     style: TextStyle(
  //                         color: HexColor("#2C7BE3"),
  //                         fontSize: MediaQuery.of(context).textScaleFactor * 15,
  //                         fontWeight: FontWeight.normal),
  //                   ),
  //                 ),
  //                 commentText >= 50 ?
  //                 Container(
  //                   margin: const EdgeInsets.fromLTRB(18, 1, 0, 0),
  //                   child: ReadMoreText(
  //                     result,
  //                     trimLines: 3,
  //                     colorClickableText: HexColor("#C8C8C8"),
  //                     trimMode: TrimMode.Line,
  //                     trimCollapsedText: 'read more',
  //                     trimExpandedText: 'show less',
  //                     moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#C8C8C8")),
  //                   ),
  //                 ) : Container(
  //                   margin: const EdgeInsets.fromLTRB(5, 1, 0, 0),
  //                   child: ReadMoreText(
  //                     result,
  //                     trimLines: 3,
  //                     colorClickableText: HexColor("#C8C8C8"),
  //                     trimMode: TrimMode.Line,
  //                     trimCollapsedText: 'read more',
  //                     trimExpandedText: 'show less',
  //                     moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //
  //                 commentText >= 50 ?
  //                 Container(
  //                     margin: const EdgeInsets.fromLTRB(18, 1, 0, 0),
  //                     child: Text(
  //                       timeAgoText,
  //                       style: TextStyle(
  //                           color: HexColor("#C8C8C8"),
  //                           fontSize: MediaQuery.of(context).textScaleFactor * 11,
  //                           fontWeight: FontWeight.normal),
  //                     )
  //                 ) : Container(
  //                     margin: const EdgeInsets.fromLTRB(5, 4, 0, 0),
  //                     child: Text(
  //                       timeAgoText,
  //                       style: TextStyle(
  //                           color: HexColor("#C8C8C8"),
  //                           fontSize: MediaQuery.of(context).textScaleFactor * 11,
  //                           fontWeight: FontWeight.normal),
  //                     )
  //                 ),
  //               ]
  //           ),
  //         );
  //
  //
  //     }
  //
  //   return buildFirstThreeComment(addThreeComment);
  //
  // }

  List<Widget> getBuildComments(DataSnapshot dataSnapshot, BuildContext context){
    List<Widget> _postComments = [];
    // for (var i = 0; i < 5; i++) {
    //   _postComments.add(_commentBuilder());
    // }
    List<CommentModel> comments = [];
    Map<dynamic, dynamic> map = dataSnapshot.value["comments"];
    map.values.forEach((element) {
      if(element["status"] != "deleted"){
        CommentModel commentModel = new CommentModel(comment: element["comment"], time: element["time"],
            user: element["user"], userId:  element["userId"], status: element["status"], userAvatar: element["userAvatar"], timestamp: element["timestamp"],
            imgUrl: element["imgUrl"],
            videoUrl: element["videoUrl"],
            comments: element["comments"],
            like: element["like"]);
        comments.add(commentModel);
        //print(element["comment"].toString());
      }

    });
    comments.reversed.toList();

    if(comments.length != 0){
      int counter = 1;
      for(var commentItem in comments){
        if(counter <= 3){
          _postComments.add(commentContainer(commentItem, []));
        }
        counter++;
      }
    }

    return _postComments;
  }

  String buttonText(DataSnapshot dataSnapshot) {
    String result = "";
    if(dataSnapshot.value["like"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["like"];
      //print(map.values.contains(_auth.currentUser.uid));
      if(map.values.contains(widget.uid)){
        result = "Liked";
      } else {
        result = "Like";
      }
    } else {
      result = "Like";
    }

    return result;
  }

  String likeCount(DataSnapshot dataSnapshot){
    String textLike = "";
    if(dataSnapshot.value["like"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["like"];
      //print(map.values.contains(_auth.currentUser.uid));
      textLike = " ("+ map.values.length.toString() + ")";
    } else {

      textLike = "";

    }
    return textLike;
  }

  String userAvatarUrl(String userIdKey){
    String result = "";

    if(userAvatars.containsKey(userIdKey)){
      //userAvatars.
      result = userAvatars[userIdKey];
    }
    return result;
  }

  int likeReacts(DataSnapshot dataSnapshot){
    int textLike = 0;
    if(dataSnapshot.value["like"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["like"];
      //print(map.values.contains(_auth.currentUser.uid));
      textLike = map.values.length;
    } else {
      textLike = 0;
    }
    return textLike;
  }

  Color buttonColor(DataSnapshot dataSnapshot){
    Color pickColor;

    if(dataSnapshot.value["like"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["like"];
      //print(map.values.contains(_auth.currentUser.uid));
      if(map.values.contains(widget.uid)){
        pickColor = HexColor("#12A721");
      } else {
        pickColor = Colors.white;
      }
    } else {
      pickColor = Colors.white;
    }
    return pickColor;
  }

  Color buttonCommentColor(DataSnapshot dataSnapshot){
    Color pickColor = Colors.white;

    if(dataSnapshot.value["comments"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["comments"];
      //print(map.values.toString());
      //print(map.values.contains(_auth.currentUser.uid));
      //map.values.forEach((v) => print(v["userId"].toString() == _auth.currentUser.uid));
      // if(map.values.contains(_auth.currentUser.uid)){
      //   pickColor = HexColor("#12A721");
      // } else {
      //   pickColor = Colors.white;
      // }
      map.values.forEach((v) {
        //print(v["userId"].toString() == _auth.currentUser.uid);
        if(v["userId"].toString() == widget.uid){
          pickColor = HexColor("#2C7BE3");
        }
      }
      );
    } else {
      pickColor = Colors.white;
    }
    return pickColor;
  }

  Color buttonCommentTextColor(DataSnapshot dataSnapshot){
    Color pickColor = Colors.blue;

    if(dataSnapshot.value["comments"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["comments"];
      //print(map.values.toString());
      //print(map.values.contains(_auth.currentUser.uid));
      //map.values.forEach((v) => print(v["userId"].toString() == _auth.currentUser.uid));
      // if(map.values.contains(_auth.currentUser.uid)){
      //   pickColor = HexColor("#12A721");
      // } else {
      //   pickColor = Colors.white;
      // }
      map.values.forEach((v) {
        //print(v["userId"].toString() == _auth.currentUser.uid);
        if(v["userId"].toString() == widget.uid){
          pickColor = Colors.white;
        }
      }
      );
    } else {
      pickColor = Colors.blue;
    }
    return pickColor;
  }

  Color buttonTextColor(DataSnapshot dataSnapshot){
    Color pickColor;

    if(dataSnapshot.value["like"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["like"];
      //print(map.values.contains(_auth.currentUser.uid));
      if(map.values.contains(widget.uid)){
        pickColor = Colors.white;
      } else {
        pickColor = Colors.green;
      }
    } else {
      pickColor = Colors.green;
    }
    return pickColor;
  }

  List<CommentModel> userComments(DataSnapshot dataSnapshot){
    // String pushKey = postReference.push().key;
    List<CommentModel> comments = [];

    if(dataSnapshot.value["comments"] != null){
      Map<dynamic, dynamic> map = dataSnapshot.value["comments"];
      map.values.forEach((element) {

        if(element["status"] != "deleted"){
          CommentModel commentModel = new CommentModel(comment: element["comment"],
              time: element["time"], user: element["user"], userId: element["userId"], status: element["status"], userAvatar: element["userAvatar"], timestamp: element["timestamp"],
              imgUrl: element["imgUrl"],
              videoUrl: element["videoUrl"],
              comments: element["comments"],
              like: element["like"]
          );
          comments.add(commentModel);
        }
      });
    }
    return comments;
  }

  // String commentStatus(DataSnapshot dataSnapshot){
  //   String result = "";
  //   if(dataSnapshot.value != null){
  //     if(dataSnapshot.value["status"] == "edited"){
  //       var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(dataSnapshot.value["timestamp"].toString()) * 1000);
  //       result = dataSnapshot.value["comment"] + " (edited) " + timeago.format(date , locale: 'en_short');
  //     } else{
  //       result = dataSnapshot.value["comment"];
  //     }
  //
  //   }
  //   return result;
  // }

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


  Future<int> countLikes(String key) async {
    int total = 0;
    postReference.child(key).child("like").once().then((value) {
      Map<dynamic, dynamic> map = value.value;
      total = map.length;
    });
    return total;
  }
  // ADDED FEATURES

  Widget _getPost(DataSnapshot snapshot, BuildContext context, List<NetworkImage> imagePreview, List<String> videoPreview) {

    return Container(
      child: Column(
        children: <Widget>[
          _getSeparator(10),
          _postHeader(snapshot),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: _postBodyText(snapshot)),
              ],
            ),
          ),

          //VideoPlayerWidgetLatest("https://stream-chat-singapore-c1.imgix.net/1118860/attachments/084a098c-a336-47ba-972d-d30c3491ba88.file_example_MP4_480_1_5MG.mp4"),
          videoPreview.length > 0 ? VideoPlayerWidgetLatest(videoPreview[0].toString())
              : Container(),
          imagePreview.length > 0 ? Container(
            constraints: BoxConstraints(maxHeight: 350),
            child: Carousel(
                boxFit: BoxFit.cover,
                images: imagePreview,
                autoplay: false,
                indicatorBgPadding: 5.0,
                dotPosition: DotPosition.bottomCenter,
                animationCurve: Curves.fastOutSlowIn,
                animationDuration:
                Duration(milliseconds: 2000)),
          ) : Container(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _postLikeAndCommentsCustom(snapshot),
          ),


          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: snapshot.value["comments"] != null ? getBuildComments(snapshot, context) : [],
          //     // children: <Widget>[
          //     //   Expanded(child: snapshot.value["comments"] != null ? getTheLatestComment(snapshot, context) : Container()),
          //     // ],
          //   ),
          // ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: snapshot.value["comments"] != null ? getBuildComments(snapshot, context) : [],
          // ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 2.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: snapshot.value["comments"] != null ? getBuildComments(snapshot, context) : [],
          //   ),
          // ),
          Column(
            children: snapshot.value["comments"] != null ? getBuildComments(snapshot, context) : [],
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
                children: <Widget>[
                  _postCommentLayout(snapshot),
                ]
            ),
          ),

          //postLikesAndComments(),
          //Divider(height: 1),
          //postOptions()
        ],
      ),
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  Widget _postHeader(DataSnapshot snapshot) {
    //String newFormatDate = new DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(snapshot.value["postTime"]));
    String monthDate = new DateFormat('MMM ').format(DateTime.parse(snapshot.value["postTime"]));
    String dateYearTime = new DateFormat('dd, yyyy hh:mm a').format(DateTime.parse(snapshot.value["postTime"]));
    return Container(
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              //   userStatus(snapshot.value["userId"]).toString() == "yes" ? Image.asset('assets/image/online_presence2.png', width: 20, height: 20) : Image.asset('assets/image/offline_presence.png', width: 20, height: 20),
              Column(
                children: <Widget>[
                  Container(
                    child: presence(snapshot.value["userId"]),
                    padding: EdgeInsets.only(right: 5, bottom: 2),
                  ),
                  Container(
                    child: Text(
                      monthDate,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).textScaleFactor * 12,
                        color: HexColor("#C8C8C8"),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 2),
                  ),

                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              Column(
                children: <Widget>[
                  Text(
                    "${snapshot.value["username"]}",
                    style: TextStyle(
                        color: HexColor("#2C7BE3"),
                        fontSize: MediaQuery.of(context).textScaleFactor * 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        dateYearTime,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 12,
                          color: HexColor("#C8C8C8"),
                        ),
                      ),
                      //Icon(Icons.language, size: 15, color: Colors.grey)
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              //Container(),
            ],
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                  child: Icon(Icons.more_horiz, color: Colors.grey),
                  onTapDown: (TapDownDetails position){

                    if(widget.displayName == snapshot.value["username"]){
                      showMenu(
                        position: new RelativeRect.fromLTRB(position.globalPosition.dx, position.globalPosition.dy, 0, 0),
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
                                                    child: Text("Edit Post"),
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
                                                          hintText: snapshot.value["postDescription"]),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: RaisedButton(
                                                      child: Text("Save"),
                                                      onPressed: () {
                                                        editPost(snapshot, editController.text, context);
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
                                                    child: Text("Are you sure to delete this post?"),
                                                  ),
                                                  Row(children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                        child: Text("Yes"),
                                                        onPressed: () {
                                                          deletePost(snapshot, context);
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

                  }

              ),
              //Icon(Icons.more_horiz, color: Colors.grey)
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
    // Container(
    //   child: Text(
    //       "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)."),
    //   decoration: BoxDecoration(color: Colors.green),
    //   padding: EdgeInsets.only(top: 5, bottom: 5),
    //   //padding: EdgeInsets.fromLTRB(0, 5, 0, 5)
    // ),
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).dividerColor),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  Widget commentContainer(CommentModel commentParent, List<CommentModel> subComments){

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
          return Column(
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

                      ],
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
                    // Container(
                    //   padding: EdgeInsets.only(left: 10.0),
                    //   child: Expanded(
                    //     child: Text('${data.content}', style: Theme.of(context).textTheme.caption.copyWith(
                    //         fontWeight: FontWeight.w300,
                    //         color: Colors.black
                    //     ),),
                    //   ),
                    // ),
                    // SizedBox(height: 4,),
                    // Expanded(
                    //   child: Text('${data.content}', style: Theme.of(context).textTheme.caption.copyWith(
                    //       fontWeight: FontWeight.w300,
                    //       color: Colors.black
                    //   ),),
                    // ),
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
          return Column(
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
                        // commentText >= 50 ?
                        // Container(
                        //   margin: const EdgeInsets.fromLTRB(18, 1, 0, 0),
                        //   child: ReadMoreText(
                        //     result,
                        //     trimLines: 3,
                        //     colorClickableText: HexColor("#C8C8C8"),
                        //     trimMode: TrimMode.Line,
                        //     trimCollapsedText: 'read more',
                        //     trimExpandedText: 'show less',
                        //     moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#C8C8C8")),
                        //   ),
                        // ) : Container(
                        //   margin: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                        //   child: ReadMoreText(
                        //     result,
                        //     trimLines: 3,
                        //     colorClickableText: HexColor("#C8C8C8"),
                        //     trimMode: TrimMode.Line,
                        //     trimCollapsedText: 'read more',
                        //     trimExpandedText: 'show less',
                        //     moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        //
                        // commentText >= 50 ?
                        // Container(
                        //     margin: const EdgeInsets.fromLTRB(21, 1, 0, 0),
                        //     child: Text(
                        //       timeAgoText,
                        //       style: TextStyle(
                        //           color: HexColor("#C8C8C8"),
                        //           fontSize: MediaQuery.of(context).textScaleFactor * 11,
                        //           fontWeight: FontWeight.normal),
                        //     )
                        // ) : Container(
                        //     margin: const EdgeInsets.fromLTRB(5, 4, 0, 0),
                        //     child: Text(
                        //       timeAgoText,
                        //       style: TextStyle(
                        //           color: HexColor("#C8C8C8"),
                        //           fontSize: MediaQuery.of(context).textScaleFactor * 11,
                        //           fontWeight: FontWeight.normal),
                        //     )
                        // ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 1, 0, 0),
                      child: ReadMoreText(
                        result,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        trimLines: 3,
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
                              fontSize: MediaQuery.of(context).textScaleFactor * 11,
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
                      child: CustomChewieVideoPlayerWidget(VideoPlayerController.network(data.videoUrl), false),
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
          );
        },
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  Widget _postBody(DataSnapshot snapshot, List<NetworkImage> images) {

    if(images.length > 1){
      return Container(
        constraints: BoxConstraints(maxHeight: 350),
        decoration: BoxDecoration(
            color: Colors.yellow,
            image: DecorationImage(
                image: images[0],
                fit: BoxFit.fill)),
      );
    } else {
      return Container(
        constraints: BoxConstraints(maxHeight: 350),
        child: Carousel(
            boxFit: BoxFit.cover,
            images: images,
            autoplay: true,
            indicatorBgPadding: 5.0,
            dotPosition: DotPosition.bottomCenter,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration:
            Duration(milliseconds: 2000)),
      );
    }



  }

  Widget _postCommentLayout(DataSnapshot snapshot){
    return Expanded(
      child: TextField(
        onTap: (){
          PostDetailsModel postDetailModel = new PostDetailsModel(
              author: snapshot.value["username"],
              body: "Caption",
              comments: userComments(snapshot),
              id: snapshot.key,
              imageURL:  "assets/images/outerbox_bg.png",
              postTime: "${new DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(snapshot.value["postTime"]))}",
              reacts: likeReacts(snapshot),
              summary: snapshot.value["postDescription"],
              title: snapshot.value["username"]
          );
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CommentPage(uid: widget.uid, postData: postDetailModel, displayName: widget.displayName),
          ));
        },
        controller: commentController,
        minLines: 1,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintStyle: TextStyle(color: HexColor("#2C7BE3"), fontSize: MediaQuery.of(context)
                .textScaleFactor *
                14),
            border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
            contentPadding: EdgeInsets.all(10),
            hintText: ' Write a comment...'),
      ),
    );
  }

  Widget _postLikeAndCommentsCustom(DataSnapshot snapshot){
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: ButtonTheme(
              minWidth: 20.0,
              height: 35.0,
              child: RaisedButton(
                color: buttonCommentColor(snapshot),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.black12)),
                onPressed: () {

                  PostDetailsModel postDetailModel = new PostDetailsModel(
                      author: snapshot.value["username"],
                      body: "Caption",
                      comments: userComments(snapshot),
                      id: snapshot.key,
                      imageURL:  "assets/images/outerbox_bg.png",
                      postTime: "${new DateFormat('MMM dd, yyyy hh:mm a').format(DateTime.parse(snapshot.value["postTime"]))}",
                      reacts: likeReacts(snapshot),
                      summary: snapshot.value["postDescription"],
                      title: snapshot.value["username"]
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CommentPage(uid: widget.uid, postData: postDetailModel, displayName: widget.displayName),
                  ));
                },
                child: Text(
                  userComments(snapshot).length != 0 ? "Comment (" + userComments(snapshot).length.toString() + ")": "Comment",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: buttonCommentTextColor(snapshot),
                      fontSize: MediaQuery.of(context)
                          .textScaleFactor *
                          14),
                ),
              ),
            )

        ),
        SizedBox(width: 20),
        Expanded(
          child: ButtonTheme(
            minWidth: 50,
            height: 35.0,
            child: RaisedButton(
              color: buttonColor(snapshot),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.black12)),
              onPressed: () {
                likePost(snapshot.key, snapshot);

                //                                      if (postReference.child(snapshot.key).child("like").equalTo(_auth.currentUser.uid) != null) {
                //
                //                                        postReference.child(snapshot.key).child("like").push().set(_auth.currentUser.uid);
                //                                      }
              },
              child: Text(
                buttonText(snapshot) + likeCount(snapshot),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: buttonTextColor(snapshot),
                    fontSize: MediaQuery.of(context)
                        .textScaleFactor *
                        14),
              ),
            ),
          ),

        ),

      ],
    );
  }

  Widget _postVideo(DataSnapshot snapshot) {
    return Container(
      constraints: BoxConstraints(maxHeight: 350),
      child: VideoPlayerWidget("https://stream-chat-singapore-c1.imgix.net/1118860/attachments/7afb8095-af4d-45fe-9b7f-596952c878ed.People%20Waiting.mp4"),
      // decoration: BoxDecoration(
      //     color: Colors.yellow,
      //     image: DecorationImage(
      //         image: AssetImage('assets/image/tarsier.png'),
      //         fit: BoxFit.fill)),
    );
  }

  Widget _postBodyText(DataSnapshot snapshot) {
    return ReadMoreText(
      "${snapshot.value["postDescription"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      //"Test",
      trimLines: 20,
      colorClickableText: HexColor("#C8C8C8"),
      trimMode: TrimMode.Line,
      trimCollapsedText: 'read more',
      trimExpandedText: 'show less',
      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: HexColor("#C8C8C8")),
    );
  }

  Widget postLikesAndComments() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: RawMaterialButton(
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 14,
                      ),
                      shape: new CircleBorder(
                          side: BorderSide(
                              color: Colors.white, style: BorderStyle.solid)),
                      fillColor: Colors.blue,
                      onPressed: () {},
                      highlightElevation: 0,
                    ),
                    width: 30,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  Container(
                    child: RawMaterialButton(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 14,
                        ),
                        shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            )),
                        fillColor: Colors.red,
                        onPressed: () {}),
                    width: 30,
                    color: Colors.white,
                  ),
                  // Text(likes.toString(), style: TextStyle(color: Colors.grey))
                ],
              ),
              height: 30,
              decoration: BoxDecoration(color: Colors.white)),
          // Container(
          //     child: Row(
          //       children: <Widget>[
          //         Text(
          //           '13',
          //           style: TextStyle(color: Colors.grey),
          //         ),
          //         Text(
          //           'Comments',
          //           style: TextStyle(color: Colors.grey),
          //         ),
          //       ],
          //     ))
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      //  decoration: BoxDecoration(color: Colors.yellow),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    );
  }

  Widget _addPostOptions() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton.icon(
                  icon: Icon(Icons.videocam, color: Colors.red),
                  label: Text('Video'),
                  textColor: Colors.grey,
                  onPressed: () async {
                    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.video);

                    if(result != null) {
                      String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
                      File file = File(result.files.single.path);
                      if (!mounted) return;
                      setState(() {
                        videos.add(file);
                        updatedText = " ";
                      });

                      // final urlImage =
                      // await FirebaseGoogleApi.uploadVideo('user-videos/$documnetID', file);
                      // print('Uploaded => ' + urlImage.toString());
                    } else {
                      // User canceled the picker
                    }
                    //print('test');
                    // Navigator.push(
                    //     context,
                    //     new MaterialPageRoute(
                    //         builder: (context) => UserStory(
                    //             storyController: widget.storyController)));
                  }),
              flex: 1),
          Expanded(
              child: FlatButton.icon(
                  icon: Icon(Icons.photo, color: Colors.green),
                  label: Text('Photo'),
                  textColor: Colors.grey,
                  onPressed: loadAssets),
              flex: 1),
          // Expanded(
          //   child: FlatButton.icon(
          //       icon: Icon(Icons.location_on, color: Colors.pink),
          //       label: Text('Check In'),
          //       textColor: Colors.grey,
          //       onPressed: () {
          //         // Navigator.push(
          //         //     context,
          //         //     new MaterialPageRoute(
          //         //         builder: (context) => UserStory(
          //         //             storyController: widget.storyController)));
          //       }),
          //   flex: 1,
          // ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 8.0,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
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
              CircleAvatar(
                radius: 51.0,
                backgroundColor: Colors.black,
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              ),
              Positioned(
                left: 27.0,
                child: GestureDetector(
                  onTap: (){
                    print("Index => " + index.toString());
                    setState(() {
                      images.removeAt(index);
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
          ),
        );
        // return Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: ThreeDContainer(
        //     backgroundColor: Colors.white,
        //     backgroundDarkerColor: Colors.white,
        //     height: 50,
        //     width: 50,
        //     borderDarkerColor: MultiPickerApp.pauseButton,
        //     borderColor: MultiPickerApp.pauseButtonDarker,
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.all(Radius.circular(15)),
        //       child: AssetThumb(
        //         asset: asset,
        //         width: 300,
        //         height: 300,
        //       ),
        //     ),
        //   ),
        // );
      }),
    );
  }

  Widget buildFirstThreeComment(List<CommentModel> commentItem){
    return Row(
      children: List.generate(commentItem.length, (index) {
        String result = "";
        String timeAgoText = "";

        if(commentItem[index].status == "edited"){
          var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(commentItem[index].timestamp.toString()) * 1000);
          result = commentItem[index].comment + " (edited) ";
          timeAgoText = timeago.format(date , locale: 'en_short');
        } else{
          var date = DateTime.fromMicrosecondsSinceEpoch(int.parse(commentItem[index].timestamp.toString()) * 1000);
          result = commentItem[index].comment;
          timeAgoText = timeago.format(date , locale: 'en_short');
        }


        int commentText = commentItem[index].user.length + result.length;
        return Wrap(
            children: <Widget>[
              Container(
                //margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: presence(commentItem[index].userId),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                child: Text(
                  commentItem[index].user,
                  style: TextStyle(
                      color: HexColor("#2C7BE3"),
                      fontSize: MediaQuery.of(context).textScaleFactor * 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
              commentText >= 50 ?
              Container(
                margin: const EdgeInsets.fromLTRB(18, 1, 0, 0),
                child: ReadMoreText(
                  result,
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
                  result,
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
                  margin: const EdgeInsets.fromLTRB(18, 1, 0, 0),
                  child: Text(
                    timeAgoText,
                    style: TextStyle(
                        color: HexColor("#C8C8C8"),
                        fontSize: MediaQuery.of(context).textScaleFactor * 11,
                        fontWeight: FontWeight.normal),
                  )
              ) : Container(
                  margin: const EdgeInsets.fromLTRB(5, 4, 0, 0),
                  child: Text(
                    timeAgoText,
                    style: TextStyle(
                        color: HexColor("#C8C8C8"),
                        fontSize: MediaQuery.of(context).textScaleFactor * 11,
                        fontWeight: FontWeight.normal),
                  )
              ),
            ]
        );
      }),
    );
  }

  Widget buildVideoGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(videos.length, (index) {
        // Asset asset = images[index];
        // print(asset.getByteData(quality: 100));
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
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
                child: ChewieVideoPlayerWidget(videos[index]),
              ),
              Positioned(
                left: 80.0,
                child: GestureDetector(
                  onTap: (){
                    print("Index => " + index.toString());
                    setState(() {
                      videos.removeAt(index);
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
          ),
        );
        // return Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Container(width: 100, height: 100,
        //     child: ChewieVideoPlayerWidget(videos[index]),
        //   ),
        // child: ThreeDContainer(
        //   backgroundColor: Colors.white,
        //   backgroundDarkerColor: Colors.white,
        //   height: 400,
        //   width: 400,
        //   borderDarkerColor: MultiPickerApp.pauseButton,
        //   borderColor: MultiPickerApp.pauseButtonDarker,
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.all(Radius.circular(15)),
        //     child: ChewieVideoPlayerWidget(videos[index]),
        //   ),
        // ),
        //);
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#0B1043",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      // print((await resultList[0].getThumbByteData(122, 100)));
      // print((await resultList[0].getByteData()));
      // print((await resultList[0].metadata));


    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      updatedText = " ";
      //_error = error;
    });
  }

  Future<String> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final reference = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    await uploadTask.whenComplete(() {});
    //print(reference.getDownloadURL());
    return await reference.getDownloadURL();
  }

  void uploadImages() async{
    for ( var imageFile in images) {
      final urlImage = await postImage(imageFile);
      imageUrls.add(urlImage);
      // postImage(imageFile).then((downloadUrl) {
      //   imageUrls.add(downloadUrl.toString());
      //   // if(imageUrls.length==images.length){
      //   //   String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
      //   //   Firestore.instance.collection('images').document(documnetID).setData({
      //   //     'urls':imageUrls
      //   //   }).then((_){
      //   //     SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
      //   //     widget.globalKey.currentState.showSnackBar(snackbar);
      //   //     setState(() {
      //   //       images = [];
      //   //       imageUrls = [];
      //   //     });
      //   //   });
      //   // }
      // }).catchError((err) {
      //   print(err);
      // });
    }

  }

  showProgressDialog(BuildContext context) async {
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);

    if(isUploading == true){
      await pr.show();
    } else {

    }

  }

}
