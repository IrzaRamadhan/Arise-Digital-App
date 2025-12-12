import 'package:flutter/material.dart';
import '../../../../data/models/asset_lifecycle_model.dart';

class AssetHistoryTimelineItem extends StatelessWidget {
  final AssetHistory data;
  final bool isLast;

  const AssetHistoryTimelineItem({
    super.key,
    required this.data,
    this.isLast = false,
  });

  Color _getStatusColor() {
    final action = data.action.toLowerCase();
    if (action.contains('create') || action.contains('tambah')) {
      return Colors.green;
    } else if (action.contains('update') || action.contains('ubah')) {
      return Colors.blue;
    } else if (action.contains('delete') || action.contains('hapus')) {
      return Colors.red;
    } else if (action.contains('approve') || action.contains('setuju')) {
      return Colors.teal;
    } else if (action.contains('reject') || action.contains('tolak')) {
      return Colors.orange;
    }
    return Colors.grey;
  }

  IconData _getActionIcon() {
    final action = data.action.toLowerCase();
    if (action.contains('create') || action.contains('tambah')) {
      return Icons.add_circle;
    } else if (action.contains('update') || action.contains('ubah')) {
      return Icons.edit;
    } else if (action.contains('delete') || action.contains('hapus')) {
      return Icons.delete;
    } else if (action.contains('approve') || action.contains('setuju')) {
      return Icons.check_circle;
    } else if (action.contains('reject') || action.contains('tolak')) {
      return Icons.cancel;
    }
    return Icons.circle;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TIMELINE LINE & DOT
          Column(
            children: [
              // Dot dengan icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(_getActionIcon(), color: Colors.white, size: 20),
              ),

              // Vertical line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
            ],
          ),

          SizedBox(width: 16),

          // CONTENT CARD
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 24),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Action + Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.actionLabel(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          data.action,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // User info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data.user?.name ?? "Sistem",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Date info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        data.createdAt,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),

                  // Status change (if any)
                  if (data.oldStatus != null || data.newStatus != null) ...[
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          if (data.oldStatus != null)
                            _statusTag(data.oldStatus!, Colors.grey),
                          if (data.oldStatus != null &&
                              data.newStatus != null) ...[
                            SizedBox(height: 8),
                            Icon(
                              Icons.arrow_downward,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 8),
                          ],
                          if (data.newStatus != null)
                            _statusTag(data.newStatus!, statusColor),
                        ],
                      ),
                    ),
                  ],

                  // Description
                  SizedBox(height: 12),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),

                  // Metadata link
                  if (data.metadata != null) ...[
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        // TODO: Show metadata dialog
                        _showMetadataDialog(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.orange[700],
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Lihat Detail Metadata",
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _showMetadataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Detail Metadata"),
            content: SingleChildScrollView(
              child: Text(
                data.metadata.toString(),
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tutup"),
              ),
            ],
          ),
    );
  }
}
