import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────
//  ORDER TRACKING SCREEN
// ─────────────────────────────────────────────────────────────
class OrderTrackingScreen extends StatefulWidget {
  final String restaurantName;
  final double totalAmount;
  final int estimatedMinutes;

  const OrderTrackingScreen({
    super.key,
    required this.restaurantName,
    required this.totalAmount,
    this.estimatedMinutes = 30,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _riderController;
  late AnimationController _pulseController;
  late AnimationController _statusController;

  // Rider position (0.0 → 1.0 along the path)
  late Animation<double> _riderProgress;
  late Animation<double> _pulseAnimation;

  // Timer
  late int _remainingSeconds;
  late final List<_StatusStep> _steps;
  int _currentStep = 1; // 0=placed, 1=preparing, 2=on-way, 3=delivered

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.estimatedMinutes * 60;

    _steps = [
      _StatusStep(icon: Icons.check_circle_rounded, label: 'Order Placed', sublabel: 'We got your order!'),
      _StatusStep(icon: Icons.restaurant_rounded, label: 'Preparing', sublabel: 'Chef is cooking...'),
      _StatusStep(icon: Icons.delivery_dining_rounded, label: 'On the Way', sublabel: 'Rider picked up your order'),
      _StatusStep(icon: Icons.home_rounded, label: 'Delivered', sublabel: 'Enjoy your meal!'),
    ];

    // Rider animation – loops across the path
    _riderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    _riderProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _riderController, curve: Curves.easeInOut),
    );
    _riderController.repeat();

    // Pulse animation for destination pin
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Status step animation
    _statusController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _statusController.addListener(() {
      final newStep = (_statusController.value * 3).floor().clamp(0, 3);
      if (newStep != _currentStep) {
        setState(() => _currentStep = newStep);
      }
    });
    _statusController.forward();

