//
//  ChartDefaults.swift
//  mbi-app
//
//  Created by 埜原菽也 on H30/03/17.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import UIKit
import SwiftCharts

struct ChartDefaults {

  fileprivate static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad

  static var chartSettings: ChartSettings {
    if isPad {
      return iPadChartSettings
    } else {
      return iPhoneChartSettings
    }
  }

  static var chartSettingsWithPanZoom: ChartSettings {
    if isPad {
      return iPadChartSettingsWithPanZoom
    } else {
      return iPhoneChartSettingsWithPanZoom
    }
  }

  fileprivate static var iPadChartSettings: ChartSettings {
    var chartSettings = ChartSettings()
    chartSettings.leading = 20
    chartSettings.top = 20
    chartSettings.trailing = 20
    chartSettings.bottom = 20
    chartSettings.labelsToAxisSpacingX = 10
    chartSettings.labelsToAxisSpacingY = 10
    chartSettings.axisTitleLabelsToLabelsSpacing = 5
    chartSettings.axisStrokeWidth = 1
    chartSettings.spacingBetweenAxesX = 15
    chartSettings.spacingBetweenAxesY = 15
    chartSettings.labelsSpacing = 0
    return chartSettings
  }

  fileprivate static var iPhoneChartSettings: ChartSettings {
    var chartSettings = ChartSettings()
    chartSettings.leading = 10
    chartSettings.top = 10
    chartSettings.trailing = 10
    chartSettings.bottom = 10
    chartSettings.labelsToAxisSpacingX = 5
    chartSettings.labelsToAxisSpacingY = 5
    chartSettings.axisTitleLabelsToLabelsSpacing = 4
    chartSettings.axisStrokeWidth = 0.2
    chartSettings.spacingBetweenAxesX = 8
    chartSettings.spacingBetweenAxesY = 8
    chartSettings.labelsSpacing = 0
    return chartSettings
  }

  fileprivate static var iPadChartSettingsWithPanZoom: ChartSettings {
    var chartSettings = iPadChartSettings
    chartSettings.zoomPan.panEnabled = true
    chartSettings.zoomPan.zoomEnabled = true
    return chartSettings
  }

  fileprivate static var iPhoneChartSettingsWithPanZoom: ChartSettings {
    var chartSettings = iPhoneChartSettings
    chartSettings.zoomPan.panEnabled = true
    chartSettings.zoomPan.zoomEnabled = true
    return chartSettings
  }

  static var labelSettings: ChartLabelSettings {
    return ChartLabelSettings(font: labelFont)
  }

  static var labelFont: UIFont {
    return fontWithSize(isPad ? 14 : 11)
  }

  static var labelFontSmall: UIFont {
    return fontWithSize(isPad ? 12 : 10)
  }

  static func fontWithSize(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFont(ofSize: size)
  }

  static var guidelinesWidth: CGFloat {
    return isPad ? 0.5 : 0.1
  }

  static var minBarSpacing: CGFloat {
    return isPad ? 10 : 5
  }
  
}
