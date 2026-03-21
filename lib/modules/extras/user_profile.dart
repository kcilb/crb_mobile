import 'package:crb_mobile/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final Map<String, dynamic> memberProfile = {
    'name': 'John Mwangi',
    'email': 'john.mwangi@example.com',
    'phone': '+254712345678',
    'membershipId': 'MEM-2023-00145',
    'membershipType': 'Premium',
    'joinDate': 'Jan 2018',
    'address': '123 Main St',
    'profilePhoto': 'assets/images/default_photo.png',
  };

  late final AnimationController _abstractController;
  late final TabController _profileTabController;

  @override
  void initState() {
    super.initState();
    _abstractController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _profileTabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_profileTabController.indexIsChanging) return;
        setState(() {});
      });
  }

  @override
  void dispose() {
    _profileTabController.dispose();
    _abstractController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kFieldFill,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bottomInset),
              sliver: SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        elevation: 0,
                        color: Colors.white,
                        shadowColor: Colors.black.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildProfileTabBar(),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              child:
                                  _profileTabController.index == 0
                                      ? Padding(
                                        key: const ValueKey('tab-details'),
                                        padding: const EdgeInsets.fromLTRB(
                                          4,
                                          0,
                                          4,
                                          16,
                                        ),
                                        child: _buildDetailsCard(),
                                      )
                                      : Padding(
                                        key: const ValueKey('tab-account'),
                                        padding: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        child: _buildAccountTabContent(),
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final screenH = MediaQuery.sizeOf(context).height;
    final headerHeight = (screenH * 0.36).clamp(320.0, 420.0) + topInset;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kThemeBg,
                  Color.lerp(kThemeBg, kPrimaryBlue, 0.18)!,
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 140,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _abstractController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BottomAbstractShapesPainter(
                      backgroundColor: kThemeBg,
                      accentColor: kPrimaryBlue,
                      phase: _abstractController.value,
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _buildHeaderIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        _buildHeaderIconButton(
                          icon: Icons.edit_outlined,
                          size: 22,
                          onPressed: _navigateToEditProfile,
                          tooltip: 'Edit profile',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildAvatar(),
                    const SizedBox(height: 12),
                    Text(
                      memberProfile['name'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      memberProfile['email'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildChip(
                          icon: Icons.verified_outlined,
                          label: '${memberProfile['membershipType']} member',
                        ),
                        _buildChip(
                          icon: Icons.calendar_today_outlined,
                          label: 'Since ${memberProfile['joinDate']}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Frosted circular control on the gradient header.
  Widget _buildHeaderIconButton({
    required IconData icon,
    required double size,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.35),
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white.withOpacity(0.22),
      child: IconButton(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(10),
          minimumSize: const Size(44, 44),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: size),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.85), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: kThemeBg.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 42,
        backgroundColor: Colors.white.withOpacity(0.2),
        backgroundImage: AssetImage(memberProfile['profilePhoto'] as String),
      ),
    );
  }

  static const List<({String title, String description})> _tabMeta = [
    (
      title: 'Details',
      description:
          'Contact, membership ID, and address — everything we have on file for you.',
    ),
    (
      title: 'Account',
      description:
          'Payments, activity, settings, help, and sign out — manage how you use the app.',
    ),
  ];

  Widget _buildProfileTabBar() {
    final tabIndex = _profileTabController.index.clamp(0, _tabMeta.length - 1);
    final desc = _tabMeta[tabIndex].description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                kThemeBg,
                Color.lerp(kThemeBg, kPrimaryBlue, 0.24)!,
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: kThemeBg.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: TabBar(
              controller: _profileTabController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              onTap: (_) {
                HapticFeedback.selectionClick();
                setState(() {});
              },
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.58),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: 0.2,
                color: Colors.white,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white.withOpacity(0.58),
              ),
              overlayColor: WidgetStateProperty.resolveWith(
                (states) => Colors.white.withOpacity(0.08),
              ),
              tabs: [
                Tab(text: _tabMeta[0].title),
                Tab(text: _tabMeta[1].title),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: Align(
              key: ValueKey<int>(tabIndex),
              alignment: Alignment.centerLeft,
              child: Text(
                desc,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.05,
                  color: kFieldTextColor.withOpacity(0.72),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: _buildSectionLabel('Account'),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildMenuCard(
            children: [
              _tile(
                icon: Icons.payment_rounded,
                label: 'Payment Methods',
                onTap: _navigateToPaymentMethods,
              ),
              _divider(),
              _tile(
                icon: Icons.history_rounded,
                label: 'Activity History',
                onTap: _navigateToActivityHistory,
              ),
              _divider(),
              _tile(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: _navigateToSettings,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildSectionLabel('Support'),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildMenuCard(
            children: [
              _tile(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                onTap: _navigateToHelp,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildLogoutButton(),
        ),
      ],
    );
  }

  Widget _buildChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white.withOpacity(0.95)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _elevatedIconBadge(
                  icon: Icons.badge_outlined,
                  color: kPrimaryBlue,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Contact & membership',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kFieldTextColor.withOpacity(0.95),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(
              Icons.email_outlined,
              'Email',
              memberProfile['email'] as String,
            ),
            _detailRow(
              Icons.phone_outlined,
              'Phone',
              memberProfile['phone'] as String,
            ),
            _detailRow(
              Icons.credit_card_outlined,
              'Membership ID',
              memberProfile['membershipId'] as String,
            ),
            _detailRow(
              Icons.location_on_outlined,
              'Address',
              memberProfile['address'] as String,
            ),
          ],
        ),
      ),
    );
  }

  /// Raised icon tile used for details rows and list tiles.
  Widget _elevatedIconBadge({
    required IconData icon,
    required Color color,
    double size = 20,
    double elevation = 3,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    double borderRadius = 10,
  }) {
    return Material(
      elevation: elevation,
      shadowColor: color.withOpacity(0.35),
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      color: color.withOpacity(0.12),
      child: Padding(
        padding: padding,
        child: Icon(icon, size: size, color: color),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _elevatedIconBadge(
            icon: icon,
            color: kPrimaryBlue,
            size: 18,
            elevation: 3,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: kFieldTextColor.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: kFieldTextColor,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: kFieldTextColor.withOpacity(0.62),
        ),
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Material(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.06),
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: kFieldBorder.withOpacity(0.7),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final accent = danger ? const Color(0xFFDC2626) : kPrimaryBlue;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 44,
      leading: _elevatedIconBadge(
        icon: icon,
        color: accent,
        size: 22,
        elevation: danger ? 2 : 4,
        padding: const EdgeInsets.all(10),
        borderRadius: 12,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: danger ? accent : kFieldTextColor,
        ),
      ),
      trailing: Material(
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.06),
        surfaceTintColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        color: kFieldFill,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 22,
            color: kFieldTextColor.withOpacity(0.45),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: _confirmLogout,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFDC2626),
        side: BorderSide(color: const Color(0xFFDC2626).withOpacity(0.45)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      icon: const Icon(Icons.logout_rounded, size: 22),
      label: const Text(
        'Log out',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
                backgroundColor: kThemeBg,
                foregroundColor: Colors.white,
              ),
              body: const Center(child: Text('Edit Profile Screen')),
            ),
      ),
    );
  }

  void _navigateToPaymentMethods() {}

  void _navigateToActivityHistory() {}

  void _navigateToSettings() {}

  void _navigateToHelp() {}

  Future<void> _confirmLogout() async {
    final navigator = Navigator.of(context);
    final confirmed = await LogoutDialog.show(context);
    if (!mounted) return;
    if (confirmed == true) {
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}
