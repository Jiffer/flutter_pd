package com.niusounds.flutter_pd

import android.app.Activity
import androidx.annotation.NonNull
import com.niusounds.flutter_pd.impl.PdImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterPdPlugin */
class FlutterPdPlugin : FlutterPlugin, ActivityAware {
  private var flutterPd: FlutterPd? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val flutterPd = FlutterPd(
        context = flutterPluginBinding.applicationContext,
        assetPathResolver = flutterPluginBinding.asAssetPathResolver(),
        pd = PdImpl(flutterPluginBinding.applicationContext)
    )
    connect(flutterPluginBinding.binaryMessenger, flutterPd)
    this.flutterPd = flutterPd
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    private fun connect(binaryMessenger: BinaryMessenger, flutterPd: FlutterPd) {
      val handler = DartCallHandler(flutterPd)
      MethodChannel(binaryMessenger, "flutter_pd/method")
          .setMethodCallHandler(handler)
      EventChannel(binaryMessenger, "flutter_pd/event")
          .setStreamHandler(handler)
    }

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      FlutterPd(
          context = registrar.context(),
          assetPathResolver = registrar.asAssetPathResolver(),
          pd = PdImpl(registrar.context())
      ).let {
        connect(registrar.messenger(), it)

        it.activityBinding = object : ActivityPluginBinding {
          override fun removeOnSaveStateListener(listener: ActivityPluginBinding.OnSaveInstanceStateListener) {
            TODO("Not implemented")
          }

          override fun getActivity(): Activity = registrar.activity()

          override fun removeOnNewIntentListener(listener: PluginRegistry.NewIntentListener) {
            TODO("Not implemented")
          }

          override fun removeOnUserLeaveHintListener(listener: PluginRegistry.UserLeaveHintListener) {
            TODO("Not implemented")
          }

          override fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
            TODO("Not implemented")
          }

          override fun addRequestPermissionsResultListener(listener: PluginRegistry.RequestPermissionsResultListener) {
            registrar.addRequestPermissionsResultListener(listener)
          }

          override fun getLifecycle(): Any {
            TODO("Not implemented")
          }

          override fun addOnNewIntentListener(listener: PluginRegistry.NewIntentListener) {
            registrar.addNewIntentListener(listener)
          }

          override fun addOnUserLeaveHintListener(listener: PluginRegistry.UserLeaveHintListener) {
            registrar.addUserLeaveHintListener(listener)
          }

          override fun removeRequestPermissionsResultListener(listener: PluginRegistry.RequestPermissionsResultListener) {
            registrar.addRequestPermissionsResultListener(listener)
          }

          override fun addOnSaveStateListener(listener: ActivityPluginBinding.OnSaveInstanceStateListener) {
            TODO("Not implemented")
          }

          override fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
            registrar.addActivityResultListener(listener)
          }
        }
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    flutterPd?.dispose()
    flutterPd = null
  }

  override fun onDetachedFromActivity() {
    flutterPd?.activityBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    flutterPd?.activityBinding = binding
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    flutterPd?.activityBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    flutterPd?.activityBinding = null
  }
}
