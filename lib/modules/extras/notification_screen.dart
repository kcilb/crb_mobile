import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: NotificationScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Credit Score Increased',
      description: 'Your score improved by 15 points to 740',
      time: 'Today, 10:30 AM',
      type: NotificationType.scoreUpdate,
      isRead: false,
    ),
    NotificationItem(
      title: 'New Loan Offer',
      description: 'Pre-approved personal loan up to \$25,000',
      time: 'Yesterday, 5:12 PM',
      type: NotificationType.loanOffer,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showNotificationOptions(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
          child: Column(
            children: [
              // Header with unread count
              Container(
                padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                child: Row(
                  children: [
                    Text(
                      '${notifications.where((n) => !n.isRead).length} Unread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _markAllAsRead(),
                      child: const Text(
                        'Mark all as read',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),

              // Notification list
              Expanded(
                child:
                    notifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: notifications.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return _buildNotificationItem(notification);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.title),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeNotification(notification),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: _buildNotificationIcon(notification.type),
          title: Text(
            notification.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notification.time,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing:
              !notification.isRead
                  ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  )
                  : null,
          onTap: () => _handleNotificationTap(notification),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    Color iconColor;
    switch (type) {
      case NotificationType.scoreUpdate:
        iconColor = Colors.green;
        break;
      case NotificationType.loanOffer:
        iconColor = Colors.blue;
        break;
      case NotificationType.report:
        iconColor = Colors.purple;
        break;
      case NotificationType.security:
        iconColor = Colors.orange;
        break;
      case NotificationType.payment:
        iconColor = Colors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(_getNotificationIconData(type), color: iconColor, size: 24),
    );
  }

  IconData _getNotificationIconData(NotificationType type) {
    switch (type) {
      case NotificationType.scoreUpdate:
        return Icons.trending_up;
      case NotificationType.loanOffer:
        return Icons.local_offer;
      case NotificationType.report:
        return Icons.insert_chart;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.payment:
        return Icons.payment;
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        notifications[notifications.indexOf(notification)] = notification
            .copyWith(isRead: true);
      });
    }
    // Handle navigation based on notification type
  }

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < notifications.length; i++) {
        if (!notifications[i].isRead) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
      }
    });
  }

  void _removeNotification(NotificationItem notification) {
    setState(() {
      notifications.remove(notification);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        content: Text('Dismissed ${notification.title}'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            setState(() {
              notifications.add(notification);
            });
          },
        ),
      ),
    );
  }

  void _showNotificationOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  'Notification Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.white),
                title: const Text(
                  'Clear All Notifications',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    notifications.clear();
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

enum NotificationType { scoreUpdate, loanOffer, report, security, payment }

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? title,
    String? description,
    String? time,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationItem(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
