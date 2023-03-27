import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;
  int? myUid;
  int? otherUid;

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();

      await engine!.initialize(const RtcEngineContext(
        appId: APP_ID,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
    }

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          // elapsed : joinChannel을 실행한 후 콜백이 실행되기 까지 걸린 시간
          print("채널에 입장했습니다. uid : ${connection.localUid}");
          setState(() {
            myUid = connection.localUid;
          });
        },
        onLeaveChannel: (connection, stats) {
          print("채널 퇴장");
          setState(() {
            myUid = null;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          // elapsed : 내가 채널을 들어왔을 때 부터 상대가 들어올 때까지 걸린 시간
          print("상대가 채널에 입장했습니다. uid : $remoteUid");
          setState(() {
            otherUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          // reason : 방에서 나가게 된 이유 ( 직접 나가기 또는 네트워크 끊김 등 )
          print("상대가 채널에서 나갔습니다. uid : $remoteUid");
          setState(() {
            otherUid = null;
          });
        },
      ),
    );

    await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine!.enableVideo(); // 동영상기능 활성화
    await engine!.joinChannel(
      token: TEMP_TOKEN,
      channelId: CHANNEL_NAME,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
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
