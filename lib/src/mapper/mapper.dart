import 'package:dolbyio_comms_sdk_flutter/src/sdk_api/models/audio.dart';

import '../sdk_api/models/conference.dart';
import '../sdk_api/models/events.dart';
import '../sdk_api/models/file_presentation.dart';
import '../sdk_api/models/participant.dart';
import '../sdk_api/models/participant_info.dart';
import '../sdk_api/models/recording.dart';
import '../sdk_api/models/streams.dart';
import '../sdk_api/models/video_presentation.dart';

class ConferenceMapper {
  static Conference fromMap(Map<Object?, Object?> map) {
    var alias = map["alias"] as String?;
    var id = map.containsKey("id") ? map["id"] as String : null;
    var isNew = map.containsKey("isNew") ? map["isNew"] as bool : null;
    var participants = map.containsKey("participants")
        ? prepareParticipantsList(map["participants"] as List<Object?>)
        : List<Participant>.empty();
    var status =
        ConferenceStatus.decode(map["status"] as String? ?? "DEFAULT") ??
            ConferenceStatus.defaultStatus;
    var spatialAudioStyle =
        map.containsKey("spatialAudioStyle") && map["spatialAudioStyle"] != null
            ? SpatialAudioStyle.decode(map["spatialAudioStyle"] as String)
            : null;

    return Conference(
        alias, id, isNew, participants, status, spatialAudioStyle);
  }

  static List<Participant> prepareParticipantsList(List<Object?> participants) {
    return participants
        .map((e) => ParticipantMapper.fromMap(e as Map<Object?, Object?>))
        .toList();
  }
}

class ParticipantMapper {
  static Participant fromMap(Map<Object?, Object?> participant) {
    var id = participant.containsKey("id") ? participant["id"] as String : "";
    var info = participant.containsKey("info") && participant["info"] != null
        ? ParticipantInfoMapper.fromMap(
            participant["info"] as Map<Object?, Object?>)
        : null;
    var status = participant.containsKey("status")
        ? participant["status"] as String?
        : null;
    var type =
        participant.containsKey("type") ? participant["type"] as String : null;
    var streams = participant.containsKey("streams")
        ? (participant["streams"] as List<Object?>?)
            ?.map((e) => MediaStreamMapper.fromMap(e as Map<Object?, Object?>))
            .toList()
        : null;
    var result = Participant(id, info, ParticipantStatus.decode(status),
        ParticipantType.decode(type));
    result.streams = streams;
    return result;
  }
}

class ParticipantInfoMapper {
  static ParticipantInfo fromMap(Map<Object?, Object?> info) {
    String name = info.containsKey("name") && info["name"] != null
        ? info["name"] as String
        : "";
    var avatarUrl =
        info.containsKey("avatarUrl") ? info["avatarUrl"] as String? : null;
    var externalId =
        info.containsKey("externalId") ? info["externalId"] as String? : null;
    return ParticipantInfo(name, avatarUrl, externalId);
  }
}

class ParticipantInvitedMapper {
  static ParticipantInvited fromMap(Map<Object?, Object?> participant) {
    var info = ParticipantInfoMapper.fromMap(
        participant["info"] as Map<Object?, Object?>);
    var permissions = (participant["permisions"] as List<Object?>)
        .map((e) => ConferencePermission.decode(e as String));

    return ParticipantInvited(
        info, permissions.whereType<ConferencePermission>().toList());
  }
}

class InvitationReceivedNotificationMapper {
  static InvitationReceivedNotificationData fromMap(
      Map<Object?, Object?> invitiationEvent) {
    var conferenceAlias = invitiationEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = invitiationEvent["conferenceId"] as String;
    var conferenceToken = invitiationEvent["conferenceToken"] as String? ?? "";
    var participant = ParticipantMapper.fromMap(
        invitiationEvent["participant"] as Map<Object?, Object?>);
    return InvitationReceivedNotificationData(
        conferenceAlias, conferenceId, conferenceToken, participant);
  }
}

class ConferenceStatusNotificationMapper {
  static ConferenceStatusNotificationData fromMap(
      Map<Object?, Object?> conferenceStatusEvent) {
    var conferenceAlias =
        conferenceStatusEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = conferenceStatusEvent["conferenceId"] as String?;
    var live = conferenceStatusEvent["live"] as bool?;
    var participants = conferenceStatusEvent.containsKey("participants")
        ? prepareParticipantsList(
            conferenceStatusEvent["participants"] as List<Object?>)
        : List<Participant>.empty();
    return ConferenceStatusNotificationData(
        conferenceAlias, conferenceId, live, participants);
  }

  static List<Participant> prepareParticipantsList(List<Object?> participants) {
    return participants
        .map((e) => ParticipantMapper.fromMap(e as Map<Object?, Object?>))
        .toList();
  }
}

class ConferenceCreatedNotificationMapper {
  static ConferenceCreatedNotificationData fromMap(
      Map<Object?, Object?> conferenceCreatedEvent) {
    var conferenceAlias =
        conferenceCreatedEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = conferenceCreatedEvent["conferenceId"] as String;
    return ConferenceCreatedNotificationData(conferenceAlias, conferenceId);
  }
}

class ParticipantJoinedNotificationMapper {
  static ParticipantJoinedNotificationData fromMap(
      Map<Object?, Object?> participantJoinedEvent) {
    var conferenceAlias =
        participantJoinedEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = participantJoinedEvent["conferenceId"] as String;
    var participant = ParticipantMapper.fromMap(
        participantJoinedEvent["participant"] as Map<Object?, Object?>);
    return ParticipantJoinedNotificationData(
        conferenceAlias, conferenceId, participant);
  }
}

