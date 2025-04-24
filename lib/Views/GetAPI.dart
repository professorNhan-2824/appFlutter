import 'package:flutter/material.dart';

import '../model/bird.dart';
import 'API.dart';

class BirdSearchScreen extends StatefulWidget {
  @override
  _BirdSearchScreenState createState() => _BirdSearchScreenState();
}

class _BirdSearchScreenState extends State<BirdSearchScreen> {
  final BirdService _birdService = BirdService();
  final TextEditingController _searchController = TextEditingController();
  Future<List<Bird>>? _birdsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm chim'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên loài chim',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _birdsFuture = _birdService.findBirdBySpecies(_searchController.text);
                    });
                  },
                  child: Text('Tìm kiếm'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _birdsFuture == null
                ? Center(child: Text('Nhập tên loài chim để tìm kiếm'))
                : FutureBuilder<List<Bird>>(
              future: _birdsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không tìm thấy chim'));
                } else {
                  final birds = snapshot.data!;
                  return ListView.builder(
                    itemCount: birds.length,
                    itemBuilder: (context, index) {
                      final bird = birds[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bird.imageUrl.isNotEmpty
                                ? Image.network(
                              bird.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Center(child: Text('Không thể tải ảnh')),
                                );
                              },
                            )
                                : Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: Center(child: Text('Không có ảnh')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bird.species,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(bird.description),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}