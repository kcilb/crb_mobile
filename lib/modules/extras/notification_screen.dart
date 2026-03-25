import 'dart:math' as math;
import 'dart:ui' show PathOperation;

import 'package:crb_mobile/dialogs/dialog_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _headerShapesController;

  /// Notification shown in the same [Stack] as the list (no overlay route / extra screen).
  NotificationItem? _detailItem;

  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Payment method required',
      description:
          'No default payment method is on file. Add a payment method to avoid an interruption to your subscription.',
      time: 'Today · 9:41 AM',
      icon: Icons.credit_card_outlined,
      iconAccent: kPrimaryBlue,
    ),
    NotificationItem(
      title: 'Payment review required',
      description:
          'We could not process your latest payment. Please verify your billing details and try again.',
      time: 'Yesterday · 4:20 PM',
      icon: Icons.account_balance_wallet_outlined,
      iconAccent: kThemeBg,
    ),
    NotificationItem(
      title: 'Payment method confirmed',
      description:
          'Your payment method was added successfully. Charges will appear on your statement according to your plan.',
      time: 'Mon · 2:15 PM',
      icon: Icons.verified_outlined,
      iconAccent: kPrimaryBlue,
    ),
    NotificationItem(
      title: 'Credit score update',
      description:
          'Your credit score changed from 725 to 740 based on recently reported activity.',
      time: 'Today · 10:30 AM',
      icon: Icons.trending_up_rounded,
      iconAccent: kPrimaryBlue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _headerShapesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _headerShapesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset =
        MediaQuery.paddingOf(context).top + kToolbarHeight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: kThemeBg,
        appBar: AppBar(
          title: Builder(
            builder: (context) {
              final count = notifications.length;
              final countLabel = count > 99 ? '99+' : '$count';
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: kOnboardingOnCardTitle,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: kThemeBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.22),
                      ),
                    ),
                    child: Text(
                      countLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: kOnboardingOnCardTitle),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert_rounded, color: kOnboardingOnCardTitle),
              tooltip: 'More options',
              onPressed: () => _showNotificationOptions(context),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: kThemeBg),
                  AnimatedBuilder(
                    animation: _headerShapesController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: BottomAbstractShapesPainter(
                          backgroundColor: kThemeBg,
                          accentColor: kPrimaryBlue,
                          phase: _headerShapesController.value,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topInset),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
                    child: Row(
                      children: [
                        Text(
                          'RECENT',
                          style: TextStyle(
                            color: kOnboardingOnCardTitle.withOpacity(0.55),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Color.lerp(kPrimaryBlue, kThemeBg, 0.42)!,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                              side: BorderSide(
                                color: Color.lerp(
                                  kPrimaryBlue,
                                  kThemeBg,
                                  0.55,
                                )!,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Mark all as read',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: notifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(14, 2, 14, 20),
                            itemCount: notifications.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return _buildNotificationCard(
                                notifications[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            if (_detailItem != null)
              Positioned.fill(
                child: _NotificationDetailOverlay(
                  item: _detailItem!,
                  onClose: () => setState(() => _detailItem = null),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 44,
              color: kOnboardingOnCardTitle.withOpacity(0.4),
            ),
            const SizedBox(height: 14),
            Text(
              'No notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: kOnboardingOnCardTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Account updates and alerts will appear here when available.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: kOnboardingOnCardBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem n) {
    return Dismissible(
      key: Key('${n.title}_${n.time}'),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Color.lerp(kFieldFill, kPrimaryBlue, 0.18)!,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline_rounded, color: kThemeBg, size: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() => notifications.remove(n));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification dismissed'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => setState(() => notifications.add(n)),
            ),
          ),
        );
      },
      child: Material(
        color: Color.lerp(kOnboardingThemedCard1, kThemeBg, 0.22)!,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Color.lerp(kFieldBorder, kThemeBg, 0.18)!,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openNotificationDetail(n),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color.lerp(kFieldFill, kThemeBg, 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.lerp(kFieldBorder, kThemeBg, 0.1)!,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(n.icon, color: n.iconAccent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                color: kFieldTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            n.time,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: kFieldTextColor.withOpacity(0.48),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kFieldTextColor.withOpacity(0.68),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: _buildTrailingCta(n),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openNotificationDetail(NotificationItem item) {
    setState(() => _detailItem = item);
  }

  static final Color _notificationCtaFill =
      Color.lerp(kFieldFill, kPrimaryBlue, 0.28)!;

  Widget _buildTrailingCta(NotificationItem n) {
    return _PillButton(
      label: 'View',
      background: _notificationCtaFill,
      foreground: kPrimaryBlue,
      onPressed: () => _openNotificationDetail(n),
    );
  }

  void _showNotificationOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Color.lerp(kOnboardingThemedCard1, kThemeBg, 0.15)!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kFieldTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: kFieldTextColor),
                  title: Text(
                    'Notification settings',
                    style: TextStyle(
                      color: kFieldTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline_rounded, color: kThemeBg),
                  title: Text(
                    'Clear all notifications',
                    style: TextStyle(
                      color: kThemeBg,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => notifications.clear());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 2),
          Icon(Icons.chevron_right_rounded, size: 14, color: foreground),
        ],
      ),
    );
  }
}

class NotificationItem {
  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconAccent,
  });

  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconAccent;
}

/// Themed detail sheet: brand-tinted card, overlapping icon, primary dismiss.
class _NotificationDetailOverlay extends StatelessWidget {
  const _NotificationDetailOverlay({
    required this.item,
    required this.onClose,
  });

  static const double _topBadgeSize = 56;

  /// Scrim-visible gap between card notch and icon: hole = badge radius + this.
  static const double _iconHoleMargin = 6;

  final NotificationItem item;
  final VoidCallback onClose;

  Color get _cardSurface => Color.lerp(kFieldFill, Colors.white, 0.42)!;

  Color get _cardBorder => Color.lerp(kFieldBorder, kThemeBg, 0.12)!;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final maxW = math.min(340.0, mq.width - 40.0);
    final scrim = Color.alphaBlend(
      kThemeBg.withOpacity(0.35),
      Colors.black.withOpacity(0.5),
    );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
              child: ColoredBox(color: scrim),
            ),
          ),
          SafeArea(
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: SizedBox(
                    width: maxW,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: _topBadgeSize / 2,
                          ),
                          child: Container(
                            width: maxW,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: kThemeBg.withOpacity(0.18),
                                  blurRadius: 28,
                                  offset: const Offset(0, 14),
                                  spreadRadius: -6,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipPath(
                              clipper: _CardWithIconHoleClipper(
                                cornerRadius: 24,
                                holeRadius: _topBadgeSize / 2 + _iconHoleMargin,
                              ),
                              child: Container(
                                width: maxW,
                                decoration: BoxDecoration(
                                  color: _cardSurface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: _cardBorder,
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    36,
                                    16,
                                    20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'NOTIFICATION',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                          color: kPrimaryBlue.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        item.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: kFieldTextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          height: 1.25,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        item.description,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: kFieldTextColor.withOpacity(
                                            0.88,
                                          ),
                                          fontSize: 14,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Color.lerp(
                                            kFieldFill,
                                            kPrimaryBlue,
                                            0.06,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Color.lerp(
                                              kFieldBorder,
                                              kPrimaryBlue,
                                              0.22,
                                            )!,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.schedule_rounded,
                                                size: 18,
                                                color: kPrimaryBlue
                                                    .withOpacity(0.88),
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  item.time,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: kFieldTextColor
                                                        .withOpacity(0.82),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color: Color.lerp(
                                                kFieldBorder,
                                                kThemeBg,
                                                0.08,
                                              )!,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16,
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: FilledButton(
                                              onPressed: onClose,
                                              style: FilledButton.styleFrom(
                                                backgroundColor: kPrimaryBlue,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 14,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    14,
                                                  ),
                                                ),
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              child: const Text('Dismiss'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 4,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: onClose,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Icon(
                                          Icons.close_rounded,
                                          color: kFieldTextColor.withOpacity(
                                            0.42,
                                          ),
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            width: _topBadgeSize,
                            height: _topBadgeSize,
                            decoration: BoxDecoration(
                              color: kPrimaryBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryBlue.withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              item.icon,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded card path minus a circle at the top center (notch; scrim shows through).
class _CardWithIconHoleClipper extends CustomClipper<Path> {
  const _CardWithIconHoleClipper({
    required this.cornerRadius,
    required this.holeRadius,
  });

  final double cornerRadius;
  final double holeRadius;

  @override
  Path getClip(Size size) {
    final outer =
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, 0, size.width, size.height),
              Radius.circular(cornerRadius),
            ),
          );

    final hole =
        Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(size.width / 2, 0),
              radius: holeRadius,
            ),
          );

    return Path.combine(PathOperation.difference, outer, hole);
  }

  @override
  bool shouldReclip(covariant _CardWithIconHoleClipper oldClipper) =>
      oldClipper.cornerRadius != cornerRadius ||
      oldClipper.holeRadius != holeRadius;
}
