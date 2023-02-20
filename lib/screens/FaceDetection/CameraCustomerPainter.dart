import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:rosterinsight/screens/FaceDetection/CameraCustomPaintCoordinate.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face>? faces;
  final Size? absoluteImageSize;
  final InputImageRotation? rotation;
  FaceDetectorPainter({this.rotation, this.absoluteImageSize, this.faces});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.blue;
    for (final face in faces!) {
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(
              face.boundingBox.left, rotation!, size, absoluteImageSize!),
          translateX(face.boundingBox.top, rotation!, size, absoluteImageSize!),
          translateX(
              face.boundingBox.right, rotation!, size, absoluteImageSize!),
          translateX(
              face.boundingBox.bottom, rotation!, size, absoluteImageSize!),
        ),
        paint,
      );
      void paintContour(final FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(
                    translateX(point.x.toDouble(), rotation!, size,
                        absoluteImageSize!),
                    translateY(point.y.toDouble(), rotation!, size,
                        absoluteImageSize!)),
                1.0,
                paint);
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
