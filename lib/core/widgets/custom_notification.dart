import 'package:flutter/material.dart';

class CustomNofitication extends StatelessWidget {
  const CustomNofitication({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color(0xffEEF8ED),
      ),
      child: Center(
        child: Stack(
          children: [
            Icon(Icons.notifications_none, size: 34),
            Positioned(
              right: 14,
              top: 4,
              child: Container(
                height: 7,

                width: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
