// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/user.dart' as model;

@lazySingleton
class UserStreamViewModel extends StreamViewModel<model.User> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? get userId => _firebaseAuth.currentUser?.uid;
  model.User? get user => data;

  @override
  Stream<model.User> get stream => userService.getUserStream(userId!);
}
