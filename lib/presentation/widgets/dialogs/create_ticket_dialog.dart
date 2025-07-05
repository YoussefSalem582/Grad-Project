import 'package:flutter/material.dart';
import '../../../core/core.dart';

class CreateTicketDialog extends StatefulWidget {
  final VoidCallback? onTicketCreated;

  const CreateTicketDialog({super.key, this.onTicketCreated});

  @override
  State<CreateTicketDialog> createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _issueTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  String? _selectedPriority;

  @override
  void dispose() {
    _customerNameController.dispose();
    _issueTitleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

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
        title: Row(
          children: [
            Icon(Icons.add_circle, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'New Support Ticket',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _issueTitleController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Issue Title',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter issue title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Reference URL (Optional)',
                    labelStyle: TextStyle(color: Colors.black54),
                    hintText: 'https://example.com',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    prefixIcon: Icon(Icons.link, color: AppColors.primary),
                  ),
                  keyboardType: TextInputType.url,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  items: ['Low', 'Medium', 'High'].map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(
                        priority,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select priority';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: _createTicket,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Create Ticket'),
          ),
        ],
      ),
    );
  }

  void _createTicket() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      widget.onTicketCreated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
