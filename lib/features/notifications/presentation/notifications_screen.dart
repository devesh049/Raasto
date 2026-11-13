import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_controllers.dart';
import '../../../shared/widgets/state_views.dart';

/// SCREEN 49 — Notifications.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.navNotifications)),
      body: EmptyStateWidget(
        icon: Icons.notifications_none_rounded,
        title: s.noNotifications,
        message: s.noNotificationsDesc,
      ),
    );
  }
}
