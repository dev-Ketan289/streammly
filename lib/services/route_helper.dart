import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Route getCustomRoute({
  required Widget child,
  Widget? currentChild,
  bool fullscreenDialog = false,
  bool animate = true,
  PageTransitionType type = PageTransitionType.fade,
  Alignment? alignment = Alignment.center,
  Duration duration = const Duration(milliseconds: 300),
  Duration reverseDuration = const Duration(milliseconds: 250),
  bool replaceEffect = false,
}) {
  // Validation for pop and joined transitions
  if (type == PageTransitionType.bottomToTopPop ||
      type == PageTransitionType.topToBottomPop ||
      type == PageTransitionType.leftToRightPop ||
      type == PageTransitionType.rightToLeftPop ||
      type == PageTransitionType.bottomToTopJoined ||
      type == PageTransitionType.topToBottomJoined ||
      type == PageTransitionType.leftToRightJoined ||
      type == PageTransitionType.rightToLeftJoined) {
    assert(currentChild != null, """
                When using type "bottomToTopPop" you need argument: 'childCurrent'
                example:
                  child: MyPage(),
                  childCurrent: this
                """);
  }

  // Validation for scale, size, and rotate transitions
  if (type == PageTransitionType.scale ||
      type == PageTransitionType.size ||
      type == PageTransitionType.rotate) {
    assert(alignment != null, """
                When using type "size" you need argument: 'alignment'
                """);
  }

  // ENHANCED REPLACEMENT EFFECT: Both screens slide together
  if (replaceEffect && animate) {
    return _createTrueReplacementTransition(
      child: child,
      type: type,
      duration: duration,
      reverseDuration: reverseDuration,
    );
  }

  // Standard animated transitions using page_transition package
  if (animate) {
    return PageTransition(
      type: type,
      alignment:
          (type == PageTransitionType.scale ||
                  type == PageTransitionType.size ||
                  type == PageTransitionType.rotate)
              ? alignment
              : null,
      duration: duration,
      reverseDuration: reverseDuration,
      child: child,
      childCurrent: currentChild,
    );
  }

  // Non-animated transitions - platform specific
  if (Platform.isAndroid) {
    return MaterialPageRoute(
      fullscreenDialog: fullscreenDialog,
      builder: (BuildContext context) => child,
    );
  }

  return CupertinoPageRoute(
    fullscreenDialog: fullscreenDialog,
    builder: (BuildContext context) => child,
  );
}

// IMPROVED: True replacement transition with proper screen coordination
PageRouteBuilder _createTrueReplacementTransition({
  required Widget child,
  required PageTransitionType type,
  required Duration duration,
  required Duration reverseDuration,
}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    opaque: false, // CRITICAL: Allows seeing through to previous screen
    transitionsBuilder: (context, animation, secondaryAnimation, childWidget) {
      return _buildSynchronizedTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: childWidget,
        type: type,
      );
    },
  );
}

// ENHANCED: Synchronized transition with both screens moving smoothly
Widget _buildSynchronizedTransition({
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required PageTransitionType type,
}) {
  // Enhanced curves for more natural feel
  final primaryCurve = CurvedAnimation(
    parent: animation,
    curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
  );

  final secondaryCurve = CurvedAnimation(
    parent: secondaryAnimation,
    curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
  );

  switch (type) {
    case PageTransitionType.rightToLeft:
      return _createSlideTransition(
        primaryAnimation: primaryCurve,
        secondaryAnimation: secondaryCurve,
        child: child,
        primaryBegin: const Offset(1.0, 0.0),
        primaryEnd: Offset.zero,
        secondaryBegin: Offset.zero,
        secondaryEnd: const Offset(-1.0, 0.0),
      );

    case PageTransitionType.leftToRight:
      return _createSlideTransition(
        primaryAnimation: primaryCurve,
        secondaryAnimation: secondaryCurve,
        child: child,
        primaryBegin: const Offset(-1.0, 0.0),
        primaryEnd: Offset.zero,
        secondaryBegin: Offset.zero,
        secondaryEnd: const Offset(1.0, 0.0),
      );

    case PageTransitionType.bottomToTop:
      return _createSlideTransition(
        primaryAnimation: primaryCurve,
        secondaryAnimation: secondaryCurve,
        child: child,
        primaryBegin: const Offset(0.0, 1.0),
        primaryEnd: Offset.zero,
        secondaryBegin: Offset.zero,
        secondaryEnd: const Offset(0.0, -1.0),
      );

    case PageTransitionType.topToBottom:
      return _createSlideTransition(
        primaryAnimation: primaryCurve,
        secondaryAnimation: secondaryCurve,
        child: child,
        primaryBegin: const Offset(0.0, -1.0),
        primaryEnd: Offset.zero,
        secondaryBegin: Offset.zero,
        secondaryEnd: const Offset(0.0, 1.0),
      );

    case PageTransitionType.fade:
      return _createEnhancedFadeTransition(
        primaryAnimation: primaryCurve,
        secondaryAnimation: secondaryCurve,
        child: child,
      );

    default:
      // Default to rightToLeft
      return _createSlideTransition(
        primaryAnimation: primaryCurve,
        secondaryAnimation: secondaryCurve,
        child: child,
        primaryBegin: const Offset(1.0, 0.0),
        primaryEnd: Offset.zero,
        secondaryBegin: Offset.zero,
        secondaryEnd: const Offset(-1.0, 0.0),
      );
  }
}

// Helper: Create smooth slide transition with proper coordination
Widget _createSlideTransition({
  required Animation<double> primaryAnimation,
  required Animation<double> secondaryAnimation,
  required Widget child,
  required Offset primaryBegin,
  required Offset primaryEnd,
  required Offset secondaryBegin,
  required Offset secondaryEnd,
}) {
  return AnimatedBuilder(
    animation: Listenable.merge([primaryAnimation, secondaryAnimation]),
    builder: (context, _) {
      return Stack(
        children: [
          // Previous screen sliding out - this creates the "push" effect
          Transform.translate(
            offset: Offset(
              secondaryBegin.dx +
                  (secondaryEnd.dx - secondaryBegin.dx) *
                      secondaryAnimation.value,
              secondaryBegin.dy +
                  (secondaryEnd.dy - secondaryBegin.dy) *
                      secondaryAnimation.value,
            ),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: const SizedBox.expand(),
            ),
          ),
          // New screen sliding in
          Transform.translate(
            offset: Offset(
              primaryBegin.dx +
                  (primaryEnd.dx - primaryBegin.dx) * primaryAnimation.value,
              primaryBegin.dy +
                  (primaryEnd.dy - primaryBegin.dy) * primaryAnimation.value,
            ),
            child: child,
          ),
        ],
      );
    },
  );
}

// Helper: Enhanced fade transition with subtle movement
Widget _createEnhancedFadeTransition({
  required Animation<double> primaryAnimation,
  required Animation<double> secondaryAnimation,
  required Widget child,
}) {
  return AnimatedBuilder(
    animation: Listenable.merge([primaryAnimation, secondaryAnimation]),
    builder: (context, _) {
      return Stack(
        children: [
          // Previous screen fades and slides slightly
          Opacity(
            opacity: 1.0 - secondaryAnimation.value,
            child: Transform.translate(
              offset: Offset(-50.0 * secondaryAnimation.value, 0.0),
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // New screen fades in with slight movement
          Opacity(
            opacity: primaryAnimation.value,
            child: Transform.translate(
              offset: Offset(30.0 * (1.0 - primaryAnimation.value), 0.0),
              child: child,
            ),
          ),
        ],
      );
    },
  );
}
