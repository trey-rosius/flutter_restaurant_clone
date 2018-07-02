
import 'package:flutter/material.dart';

import 'package:foody/Api/api.dart';
import 'package:foody/registration/register.dart';
import 'package:foody/registration/register_bloc.dart';


class RegistrationProvider extends InheritedWidget {
  final RegisterBloc itemBloc;


  RegistrationProvider({
    Key key,
    RegisterBloc itemBloc,
    Widget child,
  })  : itemBloc= itemBloc?? RegisterBloc(Api()),
        super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static RegisterBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(RegistrationProvider) as RegistrationProvider)
          .itemBloc;
/*
  RegistrationProvider({Key key, RegisterBloc itemBloc, Widget child,Register register})
      : this.itemBloc = itemBloc ?? RegisterBloc(Api(),register),
        super(child: child, key: key);
        */

}