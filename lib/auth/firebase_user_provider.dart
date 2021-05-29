import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class PhotoshareappFirebaseUser {
  PhotoshareappFirebaseUser(this.user);
  final User user;
  bool get loggedIn => user != null;
}

PhotoshareappFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<PhotoshareappFirebaseUser> photoshareappFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<PhotoshareappFirebaseUser>(
            (user) => currentUser = PhotoshareappFirebaseUser(user));
