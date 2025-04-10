import 'package:flutter/material.dart';

class BirdDetailApp extends StatelessWidget {
  const BirdDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BirdDetailScreen(),
    );
  }
}

class BirdDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Hình ảnh chim
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/400"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chim cú mèo",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                          SizedBox(width: 5),
                          Text("15 Tháng Năm, 2022", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.grey),
                          SizedBox(width: 5),
                          Text("6:00 sáng - 9:00 sáng", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.nature_people, size: 18, color: Colors.grey),
                          SizedBox(width: 5),
                          Text("Chú thích môi trường sống", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Thông tin loài",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text("Xem bản đồ", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Nút quay lại góc trái trên
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
