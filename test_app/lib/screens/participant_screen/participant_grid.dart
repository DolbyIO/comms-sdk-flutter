import 'dart:async';
import 'package:dolbyio_comms_sdk_flutter_example/conference_ext.dart';
import 'package:flutter/material.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../../state_management/models/conference_model.dart';
import '/widgets/dialogs.dart';
import 'participant_widget.dart';
import 'dart:developer' as developer;

class ParticipantGrid extends StatefulWidget {
  const ParticipantGrid({Key? key}) : super(key: key);

  @override
  State<ParticipantGrid> createState() => _ParticipantGridState();
}

class _ParticipantGridState extends State<ParticipantGrid> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  List<Participant> participants = [];
  Participant? localParticipant;

  StreamSubscription<Event<ConferenceServiceEventNames, Participant>>?
      onParticipantsChangeSubscription;
  StreamSubscription<Event<ConferenceServiceEventNames, StreamsChangeData>>?
      onStreamsChangeSubscription;
  StreamSubscription<Event<CommandServiceEventNames, MessageReceivedData>>?
      onMessageReceivedChangeSubscription;

  Future<void> showDialog(
      BuildContext context, String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  @override
  void initState() {
    super.initState();
    initParticipantsList();
    getLocalParticipant();

    onParticipantsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
        .onParticipantsChange()
        .listen((params) {
      initParticipantsList();
      developer.log("onParticipantsChange");
    });

    onStreamsChangeSubscription = _dolbyioCommsSdkFlutterPlugin.conference
        .onStreamsChange()
        .listen((params) {
      initParticipantsList();
      developer.log("onStreamsChange");
    });

    onMessageReceivedChangeSubscription = _dolbyioCommsSdkFlutterPlugin.command
        .onMessageReceived()
        .listen((params) {
      showDialog(context, params.type.name, "Message: ${params.body.message}");
      developer.log("onMessageReceived");
    });
  }

  @override
  void dispose() {
    onParticipantsChangeSubscription?.cancel();
    onStreamsChangeSubscription?.cancel();
    onMessageReceivedChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isReplayConference =
        Provider.of<ConferenceModel>(context, listen: false).isReplayConference;

    return GridView.builder(
        itemCount: participants.length,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 160),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12),
        itemBuilder: (context, index) {
          var participant = participants[index];
          return ParticipantWidget(
            participant: participant,
            remoteOptionsFlag:
                localParticipant?.id == participant.id || isReplayConference
                    ? false
                    : true,
          );
        });
  }

  Future<void> getLocalParticipant() async {
    final localParticipant =
        await _dolbyioCommsSdkFlutterPlugin.conference.getLocalParticipant();
    setState(() => this.localParticipant = localParticipant);
  }

  Future<void> initParticipantsList() async {
    var isReplayConference =
        Provider.of<ConferenceModel>(context, listen: false).isReplayConference;
    late Conference conference;
    if (isReplayConference) {
      conference = Provider.of<ConferenceModel>(context, listen: false)
          .replayedConference;
    } else {
      Provider.of<ConferenceModel>(context, listen: false).updateConference();
      conference =
          Provider.of<ConferenceModel>(context, listen: false).conference;
    }

    final conferenceParticipants = await _dolbyioCommsSdkFlutterPlugin
        .conference
        .getParticipants(conference);
    conferenceParticipants.sort((item1, item2) {
      if (item1.status == ParticipantStatus.onAir ||
          item1.status == ParticipantStatus.connected) {
        return -1;
      } else if (item2.status == ParticipantStatus.onAir ||
          item2.status == ParticipantStatus.connected) {
        return 1;
      } else {
        return 0;
      }
    });
    setState(() => participants = conferenceParticipants.toList());
    return Future.value();
  }
}
