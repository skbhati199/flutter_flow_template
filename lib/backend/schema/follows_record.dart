import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'schema_util.dart';
import 'serializers.dart';

part 'follows_record.g.dart';

abstract class FollowsRecord
    implements Built<FollowsRecord, FollowsRecordBuilder> {
  static Serializer<FollowsRecord> get serializer => _$followsRecordSerializer;

  @nullable
  DocumentReference get follower;

  @nullable
  DocumentReference get following;

  @nullable
  @BuiltValueField(wireName: 'follower_profile_pic')
  String get followerProfilePic;

  @nullable
  @BuiltValueField(wireName: 'following_profile_pic')
  String get followingProfilePic;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(FollowsRecordBuilder builder) => builder
    ..followerProfilePic = ''
    ..followingProfilePic = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('follows');

  static Stream<FollowsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  FollowsRecord._();
  factory FollowsRecord([void Function(FollowsRecordBuilder) updates]) =
      _$FollowsRecord;
}

Map<String, dynamic> createFollowsRecordData({
  DocumentReference follower,
  DocumentReference following,
  String followerProfilePic,
  String followingProfilePic,
}) =>
    serializers.serializeWith(
        FollowsRecord.serializer,
        FollowsRecord((f) => f
          ..follower = follower
          ..following = following
          ..followerProfilePic = followerProfilePic
          ..followingProfilePic = followingProfilePic));

FollowsRecord get dummyFollowsRecord {
  final builder = FollowsRecordBuilder()
    ..followerProfilePic = dummyImagePath
    ..followingProfilePic = dummyImagePath;
  return builder.build();
}

List<FollowsRecord> createDummyFollowsRecord({int count}) =>
    List.generate(count, (_) => dummyFollowsRecord);
