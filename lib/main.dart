import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  // Flutter 앱이 실행될 준비가 됐는지 확인
  WidgetsFlutterBinding.ensureInitialized();

  // 핸드폰에 있는 카메라들 가져오기.
  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  // 카메라 컨트롤러
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(
        controller,
      ),
    );
  }

  initializeCamera() async {
    try {
      // 가장 첫 번째 카메라로 설정
      controller = CameraController(_cameras[0], ResolutionPreset.max);

      // 카메라 초기화
      await controller.initialize();
      setState(() {});
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case "CameraAccessDenied":
            print("User denied camera access.");
            break;
          default:
            print("Handle other errors.");
            break;
        }
      }
    }
  }
}
