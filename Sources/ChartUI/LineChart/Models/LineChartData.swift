import Foundation
import SwiftUI

public struct LineChartPlotData {
    var label: String
    var amount: CGFloat
    
    public init(label: String, amount: CGFloat) {
        self.label = label
        self.amount = amount
    }
}
