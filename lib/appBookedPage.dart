import 'package:flutter/material.dart';

class AppointmentBookedPage extends StatefulWidget {
  @override
  _AppointmentBookedPageState createState() => _AppointmentBookedPageState();
}

class _AppointmentBookedPageState extends State<AppointmentBookedPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animationController.value,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'Appointment Booked',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