    // Countdown timer
    _startCountdown();
  }

  void _startCountdown() async {
    while (_remainingSeconds > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _remainingSeconds--);
    }
  }

  @override
  void dispose() {
    _riderController.dispose();
    _pulseController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  String get _timerDisplay {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ── MAP AREA ──────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            height: size.height * 0.52,
            child: _MapCanvas(
              riderProgress: _riderProgress,
              pulseAnimation: _pulseAnimation,
              primaryColor: primary,
            ),
          ),

          // ── TOP BAR ──────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _GlassButton(
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  _GlassButton(
                    child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 22),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── BOTTOM SHEET ─────────────────────────────────────
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: size.height * 0.55,
              decoration: const BoxDecoration(
                color: Color(0xFF141414),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Timer + Title Row ─────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Arriving in',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                    AnimatedBuilder(
                                      animation: _riderController,
                                      builder: (context, _) => Text(
                                        _timerDisplay,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.restaurantName,
                                      style: GoogleFonts.poppins(
                                        color: primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Total amount chip
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  color: primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: primary.withOpacity(0.3)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '₹${widget.totalAmount.toStringAsFixed(0)}',
                                      style: GoogleFonts.poppins(
                                        color: primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Total',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white54,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // ── Status Steps ──────────────────────
                          _StatusStepper(steps: _steps, currentStep: _currentStep, primaryColor: primary),

                          const SizedBox(height: 28),

                          // ── Rider Info Card ───────────────────
                          _RiderCard(primaryColor: primary),

                          const SizedBox(height: 20),

                          // ── Action Buttons ────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: _ActionButton(
                                  icon: Icons.phone_rounded,
                                  label: 'Call Rider',
                                  color: primary,
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ActionButton(
                                  icon: Icons.chat_bubble_rounded,
                                  label: 'Message',
                                  color: const Color(0xFF252525),
                                  onTap: () {},
                                  outlined: true,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  CUSTOM MAP CANVAS
// ─────────────────────────────────────────────────────────────
class _MapCanvas extends StatelessWidget {
  final Animation<double> riderProgress;
  final Animation<double> pulseAnimation;
  final Color primaryColor;

  const _MapCanvas({
    required this.riderProgress,
    required this.pulseAnimation,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark map background
        Container(color: const Color(0xFF1A1A2E)),
        // Grid lines (streets)
        CustomPaint(painter: _StreetPainter()),
        // Rider + route overlay
        AnimatedBuilder(
          animation: Listenable.merge([riderProgress, pulseAnimation]),
          builder: (context, _) {
            return CustomPaint(
              painter: _RouteAndRiderPainter(
                progress: riderProgress.value,
                pulse: pulseAnimation.value,
                primaryColor: primaryColor,
              ),
            );
          },
        ),
        // Gradient fade at bottom
        Positioned(
          bottom: 0, left: 0, right: 0,
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, const Color(0xFF141414)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  STREET GRID PAINTER
// ─────────────────────────────────────────────────────────────
class _StreetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF1E2240)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = const Color(0xFF252850)
      ..strokeWidth = 8;

    // Horizontal roads
    for (int i = 1; i <= 5; i++) {
      final y = size.height * (i / 6.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }

    // Vertical roads
    for (int i = 1; i <= 4; i++) {
      final x = size.width * (i / 5.0);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Buildings (random rectangles)
    final buildingPaint = Paint()..color = const Color(0xFF1C1F3C);
    final blocks = [
      Rect.fromLTWH(10, 10, 80, 60),
      Rect.fromLTWH(110, 10, 100, 50),
      Rect.fromLTWH(250, 15, 90, 55),
      Rect.fromLTWH(360, 10, 70, 60),
      Rect.fromLTWH(10, 100, 60, 80),
      Rect.fromLTWH(120, 100, 80, 70),
      Rect.fromLTWH(260, 100, 100, 65),
      Rect.fromLTWH(10, 215, 90, 60),
      Rect.fromLTWH(150, 220, 70, 55),
      Rect.fromLTWH(280, 210, 85, 65),
      Rect.fromLTWH(10, 315, 75, 50),
      Rect.fromLTWH(140, 315, 95, 55),
      Rect.fromLTWH(300, 320, 80, 50),
    ];

    for (final b in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(b, const Radius.circular(6)),
        buildingPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_StreetPainter old) => false;
}

// ─────────────────────────────────────────────────────────────
//  ROUTE + RIDER PAINTER
// ─────────────────────────────────────────────────────────────
class _RouteAndRiderPainter extends CustomPainter {
  final double progress;
  final double pulse;
  final Color primaryColor;

  _RouteAndRiderPainter({
    required this.progress,
    required this.pulse,
    required this.primaryColor,
  });

  // Define route waypoints as fractions of size
  List<Offset> _waypoints(Size s) => [
    Offset(s.width * 0.15, s.height * 0.82),
    Offset(s.width * 0.15, s.height * 0.52),
    Offset(s.width * 0.45, s.height * 0.52),
    Offset(s.width * 0.45, s.height * 0.28),
    Offset(s.width * 0.72, s.height * 0.28),
    Offset(s.width * 0.72, s.height * 0.18),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final waypoints = _waypoints(size);

    // ── Draw route line ──────────────────────────────────────
    final routePaint = Paint()
      ..color = primaryColor.withOpacity(0.35)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final travelledPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Total path length
    double totalLen = 0;
    for (int i = 0; i < waypoints.length - 1; i++) {
      totalLen += (waypoints[i + 1] - waypoints[i]).distance;
    }

    // Draw dashed route
    _drawDashedPath(canvas, waypoints, routePaint);

    // Draw travelled portion
    final travelledPath = Path();
    double accumulated = 0;
    final targetLen = totalLen * progress;
    travelledPath.moveTo(waypoints.first.dx, waypoints.first.dy);
    for (int i = 0; i < waypoints.length - 1; i++) {
      final segLen = (waypoints[i + 1] - waypoints[i]).distance;
      if (accumulated + segLen <= targetLen) {
        travelledPath.lineTo(waypoints[i + 1].dx, waypoints[i + 1].dy);
        accumulated += segLen;
      } else {
        final t = (targetLen - accumulated) / segLen;
        final pt = Offset.lerp(waypoints[i], waypoints[i + 1], t)!;
        travelledPath.lineTo(pt.dx, pt.dy);
        break;
      }
    }
    canvas.drawPath(travelledPath, travelledPaint);

    // ── Destination pin ──────────────────────────────────────
    final dest = waypoints.last;
    // Pulse ring
    canvas.drawCircle(
      dest,
      18 * pulse,
      Paint()..color = primaryColor.withOpacity(0.2),
    );
    canvas.drawCircle(
      dest,
      10,
      Paint()..color = primaryColor,
    );
    // Home icon via text
    final textSpan = TextSpan(
      text: '⌂',
      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, dest - Offset(tp.width / 2, tp.height / 2));

    // ── Rider position ───────────────────────────────────────
    final riderPos = _positionAlongPath(waypoints, progress);

    // Shadow
    canvas.drawCircle(
      riderPos + const Offset(2, 2),
      18,
      Paint()..color = Colors.black38,
    );
    // White circle
    canvas.drawCircle(riderPos, 18, Paint()..color = Colors.white);
    // Inner primary circle
    canvas.drawCircle(riderPos, 12, Paint()..color = primaryColor);

    // Bike icon (simplified dot)
    canvas.drawCircle(riderPos, 5, Paint()..color = Colors.white);

    // ── Origin pin ───────────────────────────────────────────
    final origin = waypoints.first;
    canvas.drawCircle(origin, 8, Paint()..color = Colors.orangeAccent);
    canvas.drawCircle(origin, 5, Paint()..color = Colors.white);
  }

  void _drawDashedPath(Canvas canvas, List<Offset> points, Paint paint) {
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      final dir = (end - start) / (end - start).distance;
      final len = (end - start).distance;
      double drawn = 0;
      while (drawn < len) {
        final s = start + dir * drawn;
        final e = start + dir * (drawn + 8).clamp(0, len);
        canvas.drawLine(s, e, paint);
        drawn += 16;
      }
    }
  }

  Offset _positionAlongPath(List<Offset> waypoints, double progress) {
    double totalLen = 0;
    for (int i = 0; i < waypoints.length - 1; i++) {
      totalLen += (waypoints[i + 1] - waypoints[i]).distance;
    }
    final target = totalLen * progress;
    double accumulated = 0;
    for (int i = 0; i < waypoints.length - 1; i++) {
      final segLen = (waypoints[i + 1] - waypoints[i]).distance;
      if (accumulated + segLen >= target) {
        final t = (target - accumulated) / segLen;
        return Offset.lerp(waypoints[i], waypoints[i + 1], t)!;
      }
      accumulated += segLen;
    }
    return waypoints.last;
  }

  @override
  bool shouldRepaint(_RouteAndRiderPainter old) =>
      old.progress != progress || old.pulse != pulse;
}

// ─────────────────────────────────────────────────────────────
//  STATUS STEPPER
// ─────────────────────────────────────────────────────────────
class _StatusStep {
  final IconData icon;
  final String label;
  final String sublabel;
  const _StatusStep({required this.icon, required this.label, required this.sublabel});
}

class _StatusStepper extends StatelessWidget {
  final List<_StatusStep> steps;
  final int currentStep;
  final Color primaryColor;

  const _StatusStepper({
    required this.steps,
    required this.currentStep,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (idx) {
        if (idx.isOdd) {
          // Connector line
          final stepIdx = idx ~/ 2;
          final isDone = stepIdx < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 28),
              decoration: BoxDecoration(
                color: isDone ? primaryColor : Colors.white12,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          );
        }
        // Step circle
        final stepIdx = idx ~/ 2;
        final isDone = stepIdx < currentStep;
        final isActive = stepIdx == currentStep;
        final step = steps[stepIdx];
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: isActive ? 48 : 36,
              height: isActive ? 48 : 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? primaryColor
                    : isActive
                        ? primaryColor.withOpacity(0.2)
                        : Colors.white10,
                border: Border.all(
                  color: isActive || isDone ? primaryColor : Colors.white12,
                  width: 2,
                ),
                boxShadow: isActive
                    ? [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]
                    : [],
              ),
              child: Icon(
                step.icon,
                color: isDone ? Colors.white : isActive ? primaryColor : Colors.white24,
                size: isActive ? 22 : 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              step.label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : Colors.white38,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  RIDER CARD
// ─────────────────────────────────────────────────────────────
class _RiderCard extends StatelessWidget {
  final Color primaryColor;
  const _RiderCard({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=150',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arjun Kumar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      '4.9  •  Delivery Partner',
                      style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bike chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.two_wheeler_rounded, color: primaryColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  'TN09 AB 1234',
                  style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ACTION BUTTON
// ─────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(16),
          border: outlined ? Border.all(color: Colors.white24) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  GLASS BUTTON HELPER
// ─────────────────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _GlassButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black45,
          border: Border.all(color: Colors.white24),
        ),
        child: Center(child: child),
      ),
    );
  }
}
