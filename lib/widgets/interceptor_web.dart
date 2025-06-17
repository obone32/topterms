import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class Interceptor extends StatefulWidget {
  final Widget child;

  const Interceptor({super.key, required this.child});

  @override
  State<Interceptor> createState() => _InterceptorState();
}

class _InterceptorState extends State<Interceptor> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _disableBrowserContextMenu();
    }
  }

  void _disableBrowserContextMenu() {
    html.document.onContextMenu.listen((event) => event.preventDefault());
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton) {
          debugPrint("Right-click detected");
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onSecondaryTapDown: (details) {
          debugPrint("Custom context menu triggered at ${details.globalPosition}");
        },
        child: widget.child,
      ),
    );
  }
}
