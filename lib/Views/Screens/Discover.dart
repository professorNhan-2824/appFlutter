import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/cardBird.dart';
import 'package:flutter_app/model/bird.dart';

class BirdListApp extends StatelessWidget {
  const BirdListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BirdListScreen(),
    );
  }
}

class BirdListScreen extends StatefulWidget {
  @override
  _BirdListScreenState createState() => _BirdListScreenState();
}

class _BirdListScreenState extends State<BirdListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Bird> birds = [
    Bird("Ara macao", "Chim nhiệt đới", "12-14-0 (WLD)", "https://via.placeholder.com/150"),
    Bird("Toucan", "Cư dân rừng nhiệt đới", "8-30 (WLD)", "https://via.placeholder.com/150"),
    Bird("Robin", "Thuộc ăn hạt", "10-50 (WLD)", "https://via.placeholder.com/150"),
    Bird("Diệc", "Thợ săn cá", "15-21 (WLD)", "https://via.placeholder.com/150"),
  ];

  List<Bird> filteredBirds = [];

  @override
  void initState() {
    super.initState();
    filteredBirds = birds;
  }


  //Hàm này tìm ký tưj từ tên các loài chimchim
  void _filterBirds(String query) {
    setState(() {
      filteredBirds = birds
          .where((bird) => bird.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vẹt"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Nhìn"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Loài", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: _filterBirds,//Hàm này sẽ được gọi mỗi khi người dùng nhập ký tự
              decoration: InputDecoration(
                hintText: "Tìm kiếm tên loài",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBirds.length,
                itemBuilder: (context, index) {
                  Bird bird = filteredBirds[index];
                  return BirdCard(bird: bird);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}