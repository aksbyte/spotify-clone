import 'package:flutter/cupertino.dart';

void pushPage(BuildContext context, Widget child) =>
    Navigator.push(context, CupertinoPageRoute(builder: (context) => child));

void pushReplacementPage(BuildContext context, Widget child) =>
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => child));

void pushAndRemovePage(BuildContext context, Widget child) =>
    Navigator.pushAndRemoveUntil(context,
        CupertinoPageRoute(builder: (context) => child), (route) => false);

void popPage(BuildContext context) => Navigator.of(context).pop();

void pushAnimation(BuildContext context, Widget child) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 1), end: Offset.zero).chain(
          CurveTween(curve: Curves.easeIn),
        );
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}
