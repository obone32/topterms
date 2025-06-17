import 'package:flutter/material.dart';

class Interceptor extends StatelessWidget {
  final Widget child;

  const Interceptor({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PlatformInterceptor(child: child);
  }
}

class _PlatformInterceptor extends StatefulWidget {
  final Widget child;

  const _PlatformInterceptor({required this.child});

  @override
  State<_PlatformInterceptor> createState() => _PlatformInterceptorState();
}

class _PlatformInterceptorState extends State<_PlatformInterceptor> {
  @override
  void initState() {
    super.initState();
    _setupContextMenuPrevention();
  }

  void _setupContextMenuPrevention() {
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}