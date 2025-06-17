import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../widgets/custom_context_menu.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _items = [
    'Document 1.pdf',
    'Image_2024.jpg',
    'Presentation.pptx',
    'Spreadsheet.xlsx',
    'Video_File.mp4',
    'Archive.zip',
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Context Menu Demo'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'How to Use Context Menu',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleMedium?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInstructionRow(
                      Icons.touch_app,
                      'Mobile/Touch:',
                      'Long press on any item to open context menu',
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionRow(
                      Icons.mouse,
                      'Desktop:',
                      'Right-click on any item to open context menu',
                    ),
                    Text(
                      'Code by : Sunil Makwana. For : Top Terms Ltd.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Files (${_items.length} items)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final extension = item.split('.').last.toLowerCase();

                  return CustomContextMenu(
                    menuItems: [
                      ContextMenuItem(
                        icon: Icons.open_in_new,
                        title: 'Open',
                        onTap: () => _showSnackBar('Opening $item'),
                      ),
                      ContextMenuItem(
                        icon: Icons.edit,
                        title: 'Edit',
                        onTap: () => _showSnackBar('Editing $item'),
                      ),
                      ContextMenuItem(
                        icon: Icons.share,
                        title: 'Share',
                        onTap: () => _showSnackBar('Sharing $item'),
                      ),
                      ContextMenuItem(
                        icon: Icons.copy,
                        title: 'Copy',
                        onTap: () => _showSnackBar('Copied $item'),
                      ),
                      ContextMenuItem(
                        icon: Icons.drive_file_move,
                        title: 'Move',
                        onTap: () => _showSnackBar('Moving $item'),
                      ),
                      ContextMenuItem(
                        icon: Icons.info,
                        title: 'Properties',
                        onTap: () => _showSnackBar('Properties of $item'),
                      ),
                      ContextMenuItem(
                        icon: Icons.delete,
                        title: 'Delete',
                        isDestructive: true,
                        onTap: () => _showSnackBar('Deleted $item'),
                      ),
                    ],
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          _showSnackBar('Tapped on $item');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getFileColor(extension).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getFileIcon(extension),
                                color: _getFileColor(extension),
                                size: 24,
                              ),
                            ),
                            title: Text(
                              item,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              '${extension.toUpperCase()} file • ${_getFileSize()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: (kIsWeb || defaultTargetPlatform == TargetPlatform.windows ||
                                defaultTargetPlatform == TargetPlatform.macOS ||
                                defaultTargetPlatform == TargetPlatform.linux)
                                ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hoverColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: Theme.of(context).iconTheme.color,
                                size: 18,
                              ),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                children: [
                  TextSpan(
                    text: '$title ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFileSize() {
    final sizes = ['2.5 MB', '1.8 MB', '4.2 MB', '856 KB', '15.3 MB', '3.1 MB'];
    return sizes[DateTime.now().millisecond % sizes.length];
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'pptx':
      case 'ppt':
        return Icons.slideshow;
      case 'xlsx':
      case 'xls':
        return Icons.table_chart;
      case 'mp4':
      case 'avi':
        return Icons.video_file;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.description;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension) {
      case 'pdf':
        return const Color(0xFFE53E3E);
      case 'jpg':
      case 'jpeg':
      case 'png':
        return const Color(0xFF38A169);
      case 'pptx':
      case 'ppt':
        return const Color(0xFFD69E2E);
      case 'xlsx':
      case 'xls':
        return const Color(0xFF319795);
      case 'mp4':
      case 'avi':
        return const Color(0xFF805AD5);
      case 'zip':
      case 'rar':
        return const Color(0xFF9C4221);
      default:
        return const Color(0xFF2B6CB0);
    }
  }
}