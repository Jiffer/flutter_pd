package com.niusounds.flutter_pd

import io.flutter.plugin.common.EventChannel

/**
 * Interface from Dart to native method calls.
 */
interface DartToNative {
  fun checkPermission(callback: (Boolean) -> Unit)

  fun startPd(callback: () -> Unit)

  fun stopPd()

  fun openAsset(assetName: String): Int

  fun close(patchHandle: Int)

  fun startAudio(requireInput: Boolean)

  fun send(receiver: String, value: Float)

  fun onListen(symbol: String, id: Int, callback: (Any) -> Unit)

  fun onCancel(symbol: String, id: Int)
}