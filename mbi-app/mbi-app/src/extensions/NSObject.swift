//
//  NSObject.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/06/08.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

extension NSObject {
  func observer(for signal: NSNotification.Name, function selector: Selector) {
    NotificationCenter.default.addObserver(self, selector: selector, name: signal, object: nil)
  }

  func releaseObservers() {
    NotificationCenter.default.removeObserver(self)
  }

  func async(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
  }
}
