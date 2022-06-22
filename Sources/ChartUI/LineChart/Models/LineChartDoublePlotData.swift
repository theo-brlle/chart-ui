import Foundation
import SwiftUI

public struct LineChartDoublePlotData {
    var key: String
    var firstValue: FormattedChartValue
    var secondValue: FormattedChartValue
    
    public init(key: String, firstValue: FormattedChartValue, secondValue: FormattedChartValue) {
        self.key = key
        self.firstValue = firstValue
        self.secondValue = secondValue
    }
}
