import XCTest
@testable import ChartUI

class LineChartViewModelTests: XCTestCase {
    // MARK: - Test `getPoints()` method
    
    func testGetPointsWithoutData() throws {
        // Given
        let data: [LineChartPlotData] = []
        let lineChartViewModel = LineChartViewModel(data: data, type: .price)
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        
        // When
        lineChartViewModel.getPoints()
        
        // Then
        let expectedResult: [CGPoint] = []
        XCTAssertEqual(lineChartViewModel.points, expectedResult)
    }
    
    func testGetPointsWithData() throws {
        // Given
        let data: [LineChartPlotData] = [
            LineChartPlotData(label: "Jan 1, 2022", amount: 0),
            LineChartPlotData(label: "Jan 2, 2022", amount: 25),
            LineChartPlotData(label: "Jan 3, 2022", amount: 100)
        ]
        let lineChartViewModel = LineChartViewModel(data: data, type: .price)
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        
        // When
        lineChartViewModel.getPoints()
        
        // Then
        let expectedResult = [
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]
        XCTAssertEqual(lineChartViewModel.points, expectedResult)
    }
    
    func testGetPointsWithoutSpace() throws {
        // Given
        let data: [LineChartPlotData] = [
            LineChartPlotData(label: "Jan 1, 2022", amount: 0),
            LineChartPlotData(label: "Jan 2, 2022", amount: 25),
            LineChartPlotData(label: "Jan 3, 2022", amount: 100)
        ]
        let lineChartViewModel = LineChartViewModel(data: data, type: .price)
        lineChartViewModel.playgroundSize = CGSize(width: 0, height: 0)
        
        // When
        lineChartViewModel.getPoints()
        
        // Then
        let expectedResult = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 0.0)
        ]
        XCTAssertEqual(lineChartViewModel.points, expectedResult)
    }
    
    // MARK: - Test `updateSelectedPlot(from:)` method
    
    func testUpdateSelectedPlotCenter() throws {
        // Given
        let data: [LineChartPlotData] = [
            LineChartPlotData(label: "Jan 1, 2022", amount: 0),
            LineChartPlotData(label: "Jan 2, 2022", amount: 25),
            LineChartPlotData(label: "Jan 3, 2022", amount: 100)
        ]
        let lineChartViewModel = LineChartViewModel(data: data, type: .price)
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        lineChartViewModel.plotDetailsViewSize = CGSize(width: 83, height: 55)
        lineChartViewModel.rightLabelsViewSize = CGSize(width: 41, height: 169)
        lineChartViewModel.points = [
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]
        
        
        // When
        lineChartViewModel.updateSelectedPlot(from: 137.5)
        
        // Then
        XCTAssertEqual(lineChartViewModel.selectedPlotData, LineChartPlotData(label: "Jan 2, 2022", amount: 25))
        XCTAssertEqual(lineChartViewModel.selectedPlotViewBarOffset, 0)
        XCTAssertEqual(lineChartViewModel.selectedPlotViewOffset, 0)
    }
    
    func testUpdateSelectedPlotLeading() throws {
        // Given
        let data: [LineChartPlotData] = [
            LineChartPlotData(label: "Jan 1, 2022", amount: 0),
            LineChartPlotData(label: "Jan 2, 2022", amount: 25),
            LineChartPlotData(label: "Jan 3, 2022", amount: 100)
        ]
        let lineChartViewModel = LineChartViewModel(data: data, type: .price)
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        lineChartViewModel.plotDetailsViewSize = CGSize(width: 83, height: 55)
        lineChartViewModel.rightLabelsViewSize = CGSize(width: 41, height: 169)
        lineChartViewModel.points = [
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]
        
        
        // When
        lineChartViewModel.updateSelectedPlot(from: 0)
        
        // Then
        XCTAssertEqual(lineChartViewModel.selectedPlotData, LineChartPlotData(label: "Jan 1, 2022", amount: 0))
        XCTAssertEqual(lineChartViewModel.selectedPlotViewBarOffset, -137.5)
        XCTAssertEqual(lineChartViewModel.selectedPlotViewOffset, -102)
    }
    
    func testUpdateSelectedPlotTrailing() throws {
        // Given
        let data: [LineChartPlotData] = [
            LineChartPlotData(label: "Jan 1, 2022", amount: 0),
            LineChartPlotData(label: "Jan 2, 2022", amount: 25),
            LineChartPlotData(label: "Jan 3, 2022", amount: 100)
        ]
        let lineChartViewModel = LineChartViewModel(data: data, type: .price)
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        lineChartViewModel.plotDetailsViewSize = CGSize(width: 83, height: 55)
        lineChartViewModel.rightLabelsViewSize = CGSize(width: 41, height: 169)
        lineChartViewModel.points = [
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]
        
        
        // When
        lineChartViewModel.updateSelectedPlot(from: 275)
        
        // Then
        XCTAssertEqual(lineChartViewModel.selectedPlotData, LineChartPlotData(label: "Jan 3, 2022", amount: 100))
        XCTAssertEqual(lineChartViewModel.selectedPlotViewBarOffset, 137.5)
        XCTAssertEqual(lineChartViewModel.selectedPlotViewOffset, 143)
    }
}

extension LineChartPlotData: Equatable {
    public static func == (lhs: LineChartPlotData, rhs: LineChartPlotData) -> Bool {
        return lhs.label == rhs.label && lhs.amount.isEqual(to: rhs.amount)
    }
}
