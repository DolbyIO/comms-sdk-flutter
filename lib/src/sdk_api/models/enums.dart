abstract class EnumWithStringValue implements Enum {
  abstract final String value;
}

/// The ComfortNoiseLevel enum gathers the available comfort noise levels.
///
/// {@category Models}
enum ComfortNoiseLevel {
  /// The default comfort noise level that is based on the device database. The database contains the proper comfort noise levels, individual for all devices.
  defaultLevel('default'),

  /// The low comfort noise level.
  low('low'),

  /// The medium comfort noise level.
  medium('medium'),

  /// The disabled comfort noise.
  off('off');

  final String _value;

  const ComfortNoiseLevel(this._value);

  static ComfortNoiseLevel decode(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return ComfortNoiseLevel.values.firstWhere(
      (element) => element._value == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }

  String encode() {
    return _value;
  }
}

/// The FilePresentationServiceEventNames enum gathers events informing about the file presentation status.
///
/// {@category Models}
enum FilePresentationServiceEventNames implements EnumWithStringValue {
  /// Emitted when a file is converted.
  fileConverted('EVENT_FILEPRESENTATION_FILE_CONVERTED'),

  /// Emitted when a presenter starts a file presentation.
  filePresentationStarted('EVENT_FILEPRESENTATION_STARTED'),

  /// Emitted when a presenter ends a file presentation.
  filePresentationStopped('EVENT_FILEPRESENTATION_STOPPED'),

  /// Emitted when a presenter changes the displayed page of the shared file.
  filePresentationUpdated('EVENT_FILEPRESENTATION_UPDATED');

  @override
  final String value;

  const FilePresentationServiceEventNames(this.value);

  static FilePresentationServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return FilePresentationServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The NotificationServiceEventNames enum gathers the NotificationService events.
///
/// {@category Models}
enum NotificationServiceEventNames implements EnumWithStringValue {
  /// Emitted when an application user receives an invitation.
  invitationReceived('EVENT_NOTIFICATION_INVITATION_RECEIVED'),

  /// Emitted when the application user subscribed to any notification.
  conferenceStatus('EVENT_NOTIFICATION_CONFERENCE_STATUS'),

  /// Emitted to notify an application user, who subscribed to conferenceCreated, that a new conference was created.
  conferenceCreated('EVENT_NOTIFICATION_CONFERENCE_CREATED'),

  /// Emitted to notify an application user, who subscribed to conferenceEnded, that a conference was ended.
  conferenceEnded('EVENT_NOTIFICATION_CONFERENCE_ENDED'),

  /// Emitted to notify an application user, who subscribed to activeParticipants, that a list of active participants is updated. The event informs how many participants joined a conference.
  activeParticipants('EVENT_NOTIFICATION_ACTIVE_PARTICIPANTS'),

  /// Emitted to notify an application user, who subscribed to participantJoined, that a new participant joined a conference.
  participantJoined("EVENT_NOTIFICATION_PARTICIPANT_JOINED"),

  /// Emitted to notify an application user, who subscribed to participantLeft, that a participant left a conference.
  participantLeft("EVENT_NOTIFICATION_PARTICIPANT_LEFT");

  @override
  final String value;

  const NotificationServiceEventNames(this.value);

  static NotificationServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return NotificationServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The CommandServiceEventNames enum gathers the CommandService events.
///
/// {@category Models}
enum CommandServiceEventNames implements EnumWithStringValue {
  /// Emitted when a participant receives a message.
  messageReceived('EVENT_COMMAND_MESSAGE_RECEIVED');

  @override
  final String value;

  const CommandServiceEventNames(this.value);

  static CommandServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return CommandServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The VideoPresentationState enum gathers the possible statuses of a video presentation.
///
/// {@category Models}
enum VideoPresentationState {
  /// The video presentation is paused.
  paused('paused'),

  /// The video presentation is played.
  play('play'),

  /// The video presentation is stopped.
  stopped('stopped');

  final String _value;

  const VideoPresentationState(this._value);

  static VideoPresentationState decode(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return VideoPresentationState.values.firstWhere(
      (element) => element._value.toLowerCase() == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The VideoPresentationEventNames enum gathers the possible statuses of a video presentation.
///
/// {@category Models}
enum VideoPresentationEventNames implements EnumWithStringValue {
  /// Emitted when a video presentation is paused.
  videoPresentationPaused('EVENT_VIDEOPRESENTATION_PAUSED'),

  /// Emitted when a video presentation is resumed.
  videoPresentationPlayed('EVENT_VIDEOPRESENTATION_PLAYED'),

  /// Emitted when a video presentation is sought.
  videoPresentationSought('EVENT_VIDEOPRESENTATION_SOUGHT'),

  /// Emitted when a video presentation is started.
  videoPresentationStarted('EVENT_VIDEOPRESENTATION_STARTED'),

  /// Emitted when a video presentation is stopped.
  videoPresentationStopped('EVENT_VIDEOPRESENTATION_STOPPED');

  @override
  final String value;

  const VideoPresentationEventNames(this.value);

  static VideoPresentationEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return VideoPresentationEventNames.values.firstWhere(
      (element) =>
          element.value == value ||
          element.name.toLowerCase() == lowerCaseValue,
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The RecordingServiceEventNames enum gathers the recording events.
///
/// {@category Models}
enum RecordingServiceEventNames implements EnumWithStringValue {
  /// Emitted when the recording state of the conference is updated from the remote location.
  recordingStatusUpdate('EVENT_RECORDING_STATUS_UPDATED');

  @override
  final String value;

  const RecordingServiceEventNames(this.value);

  static RecordingServiceEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return RecordingServiceEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}

/// The AudioPreviewEventNames enum gathers the AudioPreview events.
///
/// {@category Models}
enum AudioPreviewEventNames implements EnumWithStringValue {
  /// Emitted when the status of the audio preview changes.
  onStatusChanged('EVENT_AUDIO_PREVIEW_STATUS_CHANGED');

  @override
  final String value;

  const AudioPreviewEventNames(this.value);

  static AudioPreviewEventNames valueOf(String? value) {
    final lowerCaseValue = value?.toLowerCase();
    return AudioPreviewEventNames.values.firstWhere(
      (element) {
        return element.value == value ||
            element.name.toLowerCase() == lowerCaseValue;
      },
      orElse: () => throw Exception("Invalid enum name"),
    );
  }
}
