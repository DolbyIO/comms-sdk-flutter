package io.dolby.comms.sdk.flutter.module

import com.voxeet.VoxeetSDK
import com.voxeet.sdk.json.internal.ParamsHolder
import com.voxeet.sdk.models.Conference
import com.voxeet.sdk.models.VideoForwardingStrategy
import com.voxeet.sdk.services.builders.ConferenceCreateOptions
import com.voxeet.sdk.services.builders.VideoForwardingOptions
import com.voxeet.sdk.services.conference.spatialisation.SpatialAudioStyle
import io.dolby.comms.sdk.flutter.extension.*
import io.dolby.comms.sdk.flutter.mapper.AudioProcessingMapper
import io.dolby.comms.sdk.flutter.mapper.ConferenceJoinOptionsMapper
import io.dolby.comms.sdk.flutter.mapper.ConferenceListenOptionsMapper
import io.dolby.comms.sdk.flutter.mapper.ConferenceMapper
import io.dolby.comms.sdk.flutter.mapper.ParticipantMapper
import io.dolby.comms.sdk.flutter.mapper.ParticipantPermissionsMapper
import io.dolby.comms.sdk.flutter.mapper.SpatialDirectionMapper
import io.dolby.comms.sdk.flutter.mapper.SpatialPositionMapper
import io.dolby.comms.sdk.flutter.mapper.SpatialScaleMapper
import io.dolby.comms.sdk.flutter.screenshare.ScreenShareHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope

class ConferenceServiceNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::create.name -> create(call, result)
            ::current.name -> current(result)
            ::fetch.name -> fetch(call, result)
            ::join.name -> join(call, result)
            ::listen.name -> listen(call, result)
            ::leave.name -> leave(result)
            ::getStatus.name -> getStatus(call, result)
            ::getAudioLevel.name -> getAudioLevel(call, result)
            ::getParticipant.name -> getParticipant(call, result)
            ::getParticipants.name -> getParticipants(call, result)
            ::isMuted.name -> isMuted(result)
            ::mute.name -> mute(call, result)
            ::muteOutput.name -> muteOutput(call, result)
            ::startAudio.name -> startAudio(call, result)
            ::stopAudio.name -> stopAudio(call, result)
            ::startVideo.name -> startVideo(call, result)
            ::stopVideo.name -> stopVideo(call, result)
            ::startScreenShare.name -> startScreenShare(result)
            ::stopScreenShare.name -> stopScreenShare(result)
            ::setSpatialPosition.name -> setSpatialPosition(call, result)
            ::setSpatialEnvironment.name -> setSpatialEnvironment(call, result)
            ::setSpatialDirection.name -> setSpatialDirection(call, result)
            ::getLocalStats.name -> getLocalStats(result)
            ::getMaxVideoForwarding.name -> getMaxVideoForwarding(result)
            ::setMaxVideoForwarding.name -> setMaxVideoForwarding(call, result)
            ::setVideoForwarding.name -> setVideoForwarding(call, result)
            ::setAudioProcessing.name -> setAudioProcessing(call, result)
            ::isSpeaking.name -> isSpeaking(call, result)
            ::replay.name -> replay(call, result)
            ::updatePermissions.name -> updatePermissions(call, result)
            ::kick.name -> kick(call, result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_conference_service_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
    }

    private fun create(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val params = HashMap<String, Any?>()
            call.argument<Map<String, Any>>("params")?.let { params.putAll(it) }

            val paramsHolder = ParamsHolder(params)

            call.argument<String>("spatialAudioStyle")?.let{
                paramsHolder.setSpatialAudioStyle(SpatialAudioStyle.valueOf(it))
            }

            val conferenceCreateOption = ConferenceCreateOptions.Builder()
                .setConferenceAlias(call.argument<String?>("alias"))
                .setParamsHolder(paramsHolder)
                .build()

            VoxeetSDK.conference().create(conferenceCreateOption).await().let {
                result.success(ConferenceMapper(it).convertToMap())
            }
        }
    )

    private fun current(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val conference = VoxeetSDK
                    .conference()
                    .conference
            if (conference != null && VoxeetSDK.conference().isInConference) {
                result.success(ConferenceMapper(conference).convertToMap())
            } else {
                result.success(null)
            }
        }
    )

    private fun fetch(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .conference()
                .fetchConference(call.argumentOrThrow("conferenceId"))
                .await()
                .let { conf -> ConferenceMapper(conf).convertToMap() }
                .let { result.success(it) }
        }
    )

    private fun join(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ConferenceJoinOptionsMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let {
                    val conference = VoxeetSDK.conference().join(it).await()
                    ConferenceMapper(conference).convertToMap()
                }
                ?.let { result.success(it) }
                ?: throw IllegalArgumentException("Could not map arguments")
        }
    )

    private fun listen(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ConferenceListenOptionsMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let {
                    val conference = VoxeetSDK.conference().listen(it).await()
                    ConferenceMapper(conference).convertToMap()
                }
                ?.let { result.success(it) }
                ?: throw IllegalArgumentException("Could not map arguments")
        }
    )

    private fun leave(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = { result.success(VoxeetSDK.conference().leave().await()) }
    )

    private fun getAudioLevel(call: MethodCall, result: Result) = try {
        call.argumentOrThrow<String>("id")
            .let { VoxeetSDK.conference().findParticipantById(it) }
            ?.let { VoxeetSDK.conference().audioLevel(it) }
            ?.let { result.success(it) }
            ?: throw IllegalStateException("Could not find participant")
    } catch (exception: Exception) {
        result.error(exception)
    }

    private fun getParticipant(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .conference()
                .participants
                .firstOrNull { it.id == call.argumentOrThrow("participantId") }
                ?.let { ParticipantMapper(it).convertToMap() }
                ?.let { result.success(it) }
                ?: throw IllegalStateException("Could not find participant")
        }
    )

    private fun getParticipants(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            call.argumentOrThrow<String>("id")
                .let { VoxeetSDK.conference().getConference(it).participants }
                .map { ParticipantMapper(it).convertToMap() }
                .let { result.success(it) }
        }
    )

    private fun getStatus(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            call.argumentOrThrow<String>("id")
                .let { VoxeetSDK.conference().getConference(it).state.name }
                .let { result.success(it) }
        }
    )

    private fun isMuted(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = { result.success(VoxeetSDK.conference().isMuted) }
    )

    private fun mute(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val muteValue = call.argument<Boolean?>("isMuted") ?: false
            val participant = call.argument<Map<String, Any?>?>("participant")
            participant?.let {
                val participantId = it["id"] as? String
                participantId?.let { id ->
                    VoxeetSDK
                        .conference()
                        .findParticipantById(id)
                        ?.let { VoxeetSDK.conference().mute(it, muteValue) }
                        ?: throw IllegalStateException("Could not find participant")
                }
            }.let {
                if (it != null && it) {
                    result.success(it)
                } else {
                    result.error(Exception("Call mute method failed"))
                }
            }
        }
    )

    private fun kick(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val participantId = call.argument<Map<Any, Any?>?>("id") as? String
            participantId?.let { id ->
                VoxeetSDK
                    .conference()
                    .findParticipantById(id)
                    ?.let { p -> VoxeetSDK.conference().kick(p).await() }
                    ?: throw IllegalStateException("Could not find participant")
            }.let { r -> result.success(r ?: false) }
        }
    )

    private fun muteOutput(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK
                .conference()
                .muteOutput(call.argumentOrThrow("isMuted"))
                .let {
                    if (it) {
                        result.success(it)
                    } else {
                        result.error(Exception("Call muteOutput method failed"))
                    }
                }
        }
    )

    private fun startAudio(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ParticipantMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let { VoxeetSDK.conference().startAudio(it).await() }
                ?.let { require(it) { "Could not start audio" } }
                ?: throw IllegalStateException("Could not find participant")
            result.success(null)
        }
    )

    private fun stopAudio(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ParticipantMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let { VoxeetSDK.conference().stopAudio(it).await() }
                ?.let { require(it) { "Could not stop audio" } }
                ?: throw IllegalStateException("Could not find participant")
            result.success(null)
        }
    )

    private fun startVideo(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ParticipantMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let { VoxeetSDK.conference().startVideo(it).await() }
                ?.let { require(it) { "Could not start video" } }
                ?: throw IllegalStateException("Could not find participant")
            result.success(null)
        }
    )

    private fun stopVideo(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            ParticipantMapper
                .fromMap(call.arguments as? Map<String, Any?>)
                ?.let { VoxeetSDK.conference().stopVideo(it).await() }
                ?.let { require(it) { "Could not stop video" } }
                ?: throw IllegalStateException("Could not find participant")
            result.success(null)
        }
    )

    private fun startScreenShare(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.screenShare().sendRequestStartScreenShare()
            ScreenShareHandler.permissionResult().await().let { result.success(it) }
        }
    )

    private fun stopScreenShare(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = { VoxeetSDK.screenShare().stopScreenShare().await().let { result.success(it) } }
    )

    private fun setSpatialPosition(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val participant = ParticipantMapper.fromMap(call.argument("participant"))
            val spatialPosition = SpatialPositionMapper.fromMap(call.argument("position"))
                ?: throw IllegalArgumentException("Spatial position was not provided")
            participant?.let {
                VoxeetSDK.conference().setSpatialPosition(participant, spatialPosition)
            } ?: VoxeetSDK.conference().setSpatialPosition(spatialPosition)
            result.success(null)
        }
    )

    private fun setSpatialEnvironment(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val scale = SpatialScaleMapper.fromMap(call.argument("scale"))
            val forward = SpatialPositionMapper.fromMap(call.argument("forward"))
            val up = SpatialPositionMapper.fromMap(call.argument("up"))
            val right = SpatialPositionMapper.fromMap(call.argument("right"))
            if (scale == null) {
                throw IllegalArgumentException("Spatial scale was not provided")
            }
            if (forward == null || up == null || right == null) {
                throw IllegalArgumentException("Spatial position was not provided")
            }
            VoxeetSDK.conference().setSpatialEnvironment(scale, forward, up, right)
            result.success(null)
        }
    )

    private fun setSpatialDirection(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val spatialDirection = SpatialDirectionMapper.fromMap(call.arguments())
                ?: throw IllegalArgumentException("Spatial direction was not provided")

            VoxeetSDK.conference().setSpatialDirection(spatialDirection)
            result.success(null)
        }
    )

    private fun getLocalStats(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            VoxeetSDK.conference().localStats()
                .let { it ->
                    val map = HashMap<String, String>()
                    it.forEach {
                        map[it.key] = it.value.toString()
                    }
                    result.success(map)
                }
        }
    )

    private fun setMaxVideoForwarding(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val max = call.argument<Int>("max")
            val prioritizedParticipants = call.argument<List<Any?>>("prioritizedParticipants")?.mapNotNull {
                ParticipantMapper.fromMap(it as Map<String, Any?>?)
            }
            if (max == null || prioritizedParticipants == null) {
                throw java.lang.IllegalArgumentException("At least one argument is missing: max: $max, prioritizedParticipants: $prioritizedParticipants")
            }
            VoxeetSDK
                .conference()
                .videoForwarding(max, prioritizedParticipants)
                .await()
                .let {
                    if (it) {
                        result.success(it)
                    } else {
                        result.error(Exception("Max video forwarding setting failed"))
                    }
                }
        }
    )

    private fun setVideoForwarding(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val strategy = call.argument<String>("strategy")?.let { VideoForwardingStrategy.valueOf(it) }
            val max = call.argument<Int>("max")
            val prioritizedParticipants = call.argument<List<Any?>>("prioritizedParticipants")?.mapNotNull {
                ParticipantMapper.fromMap(it as Map<String, Any?>?)?.id
            }
            if (max == null || prioritizedParticipants == null) {
                throw IllegalArgumentException("At least one argument is missing: max: $max, prioritizedParticipants: $prioritizedParticipants")
            }

            val videoForwardingOptions = VideoForwardingOptions.Builder()
                .setMaxVideoForwarding(max)
                .setParticipants(prioritizedParticipants)
                .apply { strategy?.let { setVideoForwardingStrategy(it) } }
                .build()

            VoxeetSDK
                .conference()
                .videoForwarding(videoForwardingOptions)
                .await()
                .let {
                    if (it) {
                        result.success(it)
                    } else {
                        result.error(Exception("Video forwarding setting failed"))
                    }
                }
        }
    )

    private fun getMaxVideoForwarding(result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = { result.success(VoxeetSDK.conference().maxVideoForwarding) }
    )

    private fun isSpeaking(call: MethodCall, result: Result) = try {
        call.argumentOrThrow<String>("id")
            .let { VoxeetSDK.conference().findParticipantById(it) }
            ?.let { VoxeetSDK.conference().isSpeaking(it) }
            ?.let { result.success(it) }
            ?: throw IllegalStateException("Could not find participant")
    } catch (exception: Exception) {
        result.error(exception)
    }

    private fun setAudioProcessing(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val audioProcessing = AudioProcessingMapper.fromMap(
                call.arguments()
                    ?: throw java.lang.IllegalArgumentException("Method params didn't match")
            )
            VoxeetSDK.conference().setAudioProcessing(audioProcessing).let { result.success(it) }
        }
    )

    private fun replay(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            val offset = call.argument<Int>("offset")?.toLong() ?: 0L
            val conferenceId = call.argumentOrThrow<Map<String, Any>>("conference")["id"] as String
            VoxeetSDK
                .conference()
                .getConference(conferenceId)
                .let { VoxeetSDK.conference().replay(it, offset).await() }
                .let { result.success(ConferenceMapper(it).convertToMap()) }
        }
    )

    private fun updatePermissions(call: MethodCall, result: Result) = scope.launch(
        onError = result::onError,
        onSuccess = {
            call.arguments<List<Any?>>()
                ?.mapNotNull { it?.let { ParticipantPermissionsMapper.fromMap(it as Map<String, Any?>) } }
                ?.let { VoxeetSDK.conference().updatePermissions(it).await()
                    result.success(null)
                }
                ?: throw IllegalArgumentException("Could not parse arguments")

        }
    )
}
