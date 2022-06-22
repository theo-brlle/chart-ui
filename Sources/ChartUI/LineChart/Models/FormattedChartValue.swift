import SwiftUI

public struct FormattedChartValue: Comparable {
    var value: CGFloat
    var formatted: String
    
    public init(value: CGFloat, formatted: String) {
        self.value = value
        self.formatted = formatted
    }
    
    public static func < (lhs: FormattedChartValue, rhs: FormattedChartValue) -> Bool {
        lhs.value < rhs.value
    }
}
