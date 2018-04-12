//
//  BIVA.swift
//  mbi-app
//
// Helper module to plot BIVA graph.
//
//  Created by 埜原菽也 on H30/03/17.
//  Copyright © 平成30年 M.A. Eng. All rights reserved.
//

import Foundation
import SwiftCharts

class BIVA {

  var chart: Chart?

  let labelSettings = ChartLabelSettings(font: ChartDefaults.labelFont)
  let chartSettings = ChartDefaults.chartSettingsWithPanZoom

  init(view: UIView, exam: Exam) {

    let model: [Impedance] = exam.corrected_impedances
    //print(model)

    // Define axis' layers
    let xRange = model[0].real * 2
    let xStep = xRange / 4
    let yRange = model[0].imaginary * 2
    let yStep = yRange / 4

    let xValues = stride(from: 0, through: xRange, by: xStep).map {ChartAxisValueInt(Int($0), labelSettings: labelSettings)}
    let yValues = stride(from: 0, through: yRange, by: yStep).map {ChartAxisValueInt(Int($0), labelSettings: labelSettings)}

    let xAxisTitleLabel = ChartAxisLabel(text: "R/H (Ω/m)", settings: labelSettings)
    let yAxisTitleLabel = ChartAxisLabel(text: "Xc/H (Ω/m)", settings: labelSettings.defaultVertical())
    let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: xAxisTitleLabel)
    let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: yAxisTitleLabel)

    let chartFrame = CGRect(x: 0, y: 0, width: view.bounds.width - 24, height: view.bounds.height - 12)
    let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
    let xAxisLayer = coordsSpace.xAxisLayer
    let yAxisLayer = coordsSpace.yAxisLayer
    let innerFrame = coordsSpace.chartInnerFrame

    let scatterLayers = drawLayers(frame: innerFrame, model: model, xAxis: xAxisLayer, yAxis: yAxisLayer)

    let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ChartDefaults.guidelinesWidth)
    let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)

    chart = Chart(
      frame: chartFrame,
      innerFrame: innerFrame,
      settings: chartSettings,
      layers: [ xAxisLayer, yAxisLayer, guidelinesLayer ] + scatterLayers
    )
  }

  fileprivate func drawLayers(frame: CGRect, model: [Impedance], xAxis: ChartAxisLayer, yAxis: ChartAxisLayer) -> [ChartLayer] {

    // group chartpoints by type
    var chartPoints: [ChartPoint] = []
    let tapSettings = ChartPointsTapSettings()

    for impedance in model {
      let chartPoint = ChartPoint(x: ChartAxisValueDouble(impedance.real), y: ChartAxisValueDouble(impedance.imaginary))
      chartPoints.append(chartPoint)
    }

    // create layer for each group
    let dim: CGFloat = 3
    let size = CGSize(width: dim, height: dim)
    let layer: ChartLayer = ChartPointsScatterCirclesLayer(xAxis: xAxis.axis,
                            yAxis: yAxis.axis,
                            chartPoints: chartPoints,
                            itemSize: size,
                            itemFillColor: UIColor.blue,
                            tapSettings: tapSettings)

    return [layer]
  }

}
