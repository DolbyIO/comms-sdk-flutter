import 'package:dolbyio_comms_sdk_flutter_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'token.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
  });

  testWidgets('VoxeetSDK: initiliseToken', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.initializeToken(
        tokenString, () => Future.value(tokenString));
  });

  testWidgets('VoxeetSDK: openSession', (tester) async {
    var participantInfo = ParticipantInfo("bin", "avatarUrl", "123");
    await dolbyioCommsSdkFlutterPlugin.session.open(participantInfo);
  });

  testWidgets('VoxeetSDK: createJoin', (tester) async {
    var parameters = ConferenceCreateParameters();
    parameters.dolbyVoice = true;
    parameters.liveRecording = true;
    parameters.rtcpMode = RTCPMode.best;
    parameters.ttl = 15;
    parameters.videoCodec = Codec.h264;
    var options = ConferenceCreateOption(
        "test", parameters, 123, SpatialAudioStyle.individual);
    var conference =
        await dolbyioCommsSdkFlutterPlugin.conference.create(options);

    var joinOptions = ConferenceJoinOptions();
    joinOptions.constraints = ConferenceConstraints(true, true);
    joinOptions.maxVideoForwarding = 4;
    joinOptions.spatialAudio = true;
    joinOptions.mixing = ConferenceMixingOptions(true);
    await dolbyioCommsSdkFlutterPlugin.conference
        .join(conference, joinOptions);

    // var leaveOptions = ConferenceLeaveOptions(true);
    // await dolbyioCommsSdkFlutterPlugin.conference
    //     .leave(options: leaveOptions);
  });

  testWidgets('VoxeetSDK: getLocalStats', (tester) async {
    await dolbyioCommsSdkFlutterPlugin.conference.getLocalStats();
  });
}
