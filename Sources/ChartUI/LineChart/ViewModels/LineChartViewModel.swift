import Foundation
import SwiftUI

final class LineChartViewModel: ObservableObject {
    // MARK: - ViewModel's properties
    
    var data: [LineChartPlotData]
    var type: LineChartDataType
    
    // MARK: - Observable properties
    
    @Published var points: [CGPoint] = []
    
    @Published var selectedPlotData: LineChartPlotData?
    
    @Published var isPlotDetailsViewPresented: Bool = false
    
    @Published var selectedPlotViewOffset: CGFloat = .zero
    @Published var selectedPlotViewBarOffset: CGFloat = .zero
    
    @Published var playgroundSize: CGSize = .zero
    @Published var lineViewSize: CGSize = .zero
    @Published var plotDetailsViewSize: CGSize = .zero
    @Published var rightLabelsViewSize: CGSize = .zero
    
    // MARK: - Computed properties
    
    var chartColor: Color {
        guard let firstAmount = data.first?.amount, let lastAmount = data.last?.amount else {
            return .green
        }
        
        return firstAmount < lastAmount ? .green : .red
    }
    
    // MARK: - Init
    
    init(data: [LineChartPlotData], type: LineChartDataType) {
        self.data = data
        self.type = type
    }
    
    // MARK: - Functions
    
    func getPoints() {
        let amounts: [CGFloat] = data.map { $0.amount }
        let maxAmount: CGFloat = amounts.max() ?? 0
        
        self.points = amounts.enumerated().compactMap { (index, amount) -> CGPoint in
            let x: Double = Double(index) * playgroundSize.width / Double(data.count - 1)
            let y: Double = -(amount * playgroundSize.height / maxAmount) + playgroundSize.height
            return CGPoint(x: x, y: y)
        }
    }
    
    func updateSelectedPlot(from touchLocation: CGFloat) {
        let stepWidth: CGFloat = playgroundSize.width / CGFloat(points.count - 1)
        let index: Int = Int(round(touchLocation / stepWidth))

        guard (0..<data.count).contains(index) else {
            return
        }
        
        selectedPlotData = data[index]
        
        selectedPlotViewBarOffset = CGFloat(index) * stepWidth - playgroundSize.width / 2
        
        if selectedPlotViewBarOffset - plotDetailsViewSize.width / 2 < -(playgroundSize.width / 2) {
            selectedPlotViewOffset = -(playgroundSize.width / 2) + plotDetailsViewSize.width / 2 - 6
        } else {
            selectedPlotViewOffset = selectedPlotViewBarOffset
        }
    }
}
