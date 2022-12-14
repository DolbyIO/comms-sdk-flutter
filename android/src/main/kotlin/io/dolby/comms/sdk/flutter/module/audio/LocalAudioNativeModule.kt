package io.dolby.comms.sdk.flutter.module.audio

import com.voxeet.VoxeetSDK
import io.dolby.comms.sdk.flutter.extension.argumentOrThrow
import io.dolby.comms.sdk.flutter.extension.await
import io.dolby.comms.sdk.flutter.extension.error
import io.dolby.comms.sdk.flutter.extension.launch
import io.dolby.comms.sdk.flutter.mapper.AudioCaptureModeMapper
import io.dolby.comms.sdk.flutter.mapper.ComfortNoiseLevelMapper
import io.dolby.comms.sdk.flutter.module.NativeModule
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancelChildren

class LocalAudioNativeModule(private val scope: CoroutineScope) : NativeModule {

    private lateinit var channel: MethodChannel

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            ::getCaptureMode.name -> getCaptureMode(result)
            ::setCaptureMode.name -> setCaptureMode(call, result)
            ::setComfortNoiseLevel.name -> setComfortNoiseLevel(call, result)
            ::getComfortNoiseLevel.name -> getComfortNoiseLevel(result)
            ::start.name -> start(result)
            ::stop.name -> stop(call, result)
        }
    }

    override fun onAttached(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dolbyio_local_audio_channel")
        channel.setMethodCallHandler(this)
    }

    override fun onDetached() {
        channel.setMethodCallHandler(null)
        scope.coroutineContext.cancelChildren(null)
    }

    private fun getCaptureMode(result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            VoxeetSDK.audio().local.captureMode.let {
                result.success(AudioCaptureModeMapper(it).convertToMap())
            }
        }
    )

    private fun setCaptureMode(call: MethodCall, result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            VoxeetSDK.audio().local.captureMode = AudioCaptureModeMapper.fromMap(call.arguments as Map<String, Any?>)
            result.success(null)
        }
    )


    private fun getComfortNoiseLevel(result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            // TODO use local audio getComfortNoiseLevel method in next SDK version
            VoxeetSDK.mediaDevice().comfortNoiseLevel.let {
                result.success(ComfortNoiseLevelMapper.convertToString(it))
            }
        }
    )

    private fun setComfortNoiseLevel(call: MethodCall, result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            // TODO use local audio setComfortNoiseLevel method in next SDK version
            VoxeetSDK
                .mediaDevice()
                .setComfortNoiseLevel(ComfortNoiseLevelMapper.convertFromString(call.argumentOrThrow<String>("noiseLevel")))
                .also { result.success(null) }
        }
    )

    private fun start(result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            VoxeetSDK.audio().local.start().await()
                ?.let { require(it) { "Could not start audio" } }
                .also { result.success(null) }
        }
    )

    private fun stop(call: MethodCall, result: Result) = scope.launch(
        onError = result::error,
        onSuccess = {
            VoxeetSDK.audio().local.stop().await()
                ?.let { require(it) { "Could not stop audio" } }
                .also { result.success(null) }
        }
    )
}
