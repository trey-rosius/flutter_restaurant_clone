import 'package:flutter/material.dart';

import 'package:foody/login/login_screen.dart';
import 'package:foody/login/Home.dart';
import 'package:foody/utils/style.dart';

class Routes {
  Routes() {
    runApp(

        new MaterialApp(
      title: "Foody",

      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
      theme:appTheme,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );

          case '/Home':
            return new MyCustomRoute(
              builder: (_) => new Home(),
              settings: settings,
            );

        }
      },

    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
