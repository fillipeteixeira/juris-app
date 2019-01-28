import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:juris_app/bloc/bloc_provider.dart';
import 'package:meta/meta.dart';

class UserBloc implements BlocBase {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  final StreamController<Map<String, dynamic>> _userController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get userData => _userController.stream;

  final StreamController<bool> _loadingController =
  StreamController<bool>.broadcast();

  Stream<bool> get isLoading => _loadingController.stream;



  @override
  void dispose() {
    _userController.close();
  }

  void updateUser(Map<String, dynamic> user) {
    _userController.sink.add(user);
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    _loadingController.sink.add(true);
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      _firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      _loadingController.sink.add(false);
    }).catchError((e) {
      onFail();
      _loadingController.sink.add(false);
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    _loadingController.sink.add(true);

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      _firebaseUser = user;

      await _loadCurrentUser();

      onSuccess();
      _loadingController.sink.add(false);
    }).catchError((e) {
      onFail();
      _loadingController.sink.add(false);
    });
  }

  void signOut() async {
    await _auth.signOut();

    _userController.sink.add(Map());
    _firebaseUser = null;
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return _firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    _userController.sink.add(userData);
    await Firestore.instance
        .collection("users")
        .document(_firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    Map<String, dynamic> user;
    //_userController.stream.length.then((value) => print(value));
    //_userController.stream.first.then((value) => user = value);
    if (_firebaseUser == null) _firebaseUser = await _auth.currentUser();
    if (_firebaseUser != null) {
      if (user == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(_firebaseUser.uid)
            .get();
        _userController.sink.add(docUser.data);
      }
    }
  }
}
