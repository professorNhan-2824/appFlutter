import 'package:flutter/material.dart';
import 'package:flutter_app/Views/toolnav/BottomNavBar.dart';
import 'package:google_fonts/google_fonts.dart'; // Thêm Google Fonts
import 'package:flutter_app/Views/Screens/BirdDetail.dart';
import 'package:flutter_app/model/bird.dart';

class BirdSearchScreen extends StatefulWidget {
  const BirdSearchScreen({super.key});

  @override
  State<BirdSearchScreen> createState() => _BirdSearchScreenState();
}

class _BirdSearchScreenState extends State<BirdSearchScreen> {
  final List<Bird> allBirds = [
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

  List<Bird> searchResults = [];
  String query = "";
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  void updateSearch(String value) {
    setState(() {
      query = value;
      isSearching = value.trim().isNotEmpty;
      if (value.trim().isEmpty) {
        searchResults = [];
      } else {
        searchResults = allBirds
            .where(
                (bird) => bird.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      updateSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Tìm kiếm loài chim",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Thanh tìm kiếm
            Container(
              width: 300,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Nhập tên loài chim...",
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Thông báo hoặc danh sách kết quả
            Expanded(
              child: !isSearching
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 80,
                            color: Colors.teal.withOpacity(0.6),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Hãy nhập tên loài chim để bắt đầu",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 60,
                                color: Colors.grey.withOpacity(0.6),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Không tìm thấy loài chim nào",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : AnimatedOpacity(
                          opacity: isSearching ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: ListView.separated(
                            itemCount: searchResults.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final bird = searchResults[index];
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
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        // Biểu tượng chim
                                        const Icon(
                                          Icons.air,
                                          size: 40,
                                          color: Colors.teal,
                                        ),
                                        const SizedBox(width: 16),
                                        // Thông tin chim
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bird.name,
                                                style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                bird.description,
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                "Thông tin: ${bird.info}",
                                                style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
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
            ),
          ],
        ),
      ),
      // Thêm BottomNavBar
      bottomNavigationBar: BottomNavBar(),
      // Thêm FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ImageUploadScreen()),
          // );
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
