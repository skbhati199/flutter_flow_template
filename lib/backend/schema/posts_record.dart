import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema_util.dart';
import 'serializers.dart';

part 'posts_record.g.dart';

abstract class PostsRecord implements Built<PostsRecord, PostsRecordBuilder> {
  static Serializer<PostsRecord> get serializer => _$postsRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'image_url')
  String get imageUrl;

  @nullable
  @BuiltValueField(wireName: 'num_likes')
  int get numLikes;

  @nullable
  DocumentReference get user;

  @nullable
  String get username;

  @nullable
  @BuiltValueField(wireName: 'user_profile_pic')
  String get userProfilePic;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(PostsRecordBuilder builder) => builder
    ..imageUrl = ''
    ..numLikes = 0
    ..username = ''
    ..userProfilePic = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('posts');

  static Stream<PostsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  PostsRecord._();
  factory PostsRecord([void Function(PostsRecordBuilder) updates]) =
      _$PostsRecord;
}

Map<String, dynamic> createPostsRecordData({
  String imageUrl,
  int numLikes,
  DocumentReference user,
  String username,
  String userProfilePic,
}) =>
    serializers.serializeWith(
        PostsRecord.serializer,
        PostsRecord((p) => p
          ..imageUrl = imageUrl
          ..numLikes = numLikes
          ..user = user
          ..username = username
          ..userProfilePic = userProfilePic));

PostsRecord get dummyPostsRecord {
  final builder = PostsRecordBuilder()
    ..imageUrl = dummyImagePath
    ..numLikes = dummyInteger
    ..username = dummyString
    ..userProfilePic = dummyImagePath;
  return builder.build();
}

List<PostsRecord> createDummyPostsRecord({int count}) =>
    List.generate(count, (_) => dummyPostsRecord);
