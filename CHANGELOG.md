## 3.10.0

### Features

- Introduced the ability to change the [capture mode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setCaptureMode.html) in non-Dolby Voice conferences and use either the [Standard](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#standard) or [Unprocessed](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#unprocessed) mode.

- Introduced a new [voiceFont](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureOptions/voiceFont.html) property to [AudioCaptureOptions](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureOptions-class.html) that is supported in the [Standard](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#standard) audio capture mode. [Voice fonts](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureOptions/voiceFont.html) allow participants to modify their voices in real time to improve social interaction in entertainment scenarios. For more information about this feature, see the [Using Voice Fonts](https://docs.dolby.io/interactivity/docs/guides-using-voice-fonts) guide.

- Introduced a new [preview](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/preview.html) service that allows the local participant to test different capture modes and voice fonts before a conference. The service sets a preview recorder that records the participant's audio and plays it back. Before playing the recorded audio, set the [captureMode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setCaptureMode.html) to a preferred setting that you wish to try.

- Introduced a new [updateParticipantInfo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/SessionService/updateParticipantInfo.html) method that lets participants modify their names and avatars while they are in a conference.

- The SDK now supports receiving two shared screens in one conference.

### Changes

- Changed the default value of the audio capture mode in non-Dolby Voice conferences to [Standard](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#standard) with [high](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#high) noise reduction. This setting optimizes captured audio for speech by aggressively removing non-speech content. If you want to transmit non-stationary background sounds to a conference and create a more natural audio experience, you can set noise reduction to [low](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#low), which offers a similar experience as the default setting in previous releases. If you wish to transmit non-voice audio to a conference as well and use input device setting without any processing, use the [Unprocessed](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#unprocessed) mode.

- The [current](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/current.html) method now returns null when the user is not in a conference.

## 3.10.0-beta.1

### Features

- Introduced the ability to change the [capture mode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setCaptureMode.html) in non-Dolby Voice conferences and use either the [Standard](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#standard) or [Unprocessed](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#unprocessed) mode.

- Introduced a new [voiceFont](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureOptions/voicefont.html) property to [AudioCaptureOptions](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureOptions-class.html) that is supported in the [Standard](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#standard) audio capture mode. [Voice fonts](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureOptions/voicefont.html) allow participants to modify their voices in real time to improve social interaction in entertainment scenarios. For more information about this feature, see the [Using Voice Fonts](https://docs.dolby.io/interactivity/docs/guides-using-voice-fonts) guide.

- Introduced a new [preview](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/preview.html) service that allows the local participant to test different capture modes and voice fonts before a conference. The service records the participant's audio and plays it back. Before playing the recorded audio, set the [captureMode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setCaptureMode.html) to a preferred setting that you wish to try.

- Introduced a new [updateParticipantInfo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/SessionService/updateParticipantInfo.html) method that lets participants modify their names and avatars while they are in a conference.

- The SDK now supports receiving two shared screens in one conference.

### Changes

Changed the default value of the audio capture mode in non-Dolby Voice conferences to [Standard](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#standard) with [high](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#high) noise reduction. This setting optimizes captured audio for speech by aggressively removing non-speech content. If you want to transmit non-stationary background sounds to a conference and create a more natural audio experience, you can set noise reduction to [low](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#low), which offers a similar experience as the default setting in previous releases. If you wish to transmit non-voice audio to a conference as well and use input device setting without any processing, use the [Unprocessed](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html#unprocessed) mode.

## 3.8.3

### Bug Fixes

- Fixed an issue where a wrong recording status was reported by recording events.
- Fixed an issue where a conference invitation could not be accepted on Android devices.
- Corrected documentation for events in the notification service.

## 3.8.2

### Features

Added a new [ScaleType](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ScaleType.html) argument to the [VideoView](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoView-class.html) creation methods. The argument lets you select how you want to display a video stream in the VideoView area. You can either use the `fill` or `fit` value.

### Bug Fixes

Introduced improvements that prevent the [VideoViewController](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoViewController-class.html) from accessing unmounted [VideoView](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoView-class.html) widgets.

## 3.8.2-beta.2

### Features

Added a new [ScaleType](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ScaleType.html) argument to the [VideoView](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoView-class.html) creation methods. The argument lets you select how you want to display a video stream in the VideoView area. You can either use the `fill` or `fit` value.

## 3.8.2-beta.1

### Bug Fixes

Introduced improvements that prevent the [VideoViewController](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoViewController-class.html) from accessing unmounted [VideoView](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoView-class.html) widgets.

## 3.8.1

### Features

Introduced new methods and event handlers to the [NotificationService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NotificationService-class.html) that allow participants to [subscribe](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NotificationService/subscribe.html) to and [unsubscribe](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NotificationService/unsubscribe.html) from the preferred notifications.

## 3.8.1-beta.1

### Features

Introduced new methods and event handlers to the [NotificationService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NotificationService-class.html) that allow participants to [subscribe](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NotificationService/subscribe.html) to and [unsubscribe](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NotificationService/unsubscribe.html) from the preferred notifications.

## 3.8.0

### Features

Upgraded the WebRTC version to a recent version that contains improvements and bug fixes. The previously used version contains serious security vulnerabilities that can make your application susceptible to remote code execution, and can potentially give an attacker access to your application’s private data.

## 3.7.0

### Features

- Introduced a low noise reduction level available via a new [low](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#low) noise reduction setting. The existing [high](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#high) setting causes aggressive removal of background sounds from the captured audio. The [low](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#low) setting removes only stationary sounds, such as the sound of a computer fan, air conditioning, or microphone hum, and allows sending more ambient audio into a conference. This mode gives participants full context of other participants' environments and creates a more realistic audio experience. Setting the preferred [noise reduction](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html) level and [audio capture mode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html) is available via a new [setCaptureMode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio.html#setCaptureMode) method.

- Introduced DNN-based Noise Reduction (DNR) that improves voice clarity by reducing echo and background noises, such as keyboard typing noises and breathing sounds. This feature is based on a deep neural network and offers improved noise reduction to make virtual meetings more productive and pleasant.

- Introduced the [AudioService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioService-class.html), where the available APIs are divided into two models available via the AudioService: [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) and [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html). The [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) model offers APIs that allow the local participant to start and stop sending audio to a conference, set capture mode, and set comfort noise level. The [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html) model allows the local participant to stop receiving audio from selected remote participants.

- Introduced the [VideoService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoService-class.html), where the available APIs are divided into two models available via the VideoService: [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) and [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html). The [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) model offers APIs that allow the local participant to start and stop sending video to a conference. The [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html) model allows the local participant to stop receiving video streams from selected remote participants.

- Increased the [maximum number of video streams](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/setVideoForwarding.html) that may be transmitted to the local participant to 25.

### Deprecated APIs

Changes introduced in [AudioService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioService-class.html) and [VideoService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoService-class.html) impact the existing APIs that are no longer supported in SDK 3.7:
- The [startAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/startAudio.html) method is replaced with the **start** methods available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) and [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html) models.
- The [stopAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/stopAudio.html) method is replaced with the **stop** methods available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) and [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html) models.
- The [startVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/startVideo.html) method is replaced with the **start** methods available in the [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) and [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html) models.
- The [stopVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/stopVideo.html) method is replaced with the **stop** methods available in the [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) and [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html) models.
- The [setAudioProcessing](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/setAudioProcessing.html) method is replaced with the [setCaptureMode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setCaptureMode.html) method.
- The [setComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/MediaDeviceService/setComfortNoiseLevel.html) method is replaced with the [setComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setComfortNoiseLevel.html) method available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) model.
- The [getComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/MediaDeviceService/getComfortNoiseLevel.html) method is replaced with the [getComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/getComfortNoiseLevel.html) method available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) model.

## 3.7.0-beta.2

### Bug fixes

Fixed an issue where the [RecordingStatusUpdate](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RecordingStatusUpdate-class.html) events were not emitted on iOS.

## 3.7.0-beta.1

### Features

- Introduced a low noise reduction level available via a new [low](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#low) noise reduction setting. The existing [high](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#high) setting causes aggressive removal of background sounds from the captured audio. The [low](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html#low) setting removes only stationary sounds, such as the sound of a computer fan, air conditioning, or microphone hum, and allows sending more ambient audio into a conference. This mode gives participants full context of other participants' environments and creates a more realistic audio experience. Setting the preferred [noise reduction](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/NoiseReduction.html) level and [audio capture mode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioCaptureMode.html) is available via a new [setCaptureMode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio.html#setCaptureMode) method.

- Introduced DNN-based Noise Reduction (DNR) that improves voice clarity by reducing echo and background noises, such as keyboard typing noises and breathing sounds. This feature is based on a deep neural network and offers improved noise reduction to make virtual meetings more productive and pleasant.

- Introduced the [AudioService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioService-class.html), where the available APIs are divided into two models available via the AudioService: [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) and [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html). The [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) model offers APIs that allow the local participant to start and stop sending audio to a conference, set capture mode, and set comfort noise level. The [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html) model allows the local participant to stop receiving audio from selected remote participants.

- Introduced the [VideoService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoService-class.html), where the available APIs are divided into two models available via the VideoService: [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) and [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html). The [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) model offers APIs that allow the local participant to start and stop sending video to a conference. The [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html) model allows the local participant to stop receiving video streams from selected remote participants.

- Increased the [maximum number of video streams](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/setVideoForwarding.html) that may be transmitted to the local participant to 25.

### Deprecated APIs

Changes introduced in [AudioService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/AudioService-class.html) and [VideoService](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/VideoService-class.html) impact the existing APIs that are no longer supported in SDK 3.7:
- The [startAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/startAudio.html) method is replaced with the **start** methods available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) and [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html) models.
- The [stopAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/stopAudio.html) method is replaced with the **stop** methods available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) and [RemoteAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteAudio-class.html) models.
- The [startVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/startVideo.html) method is replaced with the **start** methods available in the [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) and [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html) models.
- The [stopVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/stopVideo.html) method is replaced with the **stop** methods available in the [LocalVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalVideo-class.html) and [RemoteVideo](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/RemoteVideo-class.html) models.
- The [setAudioProcessing](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/ConferenceService/setAudioProcessing.html) method is replaced with the [setCaptureMode](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setCaptureMode.html) method.
- The [setComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/MediaDeviceService/setComfortNoiseLevel.html) method is replaced with the [setComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/setComfortNoiseLevel.html) method available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) model.
- The [getComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/MediaDeviceService/getComfortNoiseLevel.html) method is replaced with the [getComfortNoiseLevel](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio/getComfortNoiseLevel.html) method available in the [LocalAudio](https://api-references.dolby.io/comms-sdk-flutter/dolbyio_comms_sdk_flutter/LocalAudio-class.html) model.

## 3.6.1

### Features

- Introduced SpatialAudioStyle that defines how the spatial location is communicated between SDK and the Dolby.io server.
- Introduced obfuscation rules to simplify the obfuscation of Android applications.

### Changes

- Deprecated the [setMaxVideoForwarding](./lib/src/sdk_api/conference_service.dart) method. To set Video Forwarding in this and later releases, use the [setVideoForwarding](./lib/src/sdk_api/conference_service.dart) method. 

### Bug fixes

- Fixed an issue where the conferenceAccessToken did not refresh correctly on Android.
- Fixed an issue where the updatePermissions method did not work correctly on Android.

## 3.6.0

### Features

Introduced the Flutter SDK that allows creating high-quality applications for video conferencing. With Flutter, you can write a single codebase in [Dart](https://dart.dev/) that you can natively compile and use for building, testing, and deploying applications across multiple platforms. Currently, the Flutter SDK supports creating applications for iOS and Android devices. The SDK offers the same [functionalities](https://docs.dolby.io/communications-apis/docs/overview-introduction) that are available in Android and iOS SDK.

## 3.6.0-beta.5

### Bug fixes

Fixed an issue that occurred on Android devices where participants who left a conference, closed a session, and rejoined the conference could not see themselves on the participants list.

## 3.6.0-beta.4

### Bug fixes

- Fixed an issue where the start and stop methods of the [VideoPresentationService](./lib/src/sdk_api/video_presentation_service.dart) did not work properly.
- Improved error reporting on iOS.
- Fixed a crash that occurred when accessing the current recording.
- Fixed an issue with converting files on iOS devices.
- Fixed an issue with receiving events from the [FilePresentationService](./lib/src/sdk_api/file_presentation_service.dart) and [VideoPresentationService](./lib/src/sdk_api/video_presentation_service.dart) on iOS devices.
- Added an option to switch speakers on Android devices.
- Unified error messages on iOS and Android devices.

## 3.6.0-beta.3

### Bug fixes:

Fixed an issue where the SDK required inheriting the Android activity provided by the plugin in order to share a screen.

## 3.6.0-beta.2

- Added support for [FilePresentationService](./lib/src/sdk_api/file_presentation_service.dart) on iOS devices

- Improved video stream management

## 3.6.0-beta.1

Introduced the Flutter SDK that supports creating high-quality video conferencing applications for iOS and Android devices.

## 0.0.1

Initial release