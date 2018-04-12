//
//  Error.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/04/03.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

enum ArgumentError: Error {
  case wrongType
  case outOfRange(maxRange: Int)
}
