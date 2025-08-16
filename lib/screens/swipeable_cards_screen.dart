import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwipeableCardsScreen extends StatefulWidget {
  @override
  _SwipeableCardsScreenState createState() => _SwipeableCardsScreenState();
}

class _SwipeableCardsScreenState extends State<SwipeableCardsScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController(viewportFraction: 0.85);
  int currentIndex = 0;
  late AnimationController _balanceController;
  late AnimationController _shimmerController;
  late Animation<double> _balanceAnimation;
  late Animation<double> _shimmerAnimation;

  final List<Map<String, dynamic>> cards = [
    {
      'type': 'PLATINUM',
      'number': '1234 5678 9012 3456',
      'holder': 'CARDHOLDER NAME',
      'expiry': '12/28',
      'balance': '\$25,847.50',
      'colors': [Color(0xFF667eea), Color(0xFF764ba2)],
      'accentColor': Color(0xFFffffff),
    },
    {
      'type': 'GOLD',
      'number': '2345 6789 0123 4567',
      'holder': 'CARDHOLDER NAME',
      'expiry': '11/27',
      'balance': '\$18,234.75',
      'colors': [Color(0xFFf093fb), Color(0xFFf5576c)],
      'accentColor': Color(0xFFffffff),
    },
    {
      'type': 'EMERALD',
      'number': '3456 7890 1234 5678',
      'holder': 'CARDHOLDER NAME',
      'expiry': '10/26',
      'balance': '\$32,156.90',
      'colors': [Color(0xFF4facfe), Color(0xFF00f2fe)],
      'accentColor': Color(0xFFffffff),
    },
    {
      'type': 'SAPPHIRE',
      'number': '4567 8901 2345 6789',
      'holder': 'CARDHOLDER NAME',
      'expiry': '09/25',
      'balance': '\$41,892.25',
      'colors': [Color(0xFF43e97b), Color(0xFF38f9d7)],
      'accentColor': Color(0xFF2d3748),
    },
    {
      'type': 'TITANIUM',
      'number': '5678 9012 3456 7890',
      'holder': 'CARDHOLDER NAME',
      'expiry': '08/24',
      'balance': '\$67,543.80',
      'colors': [Color(0xFFfa709a), Color(0xFFfee140)],
      'accentColor': Color(0xFF2d3748),
    },
    {
      'type': 'DIAMOND',
      'number': '6789 0123 4567 8901',
      'holder': 'CARDHOLDER NAME',
      'expiry': '07/23',
      'balance': '\$89,765.45',
      'colors': [Color(0xFFa8edea), Color(0xFFfed6e3)],
      'accentColor': Color(0xFF2d3748),
    },
    {
      'type': 'BLACK',
      'number': '7890 1234 5678 9012',
      'holder': 'CARDHOLDER NAME',
      'expiry': '06/22',
      'balance': '\$156,234.70',
      'colors': [Color(0xFF2c3e50), Color(0xFF4a6741)],
      'accentColor': Color(0xFFffffff),
    },
  ];

  @override
  void initState() {
    super.initState();
    _balanceController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _balanceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _balanceController, curve: Curves.elasticOut),
    );
    _shimmerAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
    _balanceController.forward();
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _balanceController.dispose();
    _shimmerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0e27),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Cards',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Balance Display
          AnimatedBuilder(
            animation: _balanceAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_balanceAnimation.value * 0.2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        cards[currentIndex]['balance'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 40),
          // Cards - Increased height and centered
          Expanded(
            flex: 3, // Give more space to cards
            child: Center(
              child: Container(
                height: 280, // Increased height for larger cards
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 0;
                        if (_pageController.position.haveDimensions) {
                          value = index - (_pageController.page ?? 0);
                          value = (value * 0.038).clamp(-1, 1);
                        }
                        return Transform.rotate(
                          angle: value,
                          child: Transform.scale(
                            scale: 1 - (value.abs() * 0.1),
                            child: _buildCard(cards[index], index),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          // Card Indicators
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cards.length,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: currentIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? cards[currentIndex]['colors'][0]
                        : Colors.white30,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Quick Actions
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(Icons.send, 'Send', Color(0xFF667eea)),
                _buildQuickAction(Icons.account_balance_wallet, 'Pay', Color(0xFFf093fb)),
                _buildQuickAction(Icons.add, 'Top Up', Color(0xFF4facfe)),
                _buildQuickAction(Icons.history, 'History', Color(0xFF43e97b)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> card, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Center( // Center the card
        child: Stack(
          children: [
            // Main Card - Increased size
            Container(
              width: 350, // Increased from 300
              height: 220, // Increased from 190
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: card['colors'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: card['colors'][0].withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Shimmer Effect
                  AnimatedBuilder(
                    animation: _shimmerAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: _shimmerAnimation.value * 450, // Adjusted for larger card
                        top: 0,
                        child: Container(
                          width: 100,
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Card Content
                  Padding(
                    padding: EdgeInsets.all(24), // Increased padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              card['type'],
                              style: TextStyle(
                                color: card['accentColor'],
                                fontSize: 18, // Increased font size
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Icon(
                              Icons.contactless,
                              color: card['accentColor'],
                              size: 28, // Increased icon size
                            ),
                          ],
                        ),
                        Spacer(),
                        // Chip
                        Container(
                          width: 45, // Increased chip size
                          height: 35,
                          decoration: BoxDecoration(
                            color: card['accentColor'].withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        SizedBox(height: 18),
                        // Card Number
                        Text(
                          card['number'],
                          style: TextStyle(
                            color: card['accentColor'],
                            fontSize: 20, // Increased font size
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CARD HOLDER',
                                  style: TextStyle(
                                    color: card['accentColor'].withOpacity(0.7),
                                    fontSize: 11, // Slightly increased
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  card['holder'],
                                  style: TextStyle(
                                    color: card['accentColor'],
                                    fontSize: 13, // Increased font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'EXPIRES',
                                  style: TextStyle(
                                    color: card['accentColor'].withOpacity(0.7),
                                    fontSize: 11, // Slightly increased
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  card['expiry'],
                                  style: TextStyle(
                                    color: card['accentColor'],
                                    fontSize: 13, // Increased font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'VISA',
                              style: TextStyle(
                                color: card['accentColor'],
                                fontSize: 22, // Increased font size
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}