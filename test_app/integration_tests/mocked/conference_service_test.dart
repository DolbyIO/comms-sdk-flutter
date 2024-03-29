import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';

void conferenceServiceTest() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // NEW

  final dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;

  setUp(() async {
    await resetSDK();
  });

  group('Conference Service', () {
    testWidgets('ConferenceService: create', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCreateConferenceReturn",
          args: {"type": 1});

      var parameters = ConferenceCreateParameters();
      parameters.dolbyVoice = true;
      parameters.liveRecording = true;
      parameters.rtcpMode = RTCPMode.best;
      parameters.ttl = 15;
      parameters.videoCodec = Codec.h264;
      var options = ConferenceCreateOption(
          "test_alias", parameters, 1234, SpatialAudioStyle.individual);
      var conference =
          await dolbyioCommsSdkFlutterPlugin.conference.create(options);
      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertCreateConferenceArgs",
          expected: {
            "alias": "test_alias",
            "params_dolby": true,
            "params_liveRecording": true,
            "params_rtcpMode": "best",
            "params_ttl": 15,
            "params_videoCodec": "H264",
            "pin": 1234,
            "spatialAudioStyle": "INDIVIDUAL"
          });

      expect(conference.id, "setCreateConferenceReturn_id_1");
      expect(conference.alias, "setCreateConferenceReturn_alias_1");

      await resetSDK();

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCreateConferenceReturn",
          args: {"type": 1});

      parameters = ConferenceCreateParameters();
      parameters.dolbyVoice = false;
      parameters.liveRecording = false;
      parameters.rtcpMode = RTCPMode.worst;
      parameters.ttl = 30;
      parameters.videoCodec = Codec.vp8;
      options = ConferenceCreateOption(
          "test_alias2", parameters, 4321, SpatialAudioStyle.individual);
      conference =
          await dolbyioCommsSdkFlutterPlugin.conference.create(options);
      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertCreateConferenceArgs",
          expected: {
            "alias": "test_alias2",
            "params_dolby": false,
            "params_liveRecording": false,
            "params_rtcpMode": "worst",
            "params_ttl": 30,
            "params_videoCodec2": "VP8",
            "pin": 4321,
            "spatialAudioStyle": "INDIVIDUAL"
          });
    });

    testWidgets('ConferenceService: fetch', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 1});

      var conference = await dolbyioCommsSdkFlutterPlugin.conference
          .fetch("fetch_conferenceId_1");

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertFetchConferenceArgs",
          expected: {"conferenceId": "fetch_conferenceId_1"});

      expect(conference.id, "setCreateConferenceReturn_id_1");
      expect(conference.alias, "setCreateConferenceReturn_alias_1");
      expect(conference.isNew, false);
      expect(conference.status, ConferenceStatus.ended);

      await resetSDK();

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 2});

      conference = await dolbyioCommsSdkFlutterPlugin.conference
          .fetch("fetch_conferenceId_2");

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertFetchConferenceArgs",
          expected: {"conferenceId": "fetch_conferenceId_2"});

      expect(conference.id, "setCreateConferenceReturn_id_2");
      expect(conference.alias, "setCreateConferenceReturn_alias_2");
      expect(conference.isNew, true);
      expect(conference.participants[0].id, "participant_id_2");
      expect(conference.participants[0].info?.externalId,
          "participant_info_external_id_2");
      expect(conference.participants[0].info?.name, "participant_info_name_2");
      expect(conference.participants[0].info?.avatarUrl,
          "participant_info_avatar_url_2");
      expect(conference.participants[0].status, ParticipantStatus.decline);
      expect(conference.participants[0].type, ParticipantType.listner);
      expect(conference.status, ConferenceStatus.created);

      await resetSDK();

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 3});

      conference = await dolbyioCommsSdkFlutterPlugin.conference
          .fetch("fetch_conferenceId_3");

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertFetchConferenceArgs",
          expected: {"conferenceId": "fetch_conferenceId_3"});

      expect(conference.id, "setCreateConferenceReturn_id_3");
      expect(conference.alias, "setCreateConferenceReturn_alias_3");
      expect(conference.isNew, false);
      expect(conference.participants[0].id, "participant_id_3");
      expect(conference.participants[0].info?.externalId,
          "participant_info_external_id_3");
      expect(conference.participants[0].info?.name, "participant_info_name_3");
      expect(conference.participants[0].info?.avatarUrl,
          "participant_info_avatar_url_3");
      expect(conference.participants[0].status, ParticipantStatus.error);
      expect(conference.participants[0].type, ParticipantType.user);
      expect(conference.status, ConferenceStatus.ended);

      await resetSDK();

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 4});

      conference = await dolbyioCommsSdkFlutterPlugin.conference
          .fetch("fetch_conferenceId_1");

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertFetchConferenceArgs",
          expected: {"conferenceId": "fetch_conferenceId_1"});

      expect(conference.id, "setCreateConferenceReturn_id_4");
      expect(conference.alias, "setCreateConferenceReturn_alias_4");
      expect(conference.isNew, false);
      expect(conference.participants[0].id, "participant_id_4");
      expect(conference.participants[0].info?.externalId, null);
      expect(conference.participants[0].info?.name, "");
      expect(conference.participants[0].info?.avatarUrl, null);
      expect(conference.participants[0].status, ParticipantStatus.connecting);
      expect(conference.participants[0].type, ParticipantType.unknown);
      expect(conference.status, ConferenceStatus.ended);
    });

    testWidgets('ConferenceService: join', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setJoinConferenceReturn",
          args: {"type": 1});

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 4});

      var conference = Conference(
          "conference_alias",
          "conference_id",
          true,
          [
            Participant(
                "participant_id",
                ParticipantInfo(
                    "participant_name", "avatar_url", "external_id"),
                ParticipantStatus.connected,
                ParticipantType.listner)
          ],
          ConferenceStatus.created,
          SpatialAudioStyle.individual);

      var conferenceJoinOptions = ConferenceJoinOptions();
      conferenceJoinOptions.conferenceAccessToken = "conference_access_token";
      conferenceJoinOptions.constraints = ConferenceConstraints(true, true);
      conferenceJoinOptions.maxVideoForwarding = 15;
      conferenceJoinOptions.mixing = ConferenceMixingOptions(true);
      conferenceJoinOptions.simulcast = true;
      conferenceJoinOptions.spatialAudio = true;
      var returnedConference = await dolbyioCommsSdkFlutterPlugin.conference
          .join(conference, conferenceJoinOptions);

      if (Platform.isIOS) {
        await expectNative(
            methodChannel: conferenceServiceAssertsMethodChannel,
            assertLabel: "assertFetchConferenceArgs",
            expected: {"conferenceId": "conference_id"});
        await expectNative(
            methodChannel: conferenceServiceAssertsMethodChannel,
            assertLabel: "assertJoinConfrenceArgs",
            expected: {
              "conference": {
                "id": "setCreateConferenceReturn_id_4",
                "alias": "setCreateConferenceReturn_alias_4"
              },
              "joinOptions": {
                "conferenceAccessToken": "conference_access_token",
                "constraints": {"audio": true, "video": true},
                "maxVideoForwarding": 15,
                "spatialAudio": true
              }
            });
      } else if (Platform.isAndroid) {
        await expectNative(
            methodChannel: conferenceServiceAssertsMethodChannel,
            assertLabel: "assertJoinConfrenceArgs",
            expected: {
              "conference": {
                "id": "conference_id",
                "alias": "conference_alias"
              },
              "joinOptions": {
                "conferenceAccessToken": "conference_access_token",
                "constraints": {"audio": true, "video": true},
                "maxVideoForwarding": 15,
                "spatialAudio": true
              }
            });
      } else {
        fail("Platform unsupported");
      }

      expect(returnedConference.id, "setCreateConferenceReturn_id_1");
      expect(returnedConference.alias, "setCreateConferenceReturn_alias_1");
    });

    testWidgets('ConferenceService: startScreenShare', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.startScreenShare();

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStartScreeenShareArgs",
          expected: {"broadcast": true});
    });

    testWidgets('ConferenceService: stopScreenShare', (tester) async {
      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.stopScreenShare();

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStartScreeenShareArgs",
          expected: {});
    });

    testWidgets('ConferenceService: kick', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.kick(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertKickArgs",
          expected: {"id": "participant_id_5_1"});

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.kick(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertKickArgs",
          expected: {"id": "participant_id_5_2"});
    });

    testWidgets('ConferenceService: leave', (tester) async {
      var leaveOptions = ConferenceLeaveOptions(true);

      await dolbyioCommsSdkFlutterPlugin.conference
          .leave(options: leaveOptions);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertLeaveArgs",
          expected: {"hasRun": true});

      await expectNative(
          methodChannel: sessionServiceAssertsMethodChannel,
          assertLabel: "assertCloseArgs",
          expected: {"hasRun": true});

      await resetSDK();

      leaveOptions = ConferenceLeaveOptions(false);

      await dolbyioCommsSdkFlutterPlugin.conference
          .leave(options: leaveOptions);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertLeaveArgs",
          expected: {"hasRun": true});

      await expectNative(
          methodChannel: sessionServiceAssertsMethodChannel,
          assertLabel: "assertCloseArgs",
          expected: {"hasRun": false});
    });

    testWidgets('ConferenceService: current', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"for_current": true});

      var conference = await dolbyioCommsSdkFlutterPlugin.conference.current();
      expect(conference, isNull);

      var iterration = 1;
      for (final alias in ["alias_1", "alias_2"]) {
        for (final confId in ["conf_id_1", "conf_id_2"]) {
          for (final isNew in [false, true]) {
            for (final status in _conferenceStatusList) {
              for (final spatialAudioStyle in _spatialAudioStyleList) {
                conference =
                    await dolbyioCommsSdkFlutterPlugin.conference.current();
                expect(conference, isNotNull, reason: "In itterration: $iterration");
                expect(conference?.alias, equals(alias));
                expect(conference?.id, equals(confId));
                expect(conference?.isNew, equals(isNew));
                expect(conference?.status, equals(status));
                expect(
                    conference!.spatialAudioStyle, equals(spatialAudioStyle));
                iterration++;
              }
            }
          }
        }
      }
    });

    testWidgets('ConferenceService: getAudioLevel', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setAudioLevelReturn",
          args: {"value": 5});

      var audioLevel = await dolbyioCommsSdkFlutterPlugin.conference
          .getAudioLevel(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertAudioLevelArgs",
          expected: {"id": "participant_id_5_1"});

      expect(audioLevel, 5);

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.inactive,
          ParticipantType.user);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setAudioLevelReturn",
          args: {"value": 15});

      audioLevel = await dolbyioCommsSdkFlutterPlugin.conference
          .getAudioLevel(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertAudioLevelArgs",
          expected: {"id": "participant_id_5_2"});

      expect(audioLevel, 15);
    });

    testWidgets('ConferenceService: getMaxVideoForwarding', (tester) async {
      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setMaxVideoForwardingReturn",
          args: {"value": 3});
      var maxVideoForwarding =
          await dolbyioCommsSdkFlutterPlugin.conference.getMaxVideoForwarding();
      expect(maxVideoForwarding, 3);

      await resetSDK();

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setMaxVideoForwardingReturn",
          args: {"value": 5});
      maxVideoForwarding =
          await dolbyioCommsSdkFlutterPlugin.conference.getMaxVideoForwarding();
      expect(maxVideoForwarding, 5);
    });

    testWidgets('ConferenceService: startAudio', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.startAudio(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStartAudioConferenceArgs",
          expected: {"id": "participant_id_5_1"});

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.startAudio(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStartAudioConferenceArgs",
          expected: {"id": "participant_id_5_2"});
    });

    testWidgets('ConferenceService: stopAudio', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.stopAudio(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStopAudioConferenceArgs",
          expected: {"id": "participant_id_5_1"});

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.stopAudio(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStopAudioConferenceArgs",
          expected: {"id": "participant_id_5_2"});
    });

    testWidgets('ConferenceService: startVideo', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.startVideo(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStartVideoConferenceArgs",
          expected: {"id": "participant_id_5_1"});

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.startVideo(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStartVideoConferenceArgs",
          expected: {"id": "participant_id_5_2"});
    });

    testWidgets('ConferenceService: stopVideo', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.stopVideo(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStopVideoConferenceArgs",
          expected: {"id": "participant_id_5_1"});

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.stopVideo(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertStopVideoConferenceArgs",
          expected: {"id": "participant_id_5_2"});
    });

    testWidgets('ConferenceService: replay', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 4});

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 4});

      var conference = Conference(
          "conference_alias",
          "conference_id",
          true,
          [
            Participant(
                "participant_id",
                ParticipantInfo(
                    "participant_name", "avatar_url", "external_id"),
                ParticipantStatus.connected,
                ParticipantType.listner)
          ],
          ConferenceStatus.created,
          SpatialAudioStyle.individual);

      var replayOptions = ConferenceReplayOptions("token", 1);

      await dolbyioCommsSdkFlutterPlugin.conference
          .replay(conference: conference, replayOptions: replayOptions);

      if (Platform.isAndroid) {
        await dolbyioCommsSdkFlutterPlugin.conference.fetch("conference_id");
      }

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertFetchConferenceArgs",
          expected: {"conferenceId": "conference_id"});

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertReplayConferenceArgs",
          expected: {
            "conference": {"conferenceId": "conference_id"},
            "offset": 1,
            "conferenceAccessToken": "token"
          });
    });

    testWidgets('ConferenceService: getParticipant', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      var participant = await dolbyioCommsSdkFlutterPlugin.conference
          .getParticipant("participant_id_5_1");
      expect(participant.id, "participant_id_5_1");

      await resetSDK();

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      participant = await dolbyioCommsSdkFlutterPlugin.conference
          .getParticipant("participant_id_5_2");
      expect(participant.id, "participant_id_5_2");
    });

    testWidgets('ConferenceService: getParticipants', (tester) async {
      var conference = Conference(
          "setCreateConferenceReturn_alias_5",
          "setCreateConferenceReturn_id_5",
          true,
          [],
          ConferenceStatus.created,
          SpatialAudioStyle.individual);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      var participants = await dolbyioCommsSdkFlutterPlugin.conference
          .getParticipants(conference);

      expect(participants[0].id, "participant_id_5_1");
      expect(participants[1].id, "participant_id_5_2");

      await resetSDK();

      conference = Conference(
          "setCreateConferenceReturn_alias_6",
          "setCreateConferenceReturn_id_6",
          true,
          [],
          ConferenceStatus.created,
          SpatialAudioStyle.individual);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 6});

      participants = await dolbyioCommsSdkFlutterPlugin.conference
          .getParticipants(conference);

      expect(participants[0].id, "participant_id_6_1");
      expect(participants[1].id, "participant_id_6_2");
      expect(participants[2].id, "participant_id_6_3");
    });

    testWidgets('ConferenceService: setSpatialPosition', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      var position = SpatialPosition(1, 1, 1);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference
          .setSpatialPosition(participant: participant, position: position);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertSetSpatialPositionArgs",
          expected: {
            "participant": {"id": "participant_id_5_1"},
            "position": {"x": 1, "y": 1, "z": 1}
          });
    });
    testWidgets('ConferenceService: setSpatialEnvironment', (tester) async {
      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.setSpatialEnvironment(
          SpatialScale(0, 0, 0),
          SpatialPosition(1, 0, 0),
          SpatialPosition(0, 1, 0),
          SpatialPosition(0, 0, 1));

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertSetSpatialEnvironmentArgs",
          expected: {
            "scale": {"x": 0, "y": 0, "z": 0},
            "forward": {"x": 1, "y": 0, "z": 0},
            "up": {"x": 0, "y": 1, "z": 0},
            "right": {"x": 0, "y": 0, "z": 1}
          });
    });
    testWidgets('ConferenceService: setSpatialDirection', (tester) async {
      var direction = SpatialDirection(1, 1, 1);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      runNative(
          methodChannel: sessionServiceAssertsMethodChannel,
          label: "setLocalParticipantArgs",
          args: {"id": "participant_id"});

      await dolbyioCommsSdkFlutterPlugin.conference
          .setSpatialDirection(direction);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertSetSpatialDirectionArgs",
          expected: {
            "participant": {"id": "participant_id"},
            "direction": {"x": 1, "y": 1, "z": 1}
          });
    });

    testWidgets('ConferenceService: mute', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await dolbyioCommsSdkFlutterPlugin.conference.mute(participant, true);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertMuteConferenceArgs",
          expected: {"id": "participant_id_5_1", "isMuted": true});
    });

    testWidgets('ConferenceService: getStatus', (tester) async {
      var conference = Conference(
          "setCreateConferenceReturn_alias_5",
          "setCreateConferenceReturn_id_5",
          true,
          [],
          ConferenceStatus.creating,
          SpatialAudioStyle.individual);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 5});

      var status =
          await dolbyioCommsSdkFlutterPlugin.conference.getStatus(conference);

      if (Platform.isIOS) {
        await expectNative(
            methodChannel: conferenceServiceAssertsMethodChannel,
            assertLabel: "assertFetchConferenceArgs",
            expected: {"conferenceId": "setCreateConferenceReturn_id_5"});
      }

      expect(status, ConferenceStatus.created);

      await resetSDK();

      conference = Conference(
          "setCreateConferenceReturn_alias_6",
          "setCreateConferenceReturn_id_6",
          true,
          [],
          ConferenceStatus.created,
          SpatialAudioStyle.individual);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 6});

      status =
          await dolbyioCommsSdkFlutterPlugin.conference.getStatus(conference);

      if (Platform.isIOS) {
        await expectNative(
            methodChannel: conferenceServiceAssertsMethodChannel,
            assertLabel: "assertFetchConferenceArgs",
            expected: {"conferenceId": "setCreateConferenceReturn_id_6"});
      }

      expect(status, ConferenceStatus.destroyed);
    });

    testWidgets('ConferenceService: isMuted', (tester) async {
      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setIsMuted",
          args: {"isMuted": true});

      var isMuted = await dolbyioCommsSdkFlutterPlugin.conference.isMuted();

      expect(isMuted, true);

      await resetSDK();

      runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setIsMuted",
          args: {"isMuted": false});

      isMuted = await dolbyioCommsSdkFlutterPlugin.conference.isMuted();

      expect(isMuted, false);
    });

    testWidgets('ConferenceService: isSpeaking', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setIsSpeaking",
          args: {"isSpeaking": true});

      var isSpeaking =
          await dolbyioCommsSdkFlutterPlugin.conference.isSpeaking(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertIsSpeaking",
          expected: {"id": "participant_id_5_1"});

      expect(isSpeaking, true);

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.inactive,
          ParticipantType.user);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setIsSpeaking",
          args: {"isSpeaking": false});

      isSpeaking =
          await dolbyioCommsSdkFlutterPlugin.conference.isSpeaking(participant);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertIsSpeaking",
          expected: {"id": "participant_id_5_2"});

      expect(isSpeaking, false);
    });

    testWidgets('ConferenceService: setVideoForwarding', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      // ignore: deprecated_member_use
      await dolbyioCommsSdkFlutterPlugin.conference
          .setVideoForwarding(VideoForwardingStrategy.lastSpeaker, 1, [
        Participant(
            "participant_id_5_1",
            ParticipantInfo("participant_name", "avatar_url", "external_id"),
            ParticipantStatus.connected,
            ParticipantType.listner)
      ]);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertSetMaxVideoForwardingArgs",
          expected: {
            "max": 1,
            "prioritizedParticipants": {
              "id": "participant_id_5_1",
            }
          });
    });

    testWidgets('ConferenceService: setAudioProcessing', (tester) async {
      var audioProcessing = AudioProcessingOptions();
      audioProcessing.send = AudioProcessingSenderOptions();
      audioProcessing.send?.audioProcessing = true;

      await dolbyioCommsSdkFlutterPlugin.conference
          .setAudioProcessing(audioProcessing);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertSetAudioProcessing",
          expected: {"value": true});

      await resetSDK();

      audioProcessing = AudioProcessingOptions();
      audioProcessing.send = AudioProcessingSenderOptions();
      audioProcessing.send?.audioProcessing = false;

      await dolbyioCommsSdkFlutterPlugin.conference
          .setAudioProcessing(audioProcessing);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertSetAudioProcessing",
          expected: {"value": false});
    });

    testWidgets('ConferenceService: muteOutput', (tester) async {
      await dolbyioCommsSdkFlutterPlugin.conference.muteOutput(true);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertMuteOutputArgs",
          expected: {"isMuted": true});

      await resetSDK();

      await dolbyioCommsSdkFlutterPlugin.conference.muteOutput(false);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertMuteOutputArgs",
          expected: {"isMuted": false});
    });

    testWidgets('ConferenceService: updatePermissions', (tester) async {
      var participant = Participant(
          "participant_id_5_1",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      var conferencePermissions = [ConferencePermission.invite];
      var participantPermissions =
          ParticipantPermissions(participant, conferencePermissions);

      await dolbyioCommsSdkFlutterPlugin.conference
          .updatePermissions([participantPermissions]);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertUpdatePermissions",
          expected: {
            "updatePermissions": [
              {
                "participant": {"id": "participant_id_5_1"},
                "permissions": [0]
              }
            ]
          });

      await resetSDK();

      participant = Participant(
          "participant_id_5_2",
          ParticipantInfo("participant_name", "avatar_url", "external_id"),
          ParticipantStatus.connected,
          ParticipantType.listner);

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setCurrentConference",
          args: {"type": 5});

      conferencePermissions = [ConferencePermission.kick];
      participantPermissions =
          ParticipantPermissions(participant, conferencePermissions);

      await dolbyioCommsSdkFlutterPlugin.conference
          .updatePermissions([participantPermissions]);

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertUpdatePermissions",
          expected: {
            "updatePermissions": [
              {
                "participant": {"id": "participant_id_5_2"},
                "permissions": [1]
              }
            ]
          });
    });

    testWidgets('ConferenceService: listen', (tester) async {
      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setListenConferenceReturn",
          args: {"type": 1});

      await runNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          label: "setFetchConferenceReturn",
          args: {"type": 4});

      var conference = Conference(
          "conference_alias",
          "conference_id",
          true,
          [
            Participant(
                "participant_id",
                ParticipantInfo(
                    "participant_name", "avatar_url", "external_id"),
                ParticipantStatus.connected,
                ParticipantType.listner)
          ],
          ConferenceStatus.created,
          SpatialAudioStyle.individual);

      var conferenceListenOptions = ConferenceListenOptions();
      conferenceListenOptions.conferenceAccessToken = "conference_access_token";
      conferenceListenOptions.maxVideoForwarding = 15;
      conferenceListenOptions.spatialAudio = true;
      var returnedConference = await dolbyioCommsSdkFlutterPlugin.conference
          .listen(conference, conferenceListenOptions);

      if (Platform.isIOS) {
        await expectNative(
            methodChannel: conferenceServiceAssertsMethodChannel,
            assertLabel: "assertFetchConferenceArgs",
            expected: {"conferenceId": "conference_id"});
      }

      await expectNative(
          methodChannel: conferenceServiceAssertsMethodChannel,
          assertLabel: "assertListenConfrenceArgs",
          expected: {
            "conference": {
              "id": "setCreateConferenceReturn_id_4",
              "alias": "setCreateConferenceReturn_alias_4"
            },
            "listenOptions": {
              "conferenceAccessToken": "conference_access_token",
              "maxVideoForwarding": 15,
              "spatialAudio": true
            }
          });

      expect(returnedConference.id, "setCreateConferenceReturn_id_1");
      expect(returnedConference.alias, "setCreateConferenceReturn_alias_1");
    });
  });

  testWidgets('ConferenceService: onParticipantsChange', (tester) async {

    await runNative(
      methodChannel: conferenceServiceAssertsMethodChannel,
      label: "emitParticipantUpdatedEvents",
      args: { });

    List<Event<ConferenceServiceEventNames, Participant>> receivedEvents = [];
    await for (final event in dolbyioCommsSdkFlutterPlugin.conference.onParticipantsChange()) {
      receivedEvents.add(event);
      if (receivedEvents.length > 2) {
        break;
      }
    }

    expect(receivedEvents[0].body.id, "participant_id_6_1");
    expect(receivedEvents[1].body.id, "participant_id_6_2");
    expect(receivedEvents[2].body.id, "participant_id_6_1");
  });
}


const _conferenceStatusList = [
  ConferenceStatus.created,
  ConferenceStatus.creating,
  ConferenceStatus.destroyed,
  ConferenceStatus.ended,
  ConferenceStatus.error,
  ConferenceStatus.joined,
  ConferenceStatus.joining,
  ConferenceStatus.leaving,
  ConferenceStatus.left,
];

const _spatialAudioStyleList = [
  null,
  SpatialAudioStyle.individual,
  SpatialAudioStyle.shared,
  SpatialAudioStyle.disabled
];
