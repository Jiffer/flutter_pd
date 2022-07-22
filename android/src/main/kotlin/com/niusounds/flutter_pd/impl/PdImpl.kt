package com.niusounds.flutter_pd.impl

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import com.niusounds.flutter_pd.Pd
import com.niusounds.flutter_pd.exception.PdException
import org.puredata.android.service.PdService
import org.puredata.android.utils.PdUiDispatcher
import org.puredata.core.PdBase
import org.puredata.core.PdListener
import java.io.File

/**
 * Implementation of [Pd] that delegates to [PdBase].
 */
class PdImpl(private val context: Context) : Pd {
  private var onStart: (() -> Unit)? = null
  private var pdService: PdService? = null
  private val dispatcher = PdUiDispatcher()

  override val isRunning: Boolean
    get() = pdService != null

  override val isPreparing: Boolean
    get() = onStart != null

  private val serviceConnection = object : ServiceConnection {

    // PdService is started
    override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
      if (binder is PdService.PdBinder) {
        pdService = binder.service
        PdBase.setReceiver(dispatcher)
        onStart?.invoke()
        onStart = null
      }
    }

    override fun onServiceDisconnected(name: ComponentName?) {
      pdService = null
    }
  }

  override fun startService(onStart: () -> Unit) {
    if (isPreparing || isRunning) {
      throw PdException("Already started", "")
    }

    this.onStart = onStart
    context.bindService(Intent(context, PdService::class.java), serviceConnection, Context.BIND_AUTO_CREATE)
  }

  override fun stopService() {
    context.unbindService(serviceConnection)
    pdService = null
  }

  override fun initAudio(requireInput: Boolean) {
    if (requireInput) {
      pdService?.initAudio(-1, -1, -1, -1f)
    } else {
      pdService?.initAudio(-1, 0, -1, -1f)
    }
  }

  override fun startAudio() {
    pdService?.startAudio()
  }

  override fun addToSearchPath(path: String) {
    return PdBase.addToSearchPath(path)
  }

  override fun closePatch(patchHandle: Int) {
    return PdBase.closePatch(patchHandle)
  }

  override fun openPatch(file: File): Int {
    return PdBase.openPatch(file)
  }

  override fun send(receiver: String, value: Float) {
    val error = PdBase.sendFloat(receiver, value)
    if (error != 0) {
      throw PdException("send failed", "with error code $error")
    }
  }

  override fun addListener(symbol: String, listener: PdListener) {
    dispatcher.addListener(symbol, listener)
  }

  override fun removeListener(symbol: String, listener: PdListener) {
    dispatcher.removeListener(symbol, listener)
  }

  override fun release() {
    PdBase.release()
  }
}