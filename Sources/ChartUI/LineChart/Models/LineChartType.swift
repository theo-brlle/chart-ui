import Foundation
import SwiftUI

public enum LineChartType {
    case oneLine(
        [Date : CGFloat]
    )
    case twoLines(
        [Date : CGFloat],
        [Date : CGFloat]
    )
    case threeLines(
        [Date : CGFloat],
        [Date : CGFloat],
        [Date : CGFloat]
    )
}
