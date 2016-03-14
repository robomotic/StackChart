//
//  ViewController.swift
//  StackChart
//
//  Created by Paolo Di Prodi on 11/03/2016.
//  Copyright © 2016 Paolo Di Prodi. All rights reserved.
//

import UIKit
import SwiftCharts

class ViewController: UIViewController {

    @IBOutlet weak var AreaPlotTemperature: ChartBaseView!
    @IBOutlet weak var AreaPlotHumidity: ChartBaseView!
    @IBOutlet weak var AreaPlotPressure: ChartBaseView!
    @IBOutlet weak var AreaPlotAirQuality: ChartBaseView!
    
    let daysindex:[Int:String] = [1: "Mon ",2:"Tue ",3:"Wed ",4:"Thu ",5:"Fri ",6:"Sat ",7:"Sun "]
    
    var chartTemperature: Chart!;
    var chartPressure: Chart!;
    var chartHumidity: Chart!;
    var chartQuaity: Chart!;
    
    
    private var didLayout: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        if !self.didLayout {
//            self.didLayout = true
//            self.drawTemperatureChart()
//            self.drawHumidityChart()
//            self.drawPressureChart()
//            self.drawAirQualityChart()
//        }
//    }
    
    override func viewDidAppear(animated: Bool) {
        // ## 7. Put initialisation in viewDidAppear, in this case size is not correct yet in viewDidLayoutSubviews apparently. Here you also don't need flag.
        self.drawTemperatureChart()
        self.drawHumidityChart()
        self.drawPressureChart()
        self.drawAirQualityChart()
    }

    func drawPressureChart(dayson:Bool=true)
    {
        // ## 9 because of this the x labels are not showing (seems intentional)
        let labelSettings_days = ChartLabelSettings(font: GraphDefaults.emptyFont(),fontColor: GraphDefaults.labelsColor,rotationKeep: .Top)
        
        let labelSettings_temp = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        let labelSettings_info = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        
        let chartPoints1 = [(1, 1000), (2, 1000), (3, 1200), (4, 1300),(5,1000),(6,1001),(7,1002)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueDouble($0.1))}
        
        let chartPoints2 = [(1, 999), (2, 998), (3, 1010), (4, 1012),(5,1001),(6,1001),(7,998)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueDouble($0.1))}
        
