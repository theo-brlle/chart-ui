import Foundation
import SwiftUI

public struct LineChartSimplePlotData {
    var key: String
    var value: FormattedChartValue
    
    public init(key: String, value: FormattedChartValue) {
        self.key = key
        self.value = value
    }
}
