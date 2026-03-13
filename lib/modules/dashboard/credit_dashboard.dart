import 'package:crb_mobile/modules/extras/notification_screen.dart';
import 'package:crb_mobile/modules/extras/user_profile.dart';
import 'package:crb_mobile/modules/extras/common_action_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditDashboard extends StatefulWidget {
  const CreditDashboard({super.key});

  @override
  State<CreditDashboard> createState() => _CreditDashboardState();
}

class _CreditDashboardState extends State<CreditDashboard> {
  final double creditScore = 740.0;
  final double maxCreditScore = 1000.0;
  final String userName = "John Mwangi";
  final String memberSince = "Jan 2018";
  final double availableCredit = 500.0;
  final double totalCreditLimit = 1000.0;
  final int activeLoansCount = 10;
  final int closedLoansCount = 0;

  bool _summaryVisible = false;
  bool _showBalances = false;

  @override
  void initState() {
    super.initState();
    // Trigger entry animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _summaryVisible = true;
        });
      }
    });
  }

  int _selectedNavIndex = 0;

  bool isEligibleForLoan() {
    return creditScore >= 670 && (availableCredit / totalCreditLimit) >= 0.3;
  }

  List<String> getLoanSuggestions() {
    if (creditScore >= 800) {
      return [
        "Home Loan up to \Ugx500,000",
        "Premium Car Loan up to \Ugx100,000",
      ];
    } else if (creditScore >= 740) {
      return ["Car Loan up to \Ugx50,000", "Personal Loan up to \Ugx25,000"];
    } else if (creditScore >= 670) {
      return ["Personal Loan up to \Ugx10,000"];
    } else {
      return ["Micro Loan up to \Ugx1,000"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Curved Background Section
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.43,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Container(),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          // Contrast overlay for legibility
          Container(
            height: MediaQuery.of(context).size.height * 0.43,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),

          // Main content with sticky header
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  _buildHeaderStrip(context),
                  const SizedBox(height: 10),
                  _buildUserSummaryCard(context),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildQuickActionsSection(context),
                          const SizedBox(height: 12),
                          _buildCreditScoreCard(context),
                          const SizedBox(height: 12),
                          _buildColorLoanCards(context),
                          const SizedBox(height: 12),
                          _buildLoanEligibilityCard(context),
                          const SizedBox(height: 12),
                          _buildRecentInquiriesSection(context),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeaderStrip(BuildContext context) {
    final firstName = userName.split(' ').first;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $firstName',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Here’s a quick overview of your credit',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
          ),
          child: IconButton(
            tooltip: 'Search',
            onPressed: () {
              HapticFeedback.selectionClick();
            },
            icon: const Icon(Icons.search_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildUserSummaryCard(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      opacity: _summaryVisible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        offset: _summaryVisible ? Offset.zero : const Offset(0, 0.06),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFFFFF), Color(0xFFF4F7FF)],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.9, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/default_photo.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/default_photo.png',
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.person,
                                size: 32,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Member since $memberSince',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        // Additional professional info
                        Wrap(
                          spacing: 8,
                          runSpacing: -4,
                          children: [
                            _buildInfoChip(Icons.verified_rounded, 'Verified'),
                            _buildInfoChip(Icons.credit_score, 'Good credit'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // View Profile Button
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Divider with spacing
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: Colors.black12),
              ),

              // Quick Stats Row with balance protection
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _showBalances ? null : () => _promptBalanceCode(context),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Credit Score',
                          creditScore.toStringAsFixed(0),
                        ),
                        _buildStatItem(
                          'Available',
                          '\Ugx$availableCredit',
                          obscure: !_showBalances,
                        ),
                        _buildStatItem(
                          'Limit',
                          '\Ugx$totalCreditLimit',
                          obscure: !_showBalances,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (!_showBalances)
                      Text(
                        'Tap to enter code and view balances',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Chip(
      backgroundColor: Colors.grey[100],
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Quick actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const Spacer(),
            Text(
              'Most used',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.receipt_long_rounded,
                label: 'Credit report',
                tint: colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreditReportScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.payments_rounded,
                label: 'Make payment',
                tint: const Color(0xFF16A34A),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.support_agent_rounded,
                label: 'Support',
                tint: const Color(0xFF7C3AED),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SupportScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _QuickActionTile(
                icon: Icons.add_card_rounded,
                label: 'Request loan',
                tint: const Color(0xFF0284C7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestLoanScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.history_rounded,
                label: 'History',
                tint: const Color(0xFF0F172A),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionTile(
                icon: Icons.notifications_active_rounded,
                label: 'Alerts',
                tint: const Color(0xFFDC2626),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {bool obscure = false}) {
    return Column(
      children: [
        obscure
            ? Icon(
                Icons.visibility_off_outlined,
                size: 20,
                color: Colors.grey[500],
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Future<void> _promptBalanceCode(BuildContext context) async {
    final theme = Theme.of(context);
    String code = '';

    final success = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                return AlertDialog(
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withOpacity(0.08),
                        ),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('View balances'),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your 4‑digit code to reveal amounts.',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 56,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(4, (index) {
                                final digit =
                                    index < code.length ? code[index] : '';
                                return Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1.6,
                                      color: digit.isNotEmpty
                                          ? theme.colorScheme.primary
                                          : Colors.grey.shade500,
                                    ),
                                    color: digit.isNotEmpty
                                        ? theme.colorScheme.primary
                                            .withOpacity(0.06)
                                        : Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    digit,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                );
                              }),
                            ),
                            // Invisible text field capturing input
                            Opacity(
                              opacity: 0.0,
                              child: TextField(
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                onChanged: (value) {
                                  if (value.length <= 4) {
                                    setSheetState(() {
                                      code = value;
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        // Demo: accept 1234 as the correct code
                        if (code == '1234') {
                          Navigator.of(context).pop(true);
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;

    if (!mounted) return;

    if (success) {
      setState(() {
        _showBalances = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Incorrect code'),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildCreditScoreCard(BuildContext context) {
    final scorePercentage = creditScore / maxCreditScore;
    Color scoreColor;
    String scoreLabel;

    if (creditScore >= 800) {
      scoreColor = Colors.green;
      scoreLabel = 'Excellent';
    } else if (creditScore >= 740) {
      scoreColor = Colors.lightGreen;
      scoreLabel = 'Very Good';
    } else if (creditScore >= 670) {
      scoreColor = Colors.blue;
      scoreLabel = 'Good';
    } else if (creditScore >= 580) {
      scoreColor = Colors.orange;
      scoreLabel = 'Fair';
    } else {
      scoreColor = Colors.red;
      scoreLabel = 'Poor';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Score',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    scoreLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: scorePercentage),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, animatedValue, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: animatedValue,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            creditScore.toStringAsFixed(0),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 28,
                                ),
                          ),
                          Text(
                            'out of ${maxCreditScore.toInt()}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildScoreRangeIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRangeIndicator(BuildContext context) {
    final targetValue = creditScore / maxCreditScore;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRangeIndicator('300-579', 'Poor', Colors.red),
            _buildRangeIndicator('580-669', 'Fair', Colors.orange),
            _buildRangeIndicator('670-739', 'Good', Colors.blue),
            _buildRangeIndicator('740-799', 'Very Good', Colors.lightGreen),
            _buildRangeIndicator('800-850', 'Excellent', Colors.green),
          ],
        ),
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: targetValue),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, _) {
            return LinearProgressIndicator(
              value: animatedValue,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRangeIndicator(String range, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          range,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildColorLoanCards(BuildContext context) {
    return Row(
      children: [
        // Active Loans Card
        Expanded(
          child: _buildLoanStatusCards(
            context: context,
            icon: Icons.credit_card_rounded,
            title: 'Active Loans',
            count: activeLoansCount,
            description: 'Currently in repayment',
            primaryColor: const Color(0xFF4368E8), // Deep blue
            secondaryColor: const Color(0xFF5A8CFF), // Lighter blue
            iconBgColor: Colors.white.withOpacity(0.2),
          ),
        ),
        const SizedBox(width: 16),
        // Closed Loans Card
        Expanded(
          child: _buildLoanStatusCards(
            context: context,
            icon: Icons.verified_rounded,
            title: 'Closed Loans',
            count: closedLoansCount,
            description: 'Successfully completed',
            primaryColor: const Color(0xFF20A144), // Deep green
            secondaryColor: const Color(0xFF3BD16F), // Lighter green
            iconBgColor: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanStatusCards({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int count,
    required String description,
    required Color primaryColor,
    required Color secondaryColor,
    required Color iconBgColor,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => HapticFeedback.lightImpact(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, secondaryColor],
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon with background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Animated count
                    TweenAnimationBuilder(
                      tween: IntTween(begin: 0, end: count),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, child) {
                        return Text(
                          '$value',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 32,
                            height: 1.2,
                          ),
                        );
                      },
                    ),

                    // Description
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 0.3,
                      ),
                    ),

                    // Progress indicator (modern style)
                    const SizedBox(height: 24),
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            title == 'Active Loans'
                                ? (activeLoansCount /
                                        (activeLoansCount + closedLoansCount))
                                    .clamp(0.0, 1.0)
                                : (closedLoansCount /
                                        (activeLoansCount + closedLoansCount))
                                    .clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int count,
    required String description,
    required Color color,
    required Gradient gradient,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),

            // Count with animation
            TweenAnimationBuilder(
              tween: IntTween(begin: 0, end: count),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Text(
                  '$value',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 28,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                letterSpacing: 0.2,
              ),
            ),

            // Progress indicator (subtle)
            const SizedBox(height: 16),
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withOpacity(0.5),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    title == 'Active Loans'
                        ? (activeLoansCount /
                                (activeLoansCount + closedLoansCount))
                            .clamp(0.0, 1.0)
                        : (closedLoansCount /
                                (activeLoansCount + closedLoansCount))
                            .clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanEligibilityCard(BuildContext context) {
    final eligible = isEligibleForLoan();
    final suggestions = getLoanSuggestions();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: eligible ? Colors.green[100] : Colors.red[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    eligible ? Icons.check : Icons.close,
                    color: eligible ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  eligible ? 'Loan Eligible' : 'Loan Not Eligible',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: eligible ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              eligible
                  ? 'You qualify for these loan options based on your credit profile:'
                  : 'Improve your credit score to qualify for better loan options.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (eligible) ...[
              Text(
                'Recommended Offers',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...suggestions.map(
                (loan) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_right,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(loan),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecentInquiriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Credit Inquiries',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInquiryTile(
                  context,
                  id: '1248',
                  institution: 'Equifax',
                  date: 'Oct 15, 2023',
                  amount: '\Ugx1,000',
                ),
                const Divider(height: 12),
                _buildInquiryTile(
                  context,
                  id: '4568',
                  institution: 'TransUnion',
                  date: 'Sep 28, 2023',
                  amount: '\Ugx1,000',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInquiryTile(
    BuildContext context, {
    required String id,
    required String institution,
    required String date,
    required String amount,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: colorScheme.primary.withOpacity(0.10),
        ),
        child: Icon(Icons.search_rounded, color: colorScheme.primary),
      ),
      title: Text(
        institution,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        'ID $id • $date',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          amount,
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      onTap: () => HapticFeedback.selectionClick(),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: _selectedNavIndex,
      backgroundColor: Colors.white,
      indicatorColor: colorScheme.primary.withOpacity(0.14),
      onDestinationSelected: (index) {
        setState(() => _selectedNavIndex = index);
        HapticFeedback.selectionClick();

        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InquiriesScreen()),
          );
        }
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_rounded),
          selectedIcon: Icon(Icons.search),
          label: 'Inquiries',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_rounded),
          label: 'History',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tint;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: tint.withOpacity(0.08),
          border: Border.all(color: tint.withOpacity(0.18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tint.withOpacity(0.14),
              ),
              child: Icon(icon, color: tint, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
