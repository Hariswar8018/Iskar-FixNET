// splash_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/usermodel.dart';
import 'declare.dart' show AppSession;


abstract class SplashEvent {}

class CheckAuthStatus extends SplashEvent {}

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {}

class SplashUnauthenticated extends SplashState {}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SplashBloc(this._auth, this._firestore) : super(SplashInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<SplashState> emit) async {
    emit(SplashLoading());

    await Future.delayed(Duration(seconds: 3)); // ⏳ Delay splash screen display

    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(SplashUnauthenticated());
      } else {
        final doc = await _firestore.collection("Users").doc(user.uid).get();
        if (doc.exists) {
          AppSession.currentUser = UserModel.fromJson(doc.data()!);
          emit(SplashAuthenticated());
        } else {
          emit(SplashError("User data not found."));
        }
      }
    } catch (e) {
      emit(SplashError("Error: ${e.toString()}"));
    }
  }

}

