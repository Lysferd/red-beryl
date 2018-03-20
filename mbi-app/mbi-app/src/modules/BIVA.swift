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
//  var chartView: ChartView?

  let labelSettings = ChartLabelSettings(font: ChartDefaults.labelFont)
  let chartSettings = ChartDefaults.chartSettingsWithPanZoom

  init(view: UIView, model: [Impedance], height: Double) {

    // Define axis' layers
    let xValues = stride(from: 0, through: 8e3, by: 2e3).map {ChartAxisValueInt(Int($0), labelSettings: labelSettings)} //5e3 step 2e3
    let yValues = stride(from: 0, through: -11e3, by: -1e3).map {ChartAxisValueInt(Int($0), labelSettings: labelSettings)} // -10e3 step -1e3
    let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "R/H (Ω/m)", settings: labelSettings))
    let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Xc/H (Ω/m)", settings: labelSettings.defaultVertical()))

    let chartFrame = CGRect(x: 0, y: 0, width: view.bounds.width - 24, height: view.bounds.height - 12)
    let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
    let xAxisLayer = coordsSpace.xAxisLayer
    let yAxisLayer = coordsSpace.yAxisLayer
    let innerFrame = coordsSpace.chartInnerFrame

    let scatterLayers = drawLayers(frame: innerFrame, model: model, height: height, xAxis: xAxisLayer, yAxis: yAxisLayer)

    let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ChartDefaults.guidelinesWidth)
    let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: guidelinesLayerSettings)

    chart = Chart(
      frame: chartFrame,
      innerFrame: innerFrame,
      settings: chartSettings,
      layers: [ xAxisLayer, yAxisLayer, guidelinesLayer ] + scatterLayers
    )
  }

  fileprivate func drawLayers(frame: CGRect, model: [Impedance], height: Double, xAxis: ChartAxisLayer, yAxis: ChartAxisLayer) -> [ChartLayer] {

    // group chartpoints by type
    var chartPoints: [ChartPoint] = []
    let tapSettings = ChartPointsTapSettings()

    for impedance in model {
      let chartPoint = ChartPoint(x: ChartAxisValueDouble(impedance.real / height), y: ChartAxisValueDouble(impedance.imaginary / height))
      chartPoints.append(chartPoint)
    }

    let lineChartPoints = [ ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0)),
                            ChartPoint(x: ChartAxisValueDouble(model[0].real / height), y: ChartAxisValueDouble(model[0].imaginary / height)) ]
    let lineModel = ChartLineModel(chartPoints: lineChartPoints, lineColor: UIColor.black, lineWidth: 2, animDuration: 0.5, animDelay: 0.5)
    let lineLayer = ChartPointsLineLayer(xAxis: xAxis.axis, yAxis: yAxis.axis, lineModels: [lineModel])


    // create layer for each group
    let dim: CGFloat = 7
    let size = CGSize(width: dim, height: dim)
    let layer: ChartLayer = ChartPointsScatterCirclesLayer(xAxis: xAxis.axis,
                            yAxis: yAxis.axis,
                            chartPoints: chartPoints,
                            itemSize: size,
                            itemFillColor: UIColor.black,
                            tapSettings: tapSettings)

    return [layer, lineLayer]
  }

}
