//
//  Segment.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/08.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation

enum Segment {
  case left_side
  case right_side
  case whole_body
}

struct Constants {
  static let segments: [String] = [
    "Lado Direito", "Lado Esquerdo"
  ]
}
