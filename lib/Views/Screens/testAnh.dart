import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class CropImageScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final Function(Uint8List) onCrop;

  const CropImageScreen({
    super.key,
    required this.imageBytes,
    required this.onCrop,
  });

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  Offset _position = Offset.zero; // Vị trí của khung cắt
  final double _cropSize = 224; // Kích thước khung 224x224
  late double _imageWidth;
  late double _imageHeight;
  final double _imageScale = 0.70; // Tỷ lệ thu nhỏ ảnh

  @override
  void initState() {
    super.initState();
    // Tính toán tỷ lệ ảnh thực tế
    final image = img.decodeImage(widget.imageBytes)!;
    final double aspectRatio = image.width / image.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _imageWidth = MediaQuery.of(context).size.width * _imageScale;
        _imageHeight = _imageWidth / aspectRatio; // Giữ tỷ lệ ảnh gốc
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cắt ảnh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _cropImage,
          ),
        ],
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Nếu chưa có _imageWidth, sử dụng giá trị mặc định tạm thời
            _imageWidth = _imageWidth ?? constraints.maxWidth * _imageScale;
            _imageHeight = _imageHeight ?? _imageWidth;

            // Giới hạn vị trí khung cắt
            _position = Offset(
              _position.dx.clamp(0, _imageWidth - _cropSize),
              _position.dy.clamp(0, _imageHeight - _cropSize),
            );

            return Container(
              color: Colors.black, // Nền đen để nổi bật ảnh
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.memory(
                    widget.imageBytes,
                    width: _imageWidth,
                    height: _imageHeight,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    left: _position.dx,
                    top: _position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _position = Offset(
                            (_position.dx + details.delta.dx)
                                .clamp(0, _imageWidth - _cropSize),
                            (_position.dy + details.delta.dy)
                                .clamp(0, _imageHeight - _cropSize),
                          );
                        });
                      },
                      child: Container(
                        width: _cropSize,
                        height: _cropSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    // Tải ảnh từ Uint8List
    final image = img.decodeImage(widget.imageBytes)!;

    // Tính toán tỷ lệ giữa kích thước hiển thị và kích thước thực của ảnh
    final double scaleX = image.width / _imageWidth;
    final double scaleY = image.height / _imageHeight;

    // Tính toán vị trí và kích thước cắt
    final int cropX = (_position.dx * scaleX).toInt();
    final int cropY = (_position.dy * scaleY).toInt();
    final int cropWidth = (_cropSize * scaleX).toInt();
    final int cropHeight = (_cropSize * scaleY).toInt();

    // Kiểm tra giới hạn để tránh lỗi
    final int validCropX = cropX.clamp(0, image.width - cropWidth);
    final int validCropY = cropY.clamp(0, image.height - cropHeight);

    // Cắt ảnh
    final croppedImage = img.copyCrop(
      image,
      x: validCropX,
      y: validCropY,
      width: cropWidth,
      height: cropHeight,
    );

    // Resize ảnh về 224x224
    final resizedImage = img.copyResize(
      croppedImage,
      width: 224,
      height: 224,
    );

    // Chuyển ảnh thành Uint8List
    final croppedBytes = Uint8List.fromList(img.encodeJpg(resizedImage));

    // Gọi callback để trả về ảnh đã cắt
    widget.onCrop(croppedBytes);

    // Quay lại màn hình trước
    Navigator.pop(context);
  }
}