        let allChartPoints = (chartPoints1 + chartPoints2).sort {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        // ## 8 this is not filtering duplicates
        let xValues: [ChartAxisValue] = (NSOrderedSet(array: allChartPoints).array as! [ChartPoint]).map{$0.x}
        
        // ## 5 Bigger intervals, otherwise text overlaps
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 1, maxSegmentCount: 10, multiple: 1.0, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings_temp)}, addPaddingSegmentIfEdge: true)
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Pressure kPa", settings: labelSettings_info.defaultVertical()))
        
        // ## 1 with autolayout you have to use frame, use bounds
        // ## 2 don't use GraphDefaults.chartFrame, this shifts the bounds
        let chartFrame = AreaPlotPressure.bounds
        let chartSettings = GraphDefaults.chartSettings
        
        // ## 6 Add top padding
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.labelsToAxisSpacingX = 8
        chartSettings.labelsToAxisSpacingY = -8
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let c1 = GraphDefaults.maxColor
        let c2 = GraphDefaults.minColor
        
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: c1, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        
        let chartPointsLayer2 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints2, areaColor: c2, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel1, lineModel2])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: GraphDefaults.linesColor, linesWidth: GraphDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        
        self.chartPressure = Chart (view: AreaPlotPressure ,layers: [
            xAxis,
            yAxis,
            guidelinesLayer,
            chartPointsLayer1,
            chartPointsLayer2,
            chartPointsLineLayer
            ])
        
        // ## 4. (Temporary fix) set the background colour programatically. Correct fix is to remote UIColor.clearColor() from ChartBaseView, this should not be there.
        AreaPlotPressure.backgroundColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
    }
    
    func drawHumidityChart()
    {
        let labelSettings_days = ChartLabelSettings(font: GraphDefaults.emptyFont(),fontColor: GraphDefaults.labelsColor,rotationKeep: .Top)
        let labelSettings_temp = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        let labelSettings_info = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        
        
        let chartPoints1 = [(1, 0.50), (2, 0.51), (3, 0.54), (4, 0.60),(5,0.58),(6,0.54),(7,0.52)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueDouble($0.1))}
        let chartPoints2 = [(1, 0.50), (2, 0.49), (3, 0.48), (4, 0.51),(5,0.49),(6,0.50),(7,0.50)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueDouble($0.1))}
        
        let allChartPoints = (chartPoints1 + chartPoints2).sort {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        let xValues: [ChartAxisValue] = (NSOrderedSet(array: allChartPoints).array as! [ChartPoint]).map{$0.x}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 1, maxSegmentCount: 20, multiple: 0.1, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings_temp)}, addPaddingSegmentIfEdge: true)
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Humidity", settings: labelSettings_info.defaultVertical()))
        
        let chartFrame = GraphDefaults.chartFrame(AreaPlotHumidity.frame)
        let chartSettings = GraphDefaults.chartSettings
        
        chartSettings.trailing = 10
        chartSettings.labelsToAxisSpacingX = 8
        chartSettings.labelsToAxisSpacingY = -8
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let c1 = GraphDefaults.maxColor
        let c2 = GraphDefaults.minColor
        
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: c1, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let chartPointsLayer2 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints2, areaColor: c2, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel1, lineModel2])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: GraphDefaults.linesColor, linesWidth: GraphDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        
        
        self.chartHumidity = Chart (view: AreaPlotHumidity ,layers: [
            xAxis,
            yAxis,
            guidelinesLayer,
            chartPointsLayer1,
            chartPointsLayer2,
            chartPointsLineLayer
            ])
        
    }
    
    func drawAirQualityChart()
    {
        let labelSettings_days = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor,rotationKeep: .Top)
        let labelSettings_temp = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        let labelSettings_info = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        
        
        let chartPoints1 = [(1, 10), (2, 10), (3, 10), (4, 10),(5,10),(6,10),(7,10)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueInt($0.1))}
        let chartPoints2 = [(1, 9), (2, 9), (3, 9), (4, 9),(5,8),(6,8),(7,9)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueInt($0.1))}
        
        let allChartPoints = (chartPoints1 + chartPoints2).sort {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        let xValues: [ChartAxisValue] = (NSOrderedSet(array: allChartPoints).array as! [ChartPoint]).map{$0.x}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 1, maxSegmentCount: 10, multiple: 1, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings_temp)}, addPaddingSegmentIfEdge: true)
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Air quality", settings: labelSettings_info.defaultVertical()))
        
        let chartFrame = GraphDefaults.chartFrame(AreaPlotAirQuality.frame)
        let chartSettings = GraphDefaults.chartSettings
        
        chartSettings.trailing = 10
        chartSettings.labelsToAxisSpacingX = 8
        chartSettings.labelsToAxisSpacingY = -8
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let c1 = GraphDefaults.maxColor
        let c2 = GraphDefaults.minColor
        
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: c1, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let chartPointsLayer2 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints2, areaColor: c2, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel1, lineModel2])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: GraphDefaults.linesColor, linesWidth: GraphDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        
        
        self.chartQuaity = Chart (view: AreaPlotAirQuality, layers: [
            xAxis,
            yAxis,
            guidelinesLayer,
            chartPointsLayer1,
            chartPointsLayer2,
            chartPointsLineLayer
            ])
        
        
    }
    func drawTemperatureChart()
    {
        let labelSettings_days = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor,rotationKeep: .Top)
        let labelSettings_temp = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        let labelSettings_info = ChartLabelSettings(font: GraphDefaults.labelFont,fontColor: GraphDefaults.labelsColor)
        
        
        let chartPoints1 = [(1, 22), (2, 23), (3, 21), (4, 19),(5,20),(6,20),(7,21)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueInt($0.1))}
        let chartPoints2 = [(1, 18), (2, 16), (3, 16), (4, 17),(5,17),(6,18),(7,19)].map{ChartPoint(x: ChartAxisValueString(daysindex[$0.0]!, order:$0.0,labelSettings: labelSettings_days.defaultVertical()), y: ChartAxisValueInt($0.1))}
        
        let allChartPoints = (chartPoints1 + chartPoints2).sort {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        let xValues: [ChartAxisValue] = (NSOrderedSet(array: allChartPoints).array as! [ChartPoint]).map{$0.x}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 1, maxSegmentCount: 20, multiple: 5, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings_temp)}, addPaddingSegmentIfEdge: true)
        
        let xModel = ChartAxisModel(axisValues: xValues)
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Temperature C", settings: labelSettings_info.defaultVertical()))
        
        let chartFrame = GraphDefaults.chartFrame(self.AreaPlotTemperature.frame)
        
        let chartSettings = GraphDefaults.chartSettings
        
        chartSettings.trailing = 0
        chartSettings.labelsToAxisSpacingX = 8
        chartSettings.labelsToAxisSpacingY = -8
        
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let c1 = GraphDefaults.maxColor
        let c2 = GraphDefaults.minColor
        
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: c1, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let chartPointsLayer2 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints2, areaColor: c2, animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColor: GraphDefaults.linesColor, animDuration: 1, animDelay: 0)
        
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel1, lineModel2])
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: GraphDefaults.linesColor, linesWidth: GraphDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        
        
        self.chartTemperature = Chart (view: AreaPlotTemperature, layers: [
            xAxis,
            yAxis,
            guidelinesLayer,
            chartPointsLayer1,
            chartPointsLayer2,
            chartPointsLineLayer
            ])
    }
    
    func rotated() {
        // ## 3. this is being called at initialisation 2x so charts are drawn 3x each. If you need to handle rotation, add the rotation observer after everything is initialised.
//        for view in self.AreaPlotTemperature.subviews {
//            view.removeFromSuperview()
//        }
//        
//        for view in self.AreaPlotHumidity.subviews {
//            view.removeFromSuperview()
//        }
//        
//        for view in self.AreaPlotPressure.subviews {
//            view.removeFromSuperview()
//        }
//        
//        for view in self.AreaPlotAirQuality.subviews {
//            view.removeFromSuperview()
//        }
//        
//        self.drawTemperatureChart()
//        self.drawHumidityChart()
//        self.drawPressureChart()
//        self.drawAirQualityChart()
    }


}

