package io.dolby.comms.sdk.flutter.events

import com.voxeet.VoxeetSDK
import com.voxeet.android.media.capture.audio.preview.AudioPreviewStatus

class AudioPreviewEventEmitter(eventChannelHandler: EventChannelHandler) : NativeEventEmitter(eventChannelHandler) {

    /**
     * Emitted when the application user received an audio preview status changed.
     */
    private val previewCallback: (AudioPreviewStatus) -> Unit = { status ->
        emit(OnStatusChanged, status.name)
    }

    override fun registerEventEmitter() {
        VoxeetSDK.audio().local.preview().onStatusChanged = previewCallback
    }

    override fun unregisterEventEmitter() {
        VoxeetSDK.audio().local.preview().onStatusChanged = null
    }

    companion object {
        const val OnStatusChanged = "EVENT_AUDIO_PREVIEW_STATUS_CHANGED"
    }
}