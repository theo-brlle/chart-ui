import XCTest
@testable import ChartUI

class LineChartViewModelWithOneLineTests: XCTestCase {
    // MARK: - Test `getPoints()` method

    func testGetPointsWithoutData() throws {
        // Given
        let data: [LineChartSimplePlotData] = []
        let lineChartViewModel = LineChartViewModel(type: .oneLine(data: data, detailsViewLabel: "PRICE"))
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)

        // When
        lineChartViewModel.getPoints()

        // Then
        let expectedResult: [CGPoint] = []
        XCTAssertEqual(lineChartViewModel.points.first, expectedResult)
    }

    func testGetPointsWithData() throws {
        // Given
        let data: [LineChartSimplePlotData] = [
            LineChartSimplePlotData(
                key: "Jan 1st, 2022",
                value: FormattedChartValue(value: CGFloat(0), formatted: "0 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 2nd, 2022",
                value: FormattedChartValue(value: CGFloat(25), formatted: "25 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 3rd, 2022",
                value: FormattedChartValue(value: CGFloat(100), formatted: "100 €")
            )
        ]
        let lineChartViewModel = LineChartViewModel(type: .oneLine(data: data, detailsViewLabel: "PRICE"))
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)

        // When
        lineChartViewModel.getPoints()

        // Then
        let expectedResult = [
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]
        XCTAssertEqual(lineChartViewModel.points.first, expectedResult)
    }

    func testGetPointsWithoutSpace() throws {
        // Given
        let data: [LineChartSimplePlotData] = [
            LineChartSimplePlotData(
                key: "Jan 1st, 2022",
                value: FormattedChartValue(value: CGFloat(0), formatted: "0 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 2nd, 2022",
                value: FormattedChartValue(value: CGFloat(25), formatted: "25 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 3rd, 2022",
                value: FormattedChartValue(value: CGFloat(100), formatted: "100 €")
            )
        ]
        let lineChartViewModel = LineChartViewModel(type: .oneLine(data: data, detailsViewLabel: "PRICE"))
        lineChartViewModel.playgroundSize = CGSize(width: 0, height: 0)

        // When
        lineChartViewModel.getPoints()

        // Then
        let expectedResult = [
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: 0.0)
        ]
        XCTAssertEqual(lineChartViewModel.points.first, expectedResult)
    }

    // MARK: - Test `updateSelectedPlot(from:)` method

    func testUpdateSelectedPlotCenter() throws {
        // Given
        let data: [LineChartSimplePlotData] = [
            LineChartSimplePlotData(
                key: "Jan 1st, 2022",
                value: FormattedChartValue(value: CGFloat(0), formatted: "0 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 2nd, 2022",
                value: FormattedChartValue(value: CGFloat(25), formatted: "25 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 3rd, 2022",
                value: FormattedChartValue(value: CGFloat(100), formatted: "100 €")
            )
        ]
        let lineChartViewModel = LineChartViewModel(type: .oneLine(data: data, detailsViewLabel: "PRICE"))
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        lineChartViewModel.plotDetailsViewSize = CGSize(width: 83, height: 55)
        lineChartViewModel.rightLabelsViewSize = CGSize(width: 41, height: 169)
        lineChartViewModel.points = [[
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]]


        // When
        lineChartViewModel.updateSelectedPlot(from: 137.5)

        // Then
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.label, "PRICE")
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.title, "25 €")
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.subTitle, "Jan 2nd, 2022")
        XCTAssertEqual(lineChartViewModel.selectedPlotViewBarOffset, 0)
        XCTAssertEqual(lineChartViewModel.selectedPlotViewOffset, 0)
    }

    func testUpdateSelectedPlotLeading() throws {
        // Given
        let data: [LineChartSimplePlotData] = [
            LineChartSimplePlotData(
                key: "Jan 1st, 2022",
                value: FormattedChartValue(value: CGFloat(0), formatted: "0 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 2nd, 2022",
                value: FormattedChartValue(value: CGFloat(25), formatted: "25 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 3rd, 2022",
                value: FormattedChartValue(value: CGFloat(100), formatted: "100 €")
            )
        ]
        let lineChartViewModel = LineChartViewModel(type: .oneLine(data: data, detailsViewLabel: "PRICE"))
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        lineChartViewModel.plotDetailsViewSize = CGSize(width: 83, height: 55)
        lineChartViewModel.rightLabelsViewSize = CGSize(width: 41, height: 169)
        lineChartViewModel.points = [[
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]]


        // When
        lineChartViewModel.updateSelectedPlot(from: 0)

        // Then
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.label, "PRICE")
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.title, "0 €")
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.subTitle, "Jan 1st, 2022")
        XCTAssertEqual(lineChartViewModel.selectedPlotViewBarOffset, -137.5)
        XCTAssertEqual(lineChartViewModel.selectedPlotViewOffset, -102)
    }

    func testUpdateSelectedPlotTrailing() throws {
        // Given
        let data: [LineChartSimplePlotData] = [
            LineChartSimplePlotData(
                key: "Jan 1st, 2022",
                value: FormattedChartValue(value: CGFloat(0), formatted: "0 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 2nd, 2022",
                value: FormattedChartValue(value: CGFloat(25), formatted: "25 €")
            ),
            LineChartSimplePlotData(
                key: "Jan 3rd, 2022",
                value: FormattedChartValue(value: CGFloat(100), formatted: "100 €")
            )
        ]
        let lineChartViewModel = LineChartViewModel(type: .oneLine(data: data, detailsViewLabel: "PRICE"))
        lineChartViewModel.playgroundSize = CGSize(width: 275, height: 169)
        lineChartViewModel.plotDetailsViewSize = CGSize(width: 83, height: 55)
        lineChartViewModel.rightLabelsViewSize = CGSize(width: 41, height: 169)
        lineChartViewModel.points = [[
            CGPoint(x: 0.0, y: 169.0),
            CGPoint(x: 137.5, y: 126.75),
            CGPoint(x: 275.0, y: 0.0)
        ]]


        // When
        lineChartViewModel.updateSelectedPlot(from: 275)

        // Then
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.label, "PRICE")
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.title, "100 €")
        XCTAssertEqual(lineChartViewModel.selectedPlotData?.subTitle, "Jan 3rd, 2022")
        XCTAssertEqual(lineChartViewModel.selectedPlotViewBarOffset, 137.5)
        XCTAssertEqual(lineChartViewModel.selectedPlotViewOffset, 143)
    }
}

extension LineChartSimplePlotData: Equatable {
    public static func == (lhs: LineChartSimplePlotData, rhs: LineChartSimplePlotData) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}
