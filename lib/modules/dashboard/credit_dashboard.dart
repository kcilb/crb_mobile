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

          // Main Content
          SingleChildScrollView(
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
                const SizedBox(height: 14),
                _buildUserSummaryCard(context),
                const SizedBox(height: 12),
                _buildQuickActionsSection(context),
                const SizedBox(height: 12),
                _buildCreditScoreCard(context),
                const SizedBox(height: 12),
                _buildColorLoanCards(context),
                const SizedBox(height: 12),
                _buildLoanEligibilityCard(context),
                const SizedBox(height: 12),
                _buildRecentInquiriesSection(context),
              ],
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
    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    image: AssetImage('assets/images/default_photo.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/default_photo.png',
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 36,
                        color: Colors.grey,
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Member since $memberSince',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    // Additional professional info
                    Row(
                      children: [
                        _buildInfoChip(Icons.verified_rounded, 'Verified'),
                        const SizedBox(width: 8),
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

          // Quick Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Credit Score', creditScore.toStringAsFixed(0)),
              _buildStatItem('Available', '\Ugx$availableCredit'),
              _buildStatItem('Limit', '\Ugx$totalCreditLimit'),
            ],
          ),
        ],
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

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
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
          const SizedBox(height: 12),
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
          const SizedBox(height: 12),
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
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
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
        padding: const EdgeInsets.all(20.0),
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
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: scorePercentage,
                      strokeWidth: 12,
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
                        ).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        'out of ${maxCreditScore.toInt()}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildScoreRangeIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRangeIndicator(BuildContext context) {
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
        LinearProgressIndicator(
          value: creditScore / maxCreditScore,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
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
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        'ID $id • $date',
        style:
            Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
