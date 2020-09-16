//
//  PdEventListener.swift
//  flutter_pd
//
//  Created by Yuya Matsuo on 2020/09/17.
//

import libpd_ios

class PdEventListener: NSObject, PdListener {
  static var instances: [Int: PdEventListener] = [:]
  static func remove(id: Int) -> PdEventListener? {
    return instances.removeValue(forKey: id)
  }

  private let callback: (Any) -> Void

  init(id: Int, callback: @escaping (Any) -> Void) {
    self.callback = callback
    super.init()
    Self.instances[id] = self
  }

  func receiveMessage(
    _ message: String,
    withArguments arguments: [Any],
    fromSource source: String
  ) {
    callback([
      "type": "message",
      "from": source,
      "symbol": message,
      "args": arguments,
    ])
  }

  func receive(_ received: Float, fromSource source: String) {
    callback([
      "type": "float",
      "from": source,
      "value": received,
    ])
  }

  func receiveSymbol(_ symbol: String, fromSource source: String) {
    callback([
      "type": "symbol",
      "from": source,
      "value": symbol,
    ])
  }

  func receiveBang(fromSource source: String) {
    callback([
      "type": "bang",
      "from": source,
    ])
  }

  func receiveList(_ list: [Any], fromSource source: String) {
    callback([
      "type": "list",
      "from": source,
      "value": list,
    ])
  }
}
