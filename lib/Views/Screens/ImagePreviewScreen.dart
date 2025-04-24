import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;

  const ImagePreviewScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  int selectionMode = 0;
  List<Offset> drawPoints = [];
  Offset? startPoint;
  Offset? endPoint;
  String? croppedImagePath;
  bool isCropped = false;
  bool isProcessing = false;

  void _resetSelection() {
    setState(() {
      drawPoints = [];
      startPoint = null;
      endPoint = null;
    });
  }

  Future<void> _cropImage() async {
    setState(() {
      isProcessing = true;
    });

    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.imagePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cắt ảnh',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original, // Tỷ lệ khởi tạo
            lockAspectRatio: false, // Cho phép thay đổi tỷ lệ tự do
            cropStyle: CropStyle.rectangle, // Hình chữ nhật (có thể đổi thành circle)
          ),
          IOSUiSettings(
            title: 'Cắt ảnh',
            aspectRatioLockEnabled: false, // Tắt khóa tỷ lệ
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          croppedImagePath = croppedFile.path;
          isCropped = true;
          selectionMode = 0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cắt ảnh: $e')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isCropped ? 'Vùng ảnh đã cắt' : 'Ảnh đã chụp')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final displaySize = Size(constraints.maxWidth, constraints.maxHeight);
          return Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (isCropped && croppedImagePath != null)
                      Image.file(
                        File(croppedImagePath!),
                        fit: BoxFit.contain,
                      )
                    else
                      Center(
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (!isCropped && selectionMode > 0)
                      GestureDetector(
                        onPanStart: (details) {
                          setState(() {
                            if (selectionMode == 1) {
                              startPoint = details.localPosition;
                              endPoint = details.localPosition;
                            } else if (selectionMode == 2) {
                              drawPoints = [details.localPosition];
                            }
                          });
                        },
                        onPanUpdate: (details) {
                          setState(() {
                            if (selectionMode == 1) {
                              endPoint = details.localPosition;
                            } else if (selectionMode == 2) {
                              drawPoints.add(details.localPosition);
                            }
                          });
                        },
                        child: CustomPaint(
                          painter: EnhancedSelectionPainter(
                            mode: selectionMode,
                            drawPoints: drawPoints,
                            startPoint: startPoint,
                            endPoint: endPoint,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    if (isProcessing)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
              if (!isCropped)
                Column(
                  children: [
                    if (selectionMode > 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _resetSelection,
                              child: const Text('Xóa chọn'),
                            ),
                            ElevatedButton(
                              onPressed: isProcessing ? null : _cropImage,
                              child: isProcessing
                                  ? const Text('Đang xử lý...')
                                  : const Text('Cắt vùng chọn'),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectionMode = 1;
                                    _resetSelection();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectionMode == 1 ? Colors.blue : null,
                                ),
                                child: const Text('Chọn hình chữ nhật'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectionMode = 2;
                                    _resetSelection();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectionMode == 2 ? Colors.blue : null,
                                ),
                                child: const Text('Vẽ tự do'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Chụp lại'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, widget.imagePath),
                                child: const Text('Sử dụng ảnh này'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isCropped = false;
                            croppedImagePath = null;
                          });
                        },
                        child: const Text('Quay lại'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, croppedImagePath),
                        child: const Text('Sử dụng ảnh đã cắt'),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class EnhancedSelectionPainter extends CustomPainter {
  final int mode;
  final List<Offset> drawPoints;
  final Offset? startPoint;
  final Offset? endPoint;

  EnhancedSelectionPainter({
    required this.mode,
    required this.drawPoints,
    this.startPoint,
    this.endPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (mode == 0) return;

    final Paint dimmingPaint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), dimmingPaint);

    final Paint outlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (mode == 1 && startPoint != null && endPoint != null) {
      final rect = Rect.fromPoints(startPoint!, endPoint!);
      canvas.drawRect(rect, Paint()..blendMode = BlendMode.clear);
      canvas.drawRect(rect, outlinePaint);
      canvas.drawRect(rect, Paint()..color = Colors.white.withOpacity(0.15)..blendMode = BlendMode.screen);
    } else if (mode == 2 && drawPoints.length > 1) {
      if (drawPoints.length < 3) {
        for (int i = 0; i < drawPoints.length - 1; i++) {
          canvas.drawLine(drawPoints[i], drawPoints[i + 1], outlinePaint);
        }
        return;
      }
      final path = Path()..moveTo(drawPoints.first.dx, drawPoints.first.dy);
      for (int i = 1; i < drawPoints.length; i++) {
        path.lineTo(drawPoints[i].dx, drawPoints[i].dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..blendMode = BlendMode.clear);
      canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.15)..blendMode = BlendMode.screen);
      canvas.drawPath(path, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}