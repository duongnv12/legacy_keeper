import 'package:flutter/cupertino.dart';
import '../utils/permissions.dart';

class RoleBasedWidget extends StatelessWidget {
  final String requiredRole;
  final String currentUserRole;
  final Widget child;

  const RoleBasedWidget({
    Key? key,
    required this.requiredRole,
    required this.currentUserRole,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Permissions.hasPermission(requiredRole, currentUserRole)) {
      return child; // Render child if permission granted
    }
    return const SizedBox.shrink(); // Hide widget if no permission
  }
}
