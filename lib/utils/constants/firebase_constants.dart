import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final Future<FirebaseApp> firebaseInit_ = Firebase.initializeApp();
FirebaseAuth auth_ = FirebaseAuth.instance;
