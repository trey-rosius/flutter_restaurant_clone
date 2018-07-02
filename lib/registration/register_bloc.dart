import 'dart:async';

import 'package:foody/Api/api.dart';
import 'package:foody/registration/register.dart';

class RegisterBloc {
  final Api api;


  final StreamController<Register> _cartRegisterController = StreamController<
      Register>();

  Sink<Register> get regist => _cartRegisterController.sink;

  RegisterBloc(this.api) {
    _cartRegisterController.stream.listen((reg) {
      api.registerUser(reg.userType, reg.userName, reg.email,
          reg.userType).asStream();
    });
  }

  void dispose() {
    _cartRegisterController.close();
  }
}