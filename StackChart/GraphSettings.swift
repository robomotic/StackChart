//
//  GraphSettings.swift
//  HeatSpot
//
//  Created by Paolo Di Prodi on 21/02/2016.
//  Copyright © 2016 Paolo Di Prodi. All rights reserved.
//

import UIKit
import SwiftCharts

struct GraphDefaults {
    
    static var chartSettings: ChartSettings {
        if Env.iPad {
            return self.iPadChartSettings
        } else {
            return self.iPhoneChartSettings
        }
    }
    
    private static var iPadChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 5
        chartSettings.trailing = 20
        chartSettings.bottom = 5
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 15
        chartSettings.spacingBetweenAxesY = 15
        return chartSettings
    }
    
    private static var iPhoneChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 0
        chartSettings.top = 0
        chartSettings.trailing = 0
        chartSettings.bottom = 0
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        return chartSettings
    }
    
    static func chartFrame(containerBounds: CGRect) -> CGRect {
        return CGRectMake(0, 70, containerBounds.size.width, containerBounds.size.height - 70)
    }
    
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: GraphDefaults.labelFont)
    }
    
    static var labelFont: UIFont {
        return GraphDefaults.fontWithSize(Env.iPad ? 14 : 11)
    }
    
    static func emptyFont() -> UIFont {
        return UIFont(name: "Helvetica", size: 0.0)!;
    }
    
    static var labelFontSmall: UIFont {
        return GraphDefaults.fontWithSize(Env.iPad ? 12 : 10)
    }
    
    static func fontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    static var guidelinesWidth: CGFloat {
        return Env.iPad ? 0.5 : 0.1
    }
    
    static var minBarSpacing: CGFloat {
        return Env.iPad ? 10 : 5
    }
    
    static var linesColor:UIColor{
        return UIColor.whiteColor()
    }
    
    static var labelsColor:UIColor{
        return UIColor.whiteColor()
    }
    
    static var maxColor:UIColor{
        return UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3)
    }
    
    static var minColor:UIColor{
        return UIColor(red: 0.0, green: 0.0, blue: 0.8, alpha: 0.3)
        
    }
    
}
