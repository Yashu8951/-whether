import 'package:flutter/material.dart';

class SecondForecast extends StatelessWidget {
  final IconData icon;
  final String firsttext;
  final String value;
  const SecondForecast(
      {super.key,
      required this.firsttext,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  firsttext,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Icon(icon, size: 32),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
