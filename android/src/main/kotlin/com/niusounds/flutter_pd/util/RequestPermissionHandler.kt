package com.niusounds.flutter_pd.util

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.PluginRegistry

class RequestPermissionHandler(
    private val callback: (Boolean) -> Unit,
) : PluginRegistry.RequestPermissionsResultListener {
    private val RECORD_PERMISSION_REQUEST = 1000

    /**
     * Requests a permission to access to microphone.
     * @return Actually requested record permission.
     */
    fun requestPermission(activity: Activity): Boolean {
        // Check RECORD_AUDIO permission.
        return if (ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(Manifest.permission.RECORD_AUDIO),
                RECORD_PERMISSION_REQUEST
            )
            true
        } else {
            // RECORD_AUDIO permission is granted.
            callback(true)
            false
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        when (requestCode) {
            RECORD_PERMISSION_REQUEST -> {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // RECORD_AUDIO permission is granted.
                    callback(true)
                } else {
                    // RECORD_AUDIO permission is not granted.
                    callback(false)
                }
                return true
            }
        }

        return false
    }
}