

import 'package:flutter/material.dart';
import 'package:flutter_app/model/bird.dart';

class BirdCard extends StatelessWidget {
  final Bird bird;

  const BirdCard({Key? key, required this.bird}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(bird.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(bird.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bird.description, style: TextStyle(color: Colors.grey[700])),
            Text(bird.info, style: TextStyle(color: Colors.grey[500])),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Điều hướng sang màn hình chi tiết
        },
      ),
    );
  }
}