class ParticipantLeftNotificationMapper {
  static ParticipantLeftNotificationData fromMap(
      Map<Object?, Object?> participantLeftEvent) {
    var conferenceAlias =
        participantLeftEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = participantLeftEvent["conferenceId"] as String;
    var participant = ParticipantMapper.fromMap(
        participantLeftEvent["participant"] as Map<Object?, Object?>);
    return ParticipantLeftNotificationData(
        conferenceAlias, conferenceId, participant);
  }
}

class ConferenceEndedNotificationMapper {
  static ConferenceEndedNotificationData fromMap(
      Map<Object?, Object?> conferenceEndedEvent) {
    var conferenceAlias =
        conferenceEndedEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = conferenceEndedEvent["conferenceId"] as String;
    return ConferenceEndedNotificationData(conferenceAlias, conferenceId);
  }
}

class ActiveParticipantsNotificationMapper {
  static ActiveParticipantsNotificationData fromMap(
      Map<Object?, Object?> activeParticipantsEvent) {
    var conferenceAlias =
        activeParticipantsEvent["conferenceAlias"] as String? ?? "";
    var conferenceId = activeParticipantsEvent["conferenceId"] as String;
    var participantCount = activeParticipantsEvent["participantCount"] as int;
    var participants =
        (activeParticipantsEvent["participants"] as List<Object?>)
            .map((e) => ParticipantMapper.fromMap(e as Map<Object?, Object?>))
            .toList();
    return ActiveParticipantsNotificationData(
        conferenceAlias, conferenceId, participantCount, participants);
  }
}

class MessageReceivedMapper {
  static MessageReceivedData fromMap(Map<Object?, Object?> data) {
    var participant =
        ParticipantMapper.fromMap(data["participant"] as Map<Object?, Object?>);
    var message = data["message"] as String;
    return MessageReceivedData(message, participant);
  }
}

class PermissionsUpdatedMapper {
  static List<ConferencePermission> fromList(List<Object?> data) {
    return data
        .map((value) => ConferencePermission.decode(value as String))
        .toList();
  }
}

class VideoPresentationMapper {
  static VideoPresentation fromMap(Map<Object?, Object?> map) {
    var owner =
        ParticipantMapper.fromMap(map["owner"] as Map<Object?, Object?>);
    var timestamp = map.containsKey("timestamp") ? map["timestamp"] as num : 0;
    var url = map.containsKey("url") ? map["url"] as String : "";
    return VideoPresentation(owner, timestamp, url);
  }
}

class FilePresentationMapper {
  static FilePresentation fromMap(Map<Object?, Object?> map) {
    var id = map.containsKey("id") ? map["id"] as String : "";
    var imageCount =
        map.containsKey("imageCount") ? map["imageCount"] as int : 0;
    var position = map.containsKey("position") ? map["position"] as int : 0;
    var owner =
        ParticipantMapper.fromMap(map["owner"] as Map<Object?, Object?>);
    return FilePresentation(id, imageCount, owner, position);
  }
}

class FileConvertedMapper {
  static FileConverted fromMap(Map<Object?, Object?> map) {
    var id = map.containsKey("id") ? map["id"] as String : "";
    var imageCount =
        map.containsKey("imageCount") ? map["imageCount"] as int : 0;
    var name = map.containsKey("name") ? map["name"] as String? : null;
    var ownerId = map.containsKey("ownerId") ? map["ownerId"] as String? : null;
    var size = map.containsKey("size") ? map["size"] as num : null;
    return FileConverted(id, imageCount, name, ownerId, size);
  }
}

class RecordingInformationMapper {
  static RecordingInformation fromMap(Map<Object?, Object?> map) {
    final participantId = map.containsKey("participantId")
        ? map["participantId"] as String?
        : null;
    final startTimestamp = map.containsKey("startTimestamp")
        ? map["startTimestamp"] as num?
        : null;
    final status = map.containsKey("recordingStatus")
        ? map["recordingStatus"] as String?
        : null;
    return RecordingInformation(
      participantId: participantId,
      startTimestamp: startTimestamp,
      recordingStatus: RecordingStatus.decode(status),
    );
  }
}

class MediaStreamMapper {
  static MediaStream fromMap(Map<Object?, Object?> stream) {
    var id = stream["id"] as String;
    var type = stream["type"] as String;
    var label = stream["label"] as String;
    var audioTracks = toNoNullableList(stream["audioTracks"] as List<Object?>);

    var videoTracks = toNoNullableList(stream["videoTracks"] as List<Object?>);
    return MediaStream(
        id, MediaStreamType.decode(type)!, audioTracks, videoTracks, label);
  }
}

class AudioCaptureOptionsMapper {
  static AudioCaptureOptions fromMap(Map<Object?, Object?> stream) {
    var mode = stream["mode"] as String;
    var noiseReduction = stream["noiseReduction"] as String?;
    var voiceFont = stream["voiceFont"] as String?;
    return AudioCaptureOptions(
        AudioCaptureMode.decode(mode), NoiseReduction.decode(noiseReduction),
        voiceFont: VoiceFont.decode(voiceFont));
  }
}

List<Object> toNoNullableList(List<Object?> nullableList) {
  return nullableList.whereType<Object>().toList();
}
