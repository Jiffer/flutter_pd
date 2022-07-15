package com.niusounds.flutter_pd

import org.puredata.core.PdListener
import java.io.File

/**
 * Interface to libpd.
 */
interface Pd {
    /**
     * [startService] is called and libpd service is running.
     */
    val isRunning: Boolean

    /**
     * [startService] is called but not started.
     */
    val isPreparing: Boolean

    /**
     * Starts libpd service.
     */
    fun startService(onStart: () -> Unit)

    /**
     * Stops libpd service.
     */
    fun stopService()

    /**
     * Initialize audio. If microphone is required to run patch, set [requireInput] to true.
     */
    fun initAudio(requireInput: Boolean)

    /**
     * Start audio processing.
     */
    fun startAudio()

    fun addToSearchPath(path: String)

    /**
     * Close file. Pass a value
     */
    fun closePatch(patchHandle: Int)

    /**
     * Open .pd file and return a handle to file.
     */
    fun openPatch(file: File): Int

    /**
     * Send a value to libpd.
     */
    fun send(receiver: String, value: Float)

    fun addListener(symbol: String, listener: PdListener)

    fun removeListener(symbol: String, listener: PdListener)

    /**
     * Releases resources held by native bindings (receiver objects and subscriptions, as well as
     * patches); otherwise, the state of Pd will remain unaffected.
     */
    fun release()
}
