import 'package:flutter/material.dart';
import '../services/permission_service.dart';

class ConsentScreen extends StatelessWidget {
  final PermissionService _permissionService = PermissionService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Consent Required'),
      content: Text('Allow access to sensors for monitoring?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Deny')),
        TextButton(onPressed: () async {
          await _permissionService.requestPermissions();
          Navigator.pop(context);
        }, child: Text('Accept')),
      ],
    );
  }
}