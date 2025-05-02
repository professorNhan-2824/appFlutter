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

class _CropImageScreenState extends State<CropImageScreen>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  final double _cropSize = 224;
  late double _imageWidth;
  late double _imageHeight;
  final double _imageScale = 0.80;
  bool _isDragging = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Theme colors
  final Color primaryColor = const Color.fromRGBO(80, 199, 143, 1);
  final Color backgroundColor = const Color.fromRGBO(225, 240, 239, 1);

  @override
  void initState() {
    super.initState();
    final image = img.decodeImage(widget.imageBytes)!;
    final double aspectRatio = image.width / image.height;

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Center the crop box initially
      final screenWidth = MediaQuery.of(context).size.width;
      _imageWidth = screenWidth * _imageScale;
      _imageHeight = _imageWidth / aspectRatio;

      setState(() {
        // Center the crop box
        _position = Offset(
          (_imageWidth - _cropSize) / 2,
          (_imageHeight - _cropSize) / 2,
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _centerCropBox() {
    setState(() {
      _position = Offset(
        (_imageWidth - _cropSize) / 2,
        (_imageHeight - _cropSize) / 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cắt ảnh',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Căn giữa khung cắt',
            onPressed: _centerCropBox,
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Hoàn thành',
            onPressed: _cropImage,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Transform.scale(
              scale: 0.9 + (0.1 * _animation.value),
              child: child,
            ),
          );
        },
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Kéo khung màu để chọn vùng ảnh',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    _imageWidth =
                        _imageWidth ?? constraints.maxWidth * _imageScale;
                    _imageHeight = _imageHeight ?? _imageWidth;

                    _position = Offset(
                      _position.dx.clamp(0, _imageWidth - _cropSize),
                      _position.dy.clamp(0, _imageHeight - _cropSize),
                    );

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // The background
                        Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          color: Colors.black.withOpacity(0.7),
                        ),

                        // The image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            widget.imageBytes,
                            width: _imageWidth,
                            height: _imageHeight,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // The overlay to dim areas outside the crop
                        CustomPaint(
                          size: Size(_imageWidth, _imageHeight),
                          painter: CropOverlayPainter(
                            cropRect: Rect.fromLTWH(_position.dx, _position.dy,
                                _cropSize, _cropSize),
                          ),
                        ),

                        // The crop frame
                        Positioned(
                          left: _position.dx,
                          top: _position.dy,
                          child: GestureDetector(
                            onPanStart: (_) {
                              setState(() {
                                _isDragging = true;
                              });
                            },
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
                            onPanEnd: (_) {
                              setState(() {
                                _isDragging = false;
                              });
                            },
                            child: Container(
                              width: _cropSize,
                              height: _cropSize,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: _isDragging
                                        ? primaryColor.withOpacity(0.5)
                                        : Colors.transparent,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Corner markers
                                  ...List.generate(4, (index) {
                                    final isTop = index < 2;
                                    final isLeft = index.isEven;

                                    return Positioned(
                                      top: isTop ? 0 : null,
                                      bottom: !isTop ? 0 : null,
                                      left: isLeft ? 0 : null,
                                      right: !isLeft ? 0 : null,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: isTop
                                                ? BorderSide(
                                                    color: primaryColor,
                                                    width: 4)
                                                : BorderSide.none,
                                            bottom: !isTop
                                                ? BorderSide(
                                                    color: primaryColor,
                                                    width: 4)
                                                : BorderSide.none,
                                            left: isLeft
                                                ? BorderSide(
                                                    color: primaryColor,
                                                    width: 4)
                                                : BorderSide.none,
                                            right: !isLeft
                                                ? BorderSide(
                                                    color: primaryColor,
                                                    width: 4)
                                                : BorderSide.none,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  // Guide lines
                                  Opacity(
                                    opacity: 0.5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            height: 1, color: Colors.white),
                                        Container(
                                            height: 1, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            width: 1, color: Colors.white),
                                        Container(
                                            width: 1, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Hủy'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _cropImage,
                      icon: const Icon(Icons.check),
                      label: const Text('Đồng ý'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
  }

  Future<void> _cropImage() async {
    final image = img.decodeImage(widget.imageBytes)!;

    final double scaleX = image.width / _imageWidth;
    final double scaleY = image.height / _imageHeight;

    final int cropX = (_position.dx * scaleX).toInt();
    final int cropY = (_position.dy * scaleY).toInt();
    final int cropWidth = (_cropSize * scaleX).toInt();
    final int cropHeight = (_cropSize * scaleY).toInt();

    final int validCropX = cropX.clamp(0, image.width - cropWidth);
    final int validCropY = cropY.clamp(0, image.height - cropHeight);

    final croppedImage = img.copyCrop(
      image,
      x: validCropX,
      y: validCropY,
      width: cropWidth,
      height: cropHeight,
    );

    final resizedImage = img.copyResize(
      croppedImage,
      width: 224,
      height: 224,
    );

    final croppedBytes = Uint8List.fromList(img.encodeJpg(resizedImage));
    widget.onCrop(croppedBytes);
    Navigator.pop(context);
  }
}

// Custom painter to create the dimmed overlay outside crop area
class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcOver;

    // Draw full size rect with semi-transparent black
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Then cut out the crop rect using BlendMode.clear
    final clearPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    canvas.drawRect(cropRect, clearPaint);
  }

  @override
  bool shouldRepaint(CropOverlayPainter oldDelegate) {
    return cropRect != oldDelegate.cropRect;
  }
}
