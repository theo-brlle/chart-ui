import Foundation
import SwiftUI

final class LineChartViewModel: ObservableObject {
    // MARK: - ViewModel's properties
    
    private(set) var type: LineChartType
    
    // MARK: - Observable properties
    
    @Published var points: [[CGPoint]] = []
    
    @Published var selectedPlotData: (label: String, title: String, subTitle: String)?
    
    @Published var isPlotDetailsViewPresented: Bool = false
    @Published var isErrorViewPresented: Bool = false
    
    @Published var selectedPlotViewOffset: CGFloat = .zero
    @Published var selectedPlotViewBarOffset: CGFloat = .zero
    
    @Published var plotDetailsViewSubtitleColor: Color = .secondaryLabel
    
    @Published var playgroundSize: CGSize = .zero
    @Published var lineViewSize: CGSize = .zero
    @Published var plotDetailsViewSize: CGSize = .zero
    @Published var rightLabelsViewSize: CGSize = .zero
    
    // MARK: - Callbacks
    
    var onDragAction: ((Bool) -> Void)?
    
    // MARK: - Computed properties
    
    var chartColor: Color {
        switch type {
        case .oneLine(let data, _):
            guard let firstAmount = data.first?.value, let lastAmount = data.last?.value else {
                return .green
            }
            
            return firstAmount <= lastAmount ? .green : .red
            
        case .twoLines(let data, _):
            guard let firstAmount = data.first?.firstValue, let lastAmount = data.last?.firstValue else {
                return .green
            }
            
            return firstAmount <= lastAmount ? .green : .red
        }
    }
    
    // MARK: - Init
    
    init(type: LineChartType) {
        self.type = type
    }
    
    // MARK: - Functions
    
    func getPoints() {
        switch type {
        case .oneLine(let data, _):
            guard data.count >= 2, !data.allSatisfy({ $0.value.value == 0 }) else {
                isErrorViewPresented = true
                return
            }
            
            let values: [CGFloat] = data.map { $0.value.value }
            let maxValue: CGFloat = values.max() ?? 0
            let minValue: CGFloat = values.allSatisfy { $0 == values.first } ? 0 : (values.min() ?? 0)
            
            guard maxValue - minValue != 0 else {
                isErrorViewPresented = true
                return
            }
            
            let points: [CGPoint] = values.enumerated().map { (index, value) -> CGPoint in
                let x: Double = Double(index) * playgroundSize.width / Double(data.count - 1)
                let preY: Double = (value - minValue) * playgroundSize.height / (maxValue - minValue)
                let y: Double = -preY + playgroundSize.height
                return CGPoint(x: x, y: y)
            }
            self.points.append(points)
            
        case .twoLines(let data, _):
            guard data.count >= 2,
                  !(data.allSatisfy { $0.firstValue.value == 0 } && data.allSatisfy { $0.secondValue.value == 0 }) else {
                isErrorViewPresented = true
                return
            }
            
            let firstValues: [CGFloat] = data.map { $0.firstValue.value }
            let secondValues: [CGFloat] = data.map { $0.secondValue.value }
            let maxValue: CGFloat = max(firstValues.max() ?? 0, secondValues.max() ?? 0)
            let minValue: CGFloat = min(firstValues.min() ?? 0, secondValues.min() ?? 0)
            
            guard maxValue - minValue != 0 else {
                isErrorViewPresented = true
                return
            }
            
            let firstLinePoints: [CGPoint] = firstValues.enumerated().map { (index, value) -> CGPoint in
                let x: Double = Double(index) * playgroundSize.width / Double(data.count - 1)
                let preY: Double = (value - minValue) * playgroundSize.height / (maxValue - minValue)
                let y: Double = -preY + playgroundSize.height
                return CGPoint(x: x, y: y)
            }
            
            let secondLinePoints: [CGPoint] = secondValues.enumerated().map { (index, value) -> CGPoint in
                let x: Double = Double(index) * playgroundSize.width / Double(data.count - 1)
                let preY: Double = (value - minValue) * playgroundSize.height / (maxValue - minValue)
                let y: Double = -preY + playgroundSize.height
                return CGPoint(x: x, y: y)
            }
            
            self.points.append(contentsOf: [
                firstLinePoints,
                secondLinePoints
            ])
        }
    }
    
    func updateSelectedPlot(from touchLocation: CGFloat) {
        guard let firstLinePoints: [CGPoint] = points.first else {
            return
        }
        
        let stepWidth: CGFloat = playgroundSize.width / CGFloat(firstLinePoints.count - 1)
        
        guard stepWidth > 0 else {
            return
        }
        
        let index: Int = Int(round(touchLocation / stepWidth))

        guard (0..<firstLinePoints.count).contains(index) else {
            return
        }
        
        switch type {
        case .oneLine(let data, let detailsViewLabel):
            selectedPlotData = (
                label: detailsViewLabel,
                title: data[index].value.formatted,
                subTitle: data[index].key
            )
        case .twoLines(let data, let detailsViewPercentageSuffix):
            let difference = data[index].firstValue.value - data[index].secondValue.value
            let percentage = difference * 100 / data[index].secondValue.value
            selectedPlotData = (
                label: data[index].key,
                title: data[index].firstValue.formatted,
                subTitle: String(
                    format: "%@%.1f%% %@",
                    data[index].firstValue.value < data[index].secondValue.value ? "" : "+",
                    percentage,
                    detailsViewPercentageSuffix
                )
            )
            plotDetailsViewSubtitleColor = data[index].firstValue.value < data[index].secondValue.value ? .red : .green
        }
        
        selectedPlotViewBarOffset = CGFloat(index) * stepWidth - playgroundSize.width / 2
        
        if selectedPlotViewBarOffset - plotDetailsViewSize.width / 2 < -(playgroundSize.width / 2) {
            selectedPlotViewOffset = -(playgroundSize.width / 2) + plotDetailsViewSize.width / 2 - 6
        } else if selectedPlotViewBarOffset + plotDetailsViewSize.width / 2 > playgroundSize.width / 2 + rightLabelsViewSize.width {
            selectedPlotViewOffset = playgroundSize.width / 2 - plotDetailsViewSize.width / 2 + rightLabelsViewSize.width + 6
        } else {
            selectedPlotViewOffset = selectedPlotViewBarOffset
        }
    }
}
