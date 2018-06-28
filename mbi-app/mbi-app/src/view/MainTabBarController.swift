//
//  MainTabBarController.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/04/26.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

  let hapticSelection = UISelectionFeedbackGenerator()

  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    hapticSelection.selectionChanged()
  }

}
