import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;

final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('posts');
final storageRef = FirebaseStorage.instance.ref();
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');