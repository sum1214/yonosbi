import 'package:flutter/material.dart';
import 'package:yonosbi/core/constants/app_colors.dart';
import 'package:yonosbi/features/auth/presentation/pages/login_screen.dart';

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Session Expired',
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Illustration placeholder (Triangle warning and cactus)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: CustomPaint(
                      size: const Size(200, 100),
                      painter: SessionExpiredPainter(),
                    ),
                  ),
                  const Positioned(
                    top: 20,
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Color(0xFFe11a81), // Pink color like in SBI
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Your session has expired. Please login again to continue using the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionExpiredPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw some simple ground/hills
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.8, size.width * 0.5, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.7, size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Draw a simple cactus
    final cactusPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(Offset(size.width * 0.3, size.height * 0.9), Offset(size.width * 0.3, size.height * 0.6), cactusPaint);
    canvas.drawArc(Rect.fromLTWH(size.width * 0.25, size.height * 0.65, 10, 15), 3.14, 3.14, false, cactusPaint);
    canvas.drawArc(Rect.fromLTWH(size.width * 0.3, size.height * 0.7, 10, 15), 0, 3.14, false, cactusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
