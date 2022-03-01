import Foundation
import SwiftUI

final class LineChartViewModel: ObservableObject {
    @Published var data: [Date : CGFloat]
    @Published var points: [CGPoint] = []
    
    @Published var isPlotDetailsViewPresented: Bool = false
    @Published var selectedPlotValue: CGFloat = .zero
    
    @Published var selectedPlotViewOffset: CGFloat = .zero
    @Published var selectedPlotViewBarOffset: CGFloat = .zero
    
    @Published var playgroundSize: CGSize = .zero
    @Published var lineViewSize: CGSize = .zero
    @Published var plotDetailsViewSize: CGSize = .zero
    @Published var rightLabelsViewSize: CGSize = .zero
    
    var chartColor: Color {
        let values = data.sorted { $0.key < $1.key }.map {
            return $0.value
        }
        guard let firstValue = values.first, let lastValue = values.last else { return .green }
        return firstValue < lastValue ? .green : .red
    }
    
    init(data: [Date : CGFloat]) {
        self.data = data
    }
    
    func getPoints() {
        let values = data.sorted { $0.key < $1.key }.map {
            return $0.value
        }
        let maxPoint: Double = values.max() ?? 0
        
        self.points = values.enumerated().compactMap { (index, element) -> CGPoint in
            return CGPoint(x: Double(index) * playgroundSize.width / Double(data.values.count - 1),
                           y: -(element * playgroundSize.height / maxPoint) + playgroundSize.height)
        }
    }
}
