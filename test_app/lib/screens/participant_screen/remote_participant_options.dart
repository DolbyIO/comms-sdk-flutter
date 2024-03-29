import 'dart:convert';
import 'package:provider/provider.dart';
import '../../widgets/spatial_extensions/spatial_position_dialog_content.dart';
import '../../widgets/spatial_extensions/spatial_values_model.dart';
import 'package:dolbyio_comms_sdk_flutter/dolbyio_comms_sdk_flutter.dart';
import 'package:flutter/material.dart';
import '/widgets/dialogs.dart';
import 'permissions_list.dart';

class RemoteParticipantOptions extends StatefulWidget {
  final Participant participant;

  const RemoteParticipantOptions({Key? key, required this.participant})
      : super(key: key);

  @override
  State<RemoteParticipantOptions> createState() =>
      _RemoteParticipantOptionsState();
}

class _RemoteParticipantOptionsState extends State<RemoteParticipantOptions> {
  final _dolbyioCommsSdkFlutterPlugin = DolbyioCommsSdk.instance;
  List<ConferencePermission> permissionsList = [];
  bool isRemoteMuted = false;
  bool isAudioStarted = false;
  bool isVideoStarted = false;

  void updatePermissionsList(List<ConferencePermission> newPermissionsList) {
    setState(() {
      permissionsList = newPermissionsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        position: PopupMenuPosition.over,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 0,
              child: ListTile(
                  title: Text('Kick'),
                  leading: Icon(Icons.remove, color: Colors.deepPurple)),
            ),
            PopupMenuItem<int>(
              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
              value: 1,
              child: isRemoteMuted
                  ? const ListTile(
                      leading: Icon(Icons.mic_off, color: Colors.deepPurple),
                      title: Text('Unmute'))
                  : const ListTile(
                      leading: Icon(Icons.mic, color: Colors.deepPurple),
                      title: Text('Mute')),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 2,
              child: ListTile(
                title: Text('Update permissions'),
                leading: Icon(Icons.perm_camera_mic_outlined,
                    color: Colors.deepPurple),
              ),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 3,
              child: ListTile(
                  title: Text('Set spatial position'),
                  leading: Icon(Icons.spatial_audio, color: Colors.deepPurple)),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 4,
              child: ListTile(title: Text('Start audio')),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 5,
              child: ListTile(title: Text('Stop audio')),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 6,
              child: ListTile(title: Text('Start video')),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 7,
              child: ListTile(title: Text('Stop video')),
            ),
            const PopupMenuItem<int>(
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              value: 8,
              child: ListTile(title: Text('Get participant info')),
            ),
          ];
        },
        onSelected: (value) {
          switch (value) {
            case 0:
              kickParticipant();
              break;
            case 1:
              muteRemoteParticipant();
              break;
            case 2:
              showPermissionsDialog();
              break;
            case 3:
              showSpatialPositionDialog(context);
              break;
            case 4:
              startAudio();
              break;
            case 5:
              stopAudio();
              break;
            case 6:
              startVideo();
              break;
            case 7:
              stopVideo();
              break;
            case 8:
              getParticipantInfo(context);
              break;
          }
        });
  }

  Future<void> getParticipantInfo(BuildContext remoteParticipantContext) async {
    try {
      final participant = await _upToDateParticipant();
      await showDialogWindow(
          'Participant', jsonEncode(participant).toString());
    } catch (error) {
      showDialogWindow('Error', error.toString());
    }
  }

  Future<void> kickParticipant() async {
    final participant = await _upToDateParticipant();
    _dolbyioCommsSdkFlutterPlugin.conference.kick(participant);
  }

  Future<void> muteRemoteParticipant() async {
    final participant = await _upToDateParticipant();
    if (isRemoteMuted == false) {
      _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, true);
      setState(() => isRemoteMuted = true);
    } else {
      _dolbyioCommsSdkFlutterPlugin.conference.mute(participant, false);
      setState(() => isRemoteMuted = false);
    }
  }

  Future<void> startAudio() async {
    _dolbyioCommsSdkFlutterPlugin.audioService.remoteAudio.start(
      await _upToDateParticipant(),
    );
  }

  Future<void> stopAudio() async {
    _dolbyioCommsSdkFlutterPlugin.audioService.remoteAudio.stop(
      await _upToDateParticipant(),
    );
  }

  Future<void> startVideo() async {
    _dolbyioCommsSdkFlutterPlugin.videoService.remoteVideo.start(
      await _upToDateParticipant(),
    );
  }

  Future<void> stopVideo() async {
    _dolbyioCommsSdkFlutterPlugin.videoService.remoteVideo.stop(
      await _upToDateParticipant(),
    );
  }

  Future<void> updatePermissions() async {
    try {
      final participant = await _upToDateParticipant();
      await _dolbyioCommsSdkFlutterPlugin.conference.updatePermissions(
          [ParticipantPermissions(participant, permissionsList)]);
      await showDialogWindow('Success', "OK");
    } catch (error) {
      showDialogWindow('Error',
          "$error\nThis method is only available  for protected conferences");
    }
  }

  Future<void> showDialogWindow(String title, String text) async {
    await ViewDialogs.dialog(
      context: context,
      title: title,
      body: text,
    );
  }

  Future<Participant> _upToDateParticipant() async {
    return _dolbyioCommsSdkFlutterPlugin.conference
        .getParticipant(widget.participant.id);
  }

  Future<void> showPermissionsDialog() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update permissions"),
            actionsOverflowButtonSpacing: 20,
            content:
                PermissionsList(permissionsCallback: updatePermissionsList),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    updatePermissions();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Update")),
              ElevatedButton(
                  onPressed: () {
                    permissionsList.clear();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                  child: const Text("Cancel")),
            ],
          );
        });
  }

  Future<void> showSpatialPositionDialog(BuildContext remoteParticipantContext) async {
    final participant = await _upToDateParticipant();
    return await showDialog(
        context: remoteParticipantContext,
        builder: (BuildContext spatialPositionContext) {
          return AlertDialog(
            title: const Text("Spatial position"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<SpatialValuesModel>(
                    builder: (context, spatialValuesModel, child) {
                  return SpatialPositionDialogContent(
                      spatialValueDialogContext: spatialPositionContext,
                      participant: participant,
                      resultDialogContext: remoteParticipantContext,
                      spatialPosition: spatialValuesModel
                              .isSpatialConferenceState
                          ? spatialValuesModel.listOfParticipantSpatialValues
                              .where((element) => element.id == participant.id)
                              .first
                              .spatialPosition!
                          : spatialValuesModel.spatialPositionInNonSpatial);
                })
              ],
            ),
          );
        });
  }
}
