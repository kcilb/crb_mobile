import 'package:flutter/material.dart';

class SimpleActionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> sections;

  const SimpleActionScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.sections = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colorScheme.primary.withOpacity(0.10),
                  ),
                  child: Icon(icon, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (sections.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...sections,
          ],
        ],
      ),
    );
  }
}

class ComingSoon {
  static void show(
    BuildContext context, {
    required String title,
    String message = 'This feature is coming soon.',
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreditReportScreen extends StatelessWidget {
  const CreditReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleActionScreen(
      title: 'Credit report',
      subtitle: 'View and download your latest credit report.',
      icon: Icons.receipt_long_rounded,
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleActionScreen(
      title: 'Payments',
      subtitle: 'Pay dues and track payment status.',
      icon: Icons.payments_rounded,
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleActionScreen(
      title: 'Support',
      subtitle: 'Get help with disputes, account issues, and FAQs.',
      icon: Icons.support_agent_rounded,
    );
  }
}

class RequestLoanScreen extends StatelessWidget {
  const RequestLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleActionScreen(
      title: 'Request a loan',
      subtitle: 'Check offers and submit a loan request.',
      icon: Icons.add_card_rounded,
    );
  }
}

class InquiriesScreen extends StatelessWidget {
  const InquiriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleActionScreen(
      title: 'Inquiries',
      subtitle: 'Review your recent credit inquiries.',
      icon: Icons.search_rounded,
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleActionScreen(
      title: 'History',
      subtitle: 'See your activity and changes over time.',
      icon: Icons.history_rounded,
    );
  }
}

