package com.niusounds.flutter_pd

import android.content.Context
import com.niusounds.flutter_pd.exception.PdException
import com.niusounds.flutter_pd.util.RequestPermissionHandler
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.File
import java.io.IOException

class FlutterPd(private val context: Context,
                private val assetPathResolver: AssetPathResolver,
                private val pd: Pd) : DartToNative {
  var activityBinding: ActivityPluginBinding? = null

  fun dispose() {
    pd.release()
  }

  override fun onListen(symbol: String, id: Int, callback: (Any) -> Unit) {
    pd.addListener(symbol, PdEventListener(id, callback))
  }

  override fun onCancel(symbol: String, id: Int) {
    PdEventListener.remove(id)?.let { listener ->
      pd.removeListener(symbol, listener)
    }
  }

  override fun checkPermission(callback: (Boolean) -> Unit) {
    val activityBinding = this.activityBinding
        ?: throw PdException("Plugin is not bound to Flutter", "requestPermission failed")
    RequestPermissionHandler(callback).let {
      if (it.requestPermission(activityBinding.activity)) {
        activityBinding.addRequestPermissionsResultListener(it)
      }
    }
  }

  override fun startPd(callback: () -> Unit) {
    if (pd.isRunning || pd.isPreparing) {
      throw  PdException("Already started", "start is called more than twice")
    }
    pd.startService(callback)
  }

  override fun stopPd() {
    if (pd.isRunning) {
      pd.stopService()
    }
  }

  override fun openAsset(assetName: String): Int {
    try {
      val patchDir = File(context.cacheDir, "flutter_pd").also { if (!it.exists()) it.mkdirs() }
      val tmpFile = File(patchDir, "tmp.pd")
      context.assets.open(assetPathResolver.resolve(assetName)).use {
        it.copyTo(tmpFile.outputStream())
      }
      return pd.openPatch(tmpFile)
    } catch (e: IOException) {
      throw PdException("openAsset failed", e.message)
    }
  }

  override fun close(patchHandle: Int) {
    pd.closePatch(patchHandle)
  }

  override fun startAudio(requireInput: Boolean) {
    if (pd.isRunning.not()) {
      throw PdException("PdService is not started", "call start() first.")
    }

    return try {
      pd.initAudio(requireInput)
      pd.startAudio()
    } catch (e: Exception) {
      throw PdException("startAudio failed", e.message, null)
    }
  }

  override fun send(receiver: String, value: Float) {
    if (pd.isRunning.not()) {
      throw PdException("PdService is not started", "call start() first.")
    }

    pd.send(receiver, value)
  }
}