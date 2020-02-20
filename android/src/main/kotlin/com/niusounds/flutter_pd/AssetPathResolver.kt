package com.niusounds.flutter_pd

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry

/**
 * Resolve asset path from Flutter to actual asset path in apk.
 */
interface AssetPathResolver {
  fun resolve(assetPath: String): String
}

fun FlutterPlugin.FlutterPluginBinding.asAssetPathResolver(): AssetPathResolver {
  return object : AssetPathResolver {
    override fun resolve(assetPath: String): String {
      return flutterAssets.getAssetFilePathByName(assetPath)
    }
  }
}

fun PluginRegistry.Registrar.asAssetPathResolver(): AssetPathResolver {
  return object : AssetPathResolver {
    override fun resolve(assetPath: String): String {
      return lookupKeyForAsset(assetPath)
    }
  }
}