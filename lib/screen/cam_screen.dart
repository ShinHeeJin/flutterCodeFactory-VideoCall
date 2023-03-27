import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // 위젯 생성시 즉시 실행되는 build 함수
    return Scaffold(
      appBar: AppBar(
        title: const Text("LIVE"),
      ),
      body: FutureBuilder(
        // FutureBuilder : Future를 반환하는 함수의 결과에 따라 위젯을 렌더링 할 때 사용.
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Center(
            child: Text("모든 권한이 있습니다!"),
          );
        },
      ),
    );
  }
}
