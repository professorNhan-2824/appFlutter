import 'package:flutter/material.dart';
import 'package:flutter_app/model/bird.dart';

class BirdCard extends StatelessWidget {
  final Bird bird;

  const BirdCard({Key? key, required this.bird}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bird.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              bird.description,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 2),
            Text(
              bird.info,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
