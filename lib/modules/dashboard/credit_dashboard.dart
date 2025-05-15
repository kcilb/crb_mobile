import 'package:crb_mobile/modules/extras/notification_screen.dart';
import 'package:crb_mobile/modules/extras/user_profile.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Credit Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
              Expanded(child: Container(color: Colors.white)),
            ],
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
              children: [
                const SizedBox(height: 15),
                _buildUserSummaryCard(context),
                const SizedBox(height: 15),
                _buildCreditScoreCard(context),
                const SizedBox(height: 20),
                _buildCreditUtilizationCard(context),
                const SizedBox(height: 20),
                _buildLoanEligibilityCard(context),
                const SizedBox(height: 20),
                _buildRecentInquiriesSection(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildUserSummaryCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              // Profile Avatar
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, size: 36, color: Colors.white),
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
                        _buildInfoChip(Icons.credit_score, 'Good Credit'),
                        const SizedBox(width: 8),
                        _buildInfoChip(Icons.verified_user, 'Verified'),
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

  Widget _buildCreditUtilizationCard(BuildContext context) {
    final utilizationPercentage = availableCredit / totalCreditLimit;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Credit Utilization',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\Ugx$availableCredit',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Available Credit',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\Ugx$totalCreditLimit',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Credit Limit',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                LinearProgressIndicator(
                  value: utilizationPercentage,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    utilizationPercentage > 0.3 ? Colors.orange : Colors.green,
                  ),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                Positioned(
                  left: '${utilizationPercentage * 100}%'.length * 5,
                  child: Text(
                    '${(utilizationPercentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Utilization',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                Text(
                  utilizationPercentage > 0.3 ? 'High' : 'Good',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        utilizationPercentage > 0.3
                            ? Colors.orange
                            : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
                _buildInquiryItem(
                  context,
                  id: '1248',
                  institution: 'Equifax',
                  date: 'Oct 15, 2023',
                  amount: '\Ugx1,000',
                ),
                const Divider(height: 24),
                _buildInquiryItem(
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

  Widget _buildInquiryItem(
    BuildContext context, {
    required String id,
    required String institution,
    required String date,
    required String amount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              institution,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'ID: $id • $date',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            amount,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          // Handle navigation
        },
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
