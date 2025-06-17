import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ContextMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  ContextMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });
}

class CustomContextMenu extends StatelessWidget {
  final Widget child;
  final List<ContextMenuItem> menuItems;

  const CustomContextMenu({
    Key? key,
    required this.child,
    required this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return GestureDetector(
        onSecondaryTapUp: (details) {
          _showContextMenu(context, details.globalPosition);
        },
        child: child,
      );
    } else {
      return GestureDetector(
        onLongPressStart: (details) {
          HapticFeedback.mediumImpact();
          _showContextMenu(context, details.globalPosition);
        },
        child: child,
      );
    }
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<void>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Rect.fromLTWH(0, 0, overlay.size.width, overlay.size.height),
      ),
      items: menuItems.map((item) {
        return PopupMenuItem<void>(
          child: ListTile(
            dense: true,
            leading: Icon(
              item.icon,
              color: item.isDestructive ? Colors.red : Theme.of(context).iconTheme.color,
              size: 20,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: item.isDestructive ? Colors.red : Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              item.onTap();
            },
          ),
        );
      }).toList(),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}