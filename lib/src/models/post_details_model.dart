import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outerboxadmin/src/models/comment_model.dart';

class PostDetailsModel {
  final String id, title, summary, body, imageURL;
  final String postTime;
  final int reacts;
  final String author;
  final List<CommentModel> comments;

  const PostDetailsModel({
    @required this.id,
    @required this.title,
    @required this.summary,
    @required this.body,
    @required this.imageURL,
    @required this.author,
    @required this.postTime,
    @required this.reacts,
    @required this.comments,
  });

// String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(postTime);
}
