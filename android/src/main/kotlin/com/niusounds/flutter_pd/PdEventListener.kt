package com.niusounds.flutter_pd

import org.puredata.core.PdListener
import java.lang.ref.WeakReference

class PdEventListener(id: Int,
                      private val callback: (Any) -> Unit) : PdListener {
  companion object {
    private val instances = mutableMapOf<Int, WeakReference<PdEventListener>>()

    fun remove(id: Int): PdEventListener? {
      return instances.remove(id)?.get()
    }
  }

  init {
    instances[id] = WeakReference(this)
  }

  override fun receiveMessage(source: String, symbol: String, vararg args: Any?) {
    callback(mapOf(
        "type" to "message",
        "from" to source,
        "symbol" to symbol,
        "args" to args.asList()
    ))
  }

  override fun receiveFloat(source: String, x: Float) {
    callback(mapOf(
        "type" to "float",
        "from" to source,
        "value" to x
    ))
  }

  override fun receiveSymbol(source: String, symbol: String) {
    callback(mapOf(
        "type" to "symbol",
        "from" to source,
        "value" to symbol
    ))
  }

  override fun receiveBang(source: String) {
    callback(mapOf(
        "type" to "bang",
        "from" to source
    ))
  }

  override fun receiveList(source: String, vararg args: Any?) {
    callback(mapOf(
        "type" to "list",
        "from" to source,
        "value" to args.asList()
    ))
  }
}