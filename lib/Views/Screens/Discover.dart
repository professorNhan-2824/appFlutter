import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/BirdDetail.dart';
import 'package:flutter_app/Views/Screens/HomeScreen.dart';
import 'package:flutter_app/Views/toolnav/BottomNavBar.dart';
import 'package:flutter_app/model/bird.dart';

class BirdListApp extends StatelessWidget {
  const BirdListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
      ),
      home: const BirdListScreen(),
    );
  }
}

class BirdListScreen extends StatefulWidget {
  const BirdListScreen({super.key});

  @override
  _BirdListScreenState createState() => _BirdListScreenState();
}

class _BirdListScreenState extends State<BirdListScreen> {
  List<Bird> allBirds = [
    Bird("Đớp ruồi bụng vàng", "Chim nhỏ săn côn trùng", "Khoảng 5 năm"),
    Bird("Chim ruồi họng đỏ", "Chim ruồi Bắc Mỹ", "Khoảng 5 năm"),
    Bird("Chim ruồi hung", "Chim ruồi nhỏ", "Khoảng 4 năm"),
    Bird("Giẻ cùi lam", "Chim rừng thông minh", "Khoảng 7 năm"),
    Bird("Chích tối mắt", "Chim nhỏ ăn hạt", "Khoảng 3 năm"),
    Bird("Bói cá mào", "Thợ săn cá", "Khoảng 6 năm"),
    Bird("Bói cá bụng trắng", "Chim săn mồi nước", "Khoảng 6 năm"),
    Bird("Vịt cổ xanh", "Vịt nước", "Khoảng 10 năm"),
    Bird("Vịt Merganser ngực đỏ", "Vịt săn cá", "Khoảng 8 năm"),
    Bird("Quạ đen thường", "Chim thông minh", "Khoảng 15 năm"),
    Bird("Chim sẻ nhà", "Chim phổ biến", "Khoảng 3 năm"),
    Bird("Chích vàng", "Chim nhỏ rực rỡ", "Khoảng 4 năm"),
    Bird("Chim bách thanh tuyết tùng", "Chim săn côn trùng", "Khoảng 5 năm"),
    Bird("Gõ kiến đầu đỏ", "Chim gõ cây", "Khoảng 12 năm"),
  ];

  List<Bird> filteredBirds = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredBirds = allBirds;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredBirds = allBirds
          .where(
              (bird) => bird.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách các loài chim",
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BirdRecognitionUI()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Các loài chim",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                )),
            const SizedBox(height: 12),
            TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên loài...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredBirds.isEmpty
                  ? const Center(
                      child: Text("Không tìm thấy loài chim nào."),
                    )
                  : ListView.separated(
                      itemCount: filteredBirds.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final bird = filteredBirds[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BirdDetailScreen(birdName: bird.name),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.air,
                                      size: 32, color: Colors.teal),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(bird.name,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Text(bird.description,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                        Text("Tuổi thọ: ${bird.info}",
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // ✅ BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavBar(),

      // ✅ FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mở màn hình upload ảnh nhận diện chim ở đây nếu cần
        },
        backgroundColor: const Color(0xFF0A2463),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E3A8A), Color(0xFF0A2463)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A8A).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              const Icon(Icons.camera_enhance, size: 28, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
