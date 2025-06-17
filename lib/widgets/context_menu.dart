import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class ContextMenuItem {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  const ContextMenuItem({
    this.icon,
    required this.label,
    this.onTap,
    this.enabled = true,
  });
}

class Interceptor extends StatefulWidget {
  final Widget child;

  const Interceptor({
    Key? key,
    required this.child,
  }) : super(key: key);

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
    // Disable right-click context menu on web
    html.document.addEventListener('contextmenu', (html.Event event) {
      event.preventDefault();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ContextMenu extends StatefulWidget {
  final Widget child;
  final List<ContextMenuItem>? customItems;
  final bool showThreeDotsMenu;
  final bool enableLongPress;
  final bool enableRightClick;
  final Widget? threeDotIcon;

  const ContextMenu({
    Key? key,
    required this.child,
    this.customItems,
    this.showThreeDotsMenu = false,
    this.enableLongPress = true,
    this.enableRightClick = true,
    this.threeDotIcon,
  }) : super(key: key);

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isMenuVisible = false;

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
  }

  void _showMenu(BuildContext context, Offset globalPosition) {
    if (_isMenuVisible) return;

    final RenderBox? childRenderBox =
    _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (childRenderBox == null) return;

    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(
        context, globalPosition, childPosition, childSize);

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isMenuVisible = true;
    });
  }

  void _showMenuFromThreeDots(BuildContext context) {
    final RenderBox? childRenderBox =
    _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (childRenderBox == null) return;

    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    final Offset menuPosition = Offset(
      childPosition.dx + childSize.width - 10,
      childPosition.dy + 10,
    );

    _showMenu(context, menuPosition);
  }

  OverlayEntry _createOverlayEntry(
      BuildContext context,
      Offset tapPosition,
      Offset childPosition,
      Size childSize,
      ) {
    return OverlayEntry(
      builder: (context) => _ContextMenuOverlay(
        tapPosition: tapPosition,
        childPosition: childPosition,
        childSize: childSize,
        items: widget.customItems ?? _getDefaultItems(),
        onDismiss: _hideMenu,
      ),
    );
  }

  void _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (_isMenuVisible) {
      setState(() {
        _isMenuVisible = false;
      });
    }
  }

  List<ContextMenuItem> _getDefaultItems() {
    return [
      ContextMenuItem(
        icon: Icons.add,
        label: 'Create',
        onTap: () {
          _hideMenu();
        },
      ),
      ContextMenuItem(
        icon: Icons.edit,
        label: 'Edit',
        onTap: () {
          _hideMenu();
        },
      ),
      ContextMenuItem(
        icon: Icons.delete,
        label: 'Remove',
        onTap: () {
          _hideMenu();
        },
      ),
    ];
  }

  Widget _buildChildWithThreeDots() {
    if (!widget.showThreeDotsMenu) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _showMenuFromThreeDots(context),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.threeDotIcon ??
                  const Icon(
                    Icons.more_vert,
                    size: 16,
                    color: Colors.grey,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Interceptor(
      child: GestureDetector(
        key: _childKey,
        onSecondaryTapDown: widget.enableRightClick
            ? (details) {
          _showMenu(context, details.globalPosition);
        }
            : null,
        onLongPressStart: widget.enableLongPress
            ? (details) {
          _showMenu(context, details.globalPosition);
        }
            : null,
        onTap: _hideMenu, // Hide menu on regular tap
        child: _buildChildWithThreeDots(),
      ),
    );
  }
}

class _ContextMenuOverlay extends StatefulWidget {
  final Offset tapPosition;
  final Offset childPosition;
  final Size childSize;
  final List<ContextMenuItem> items;
  final VoidCallback onDismiss;

  const _ContextMenuOverlay({
    required this.tapPosition,
    required this.childPosition,
    required this.childSize,
    required this.items,
    required this.onDismiss,
  });

  @override
  State<_ContextMenuOverlay> createState() => _ContextMenuOverlayState();
}

class _ContextMenuOverlayState extends State<_ContextMenuOverlay>
    with SingleTickerProviderStateMixin {
  static const double _menuWidth = 200.0;
  static const double _itemHeight = 48.0;
  static const double _padding = 8.0;

  late double _menuHeight;
  late Offset _menuPosition;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _menuHeight = (widget.items.length * _itemHeight) + (_padding * 2);
    _menuPosition = widget.tapPosition;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateMenuPosition();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateMenuPosition() {
    final Size screenSize = MediaQuery.of(context).size;
    double x = widget.tapPosition.dx;
    double y = widget.tapPosition.dy;

    if (x + _menuWidth > screenSize.width) {
      x = screenSize.width - _menuWidth - 10;
    }
    if (x < 10) x = 10;

    if (y + _menuHeight > screenSize.height) {
      y = screenSize.height - _menuHeight - 10;
    }
    if (y < 10) y = 10;

    final Rect childRect = Rect.fromLTWH(
      widget.childPosition.dx,
      widget.childPosition.dy,
      widget.childSize.width,
      widget.childSize.height,
    );

    final Rect menuRect = Rect.fromLTWH(x, y, _menuWidth, _menuHeight);

    if (childRect.overlaps(menuRect)) {
      double rightX = widget.childPosition.dx + widget.childSize.width + 10;
      if (rightX + _menuWidth <= screenSize.width) {
        x = rightX;
      } else {
        double leftX = widget.childPosition.dx - _menuWidth - 10;
        if (leftX >= 0) {
          x = leftX;
        } else {
          if (widget.childPosition.dy - _menuHeight - 10 >= 0) {
            y = widget.childPosition.dy - _menuHeight - 10;
          } else {
            y = widget.childPosition.dy + widget.childSize.height + 10;
          }
        }
      }
    }

    setState(() {
      _menuPosition = Offset(x, y);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onDismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Positioned(
              left: _menuPosition.dx,
              top: _menuPosition.dy,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                alignment: Alignment.topLeft,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: _menuWidth,
                      padding: const EdgeInsets.symmetric(vertical: _padding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.items.map((item) {
                          return _ContextMenuItemWidget(
                            item: item,
                            onTap: () {
                              item.onTap?.call();
                              widget.onDismiss();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ContextMenuItemWidget extends StatefulWidget {
  final ContextMenuItem item;
  final VoidCallback onTap;

  const _ContextMenuItemWidget({
    required this.item,
    required this.onTap,
  });

  @override
  State<_ContextMenuItemWidget> createState() => _ContextMenuItemWidgetState();
}

class _ContextMenuItemWidgetState extends State<_ContextMenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.item.enabled ? widget.onTap : null,
        child: Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: widget.item.enabled
                ? (_isHovered
                ? Theme.of(context).hoverColor
                : Colors.transparent)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 20.0,
                  color: widget.item.enabled
                      ? Theme.of(context).iconTheme.color
                      : Theme.of(context).disabledColor,
                ),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.item.enabled
                        ? null
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}