import 'package:flutter/material.dart';
import '../../../core/core.dart';

class TicketDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketDetailsDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        textTheme: Theme.of(
          context,
        ).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
      ),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ticket Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                'Ticket ID',
                ticket['id']?.toString() ?? 'Unknown',
              ),
              _buildDetailRow(
                'Customer',
                ticket['customerName']?.toString() ??
                    ticket['customer']?.toString() ??
                    'Unknown',
              ),
              _buildDetailRow(
                'Priority',
                ticket['priority']?.toString() ?? 'Unknown',
              ),
              _buildDetailRow(
                'Status',
                ticket['status']?.toString() ?? 'Unknown',
              ),
              _buildDetailRow(
                'Created',
                ticket['createdAt']?.toString() ??
                    ticket['created']?.toString() ??
                    'Unknown',
              ),
              _buildDetailRow(
                'Assignee',
                ticket['assignedTo']?.toString() ??
                    ticket['assignee']?.toString() ??
                    'Unassigned',
              ),
              if (ticket['url'] != null)
                _buildDetailRowWithLink(
                  context,
                  'Reference URL',
                  ticket['url'].toString(),
                ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                ticket['description']?.toString() ?? 'No description available',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () => _updateTicketStatus(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Update Status'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black))),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithLink(
    BuildContext context,
    String label,
    String url,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _handleUrlTap(context, url),
              child: Text(
                url,
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.open_in_new, size: 16, color: AppColors.primary),
        ],
      ),
    );
  }

  void _handleUrlTap(BuildContext context, String url) async {
    // Show confirmation dialog before opening URL
    final shouldOpen = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Open Link', style: TextStyle(color: Colors.black)),
          content: Text(
            'Do you want to open this link?\n\n$url',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Open'),
            ),
          ],
        );
      },
    );

    if (shouldOpen == true) {
      // Here you would use url_launcher package: await launchUrl(Uri.parse(url));
      // For now, show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening: $url'),
            backgroundColor: AppColors.primary,
            action: SnackBarAction(
              label: 'Copy',
              textColor: Colors.white,
              onPressed: () {
                // Here you would copy to clipboard
                // Clipboard.setData(ClipboardData(text: url));
              },
            ),
          ),
        );
      }
    }
  }

  void _updateTicketStatus(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket updated!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
