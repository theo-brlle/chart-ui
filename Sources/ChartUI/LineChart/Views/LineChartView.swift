import SwiftUI

public struct LineChartView: View {
    // MARK: - Observable properties
    
    @ObservedObject private var viewModel: LineChartViewModel
    
    // MARK: - Init
    
    public init(type: LineChartType) {
        viewModel = LineChartViewModel(type: type)
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                GeometryReader { geometry in
                    ZStack {
                        VStack(spacing: 10) {
                            Spacer()
                                .frame(height: viewModel.plotDetailsViewSize.height)
                            
                            ZStack {
                                ForEach(Array(
                                    viewModel.points.enumerated()).reversed(),
                                    id: \.offset
                                ) { index, points in
                                    gradientBackgroundView(color: index == 0 ? viewModel.chartColor : .gray)
                                        .clipShape(gradientBackgroundClipShape(points: points))
                                    
                                    lineView(
                                        points: points,
                                        color: index == 0 ? viewModel.chartColor : .gray
                                    )
                                    .border(width: 1, edges: [.bottom, .trailing], color: .systemGray3)
                                }
                            }
                        }
                        
                        plotDetailsView
                            .opacity(viewModel.isPlotDetailsViewPresented ? 1 : 0)
                    }
                    .onAppear {
                        viewModel.playgroundSize = CGSize(
                            width: geometry.size.width,
                            height: geometry.size.height - viewModel.plotDetailsViewSize.height - 10
                        )
                        viewModel.getPoints()
                    }
                    .gesture(dragGesture)
                }
                
                VStack(spacing: 10) {
                    Spacer()
                        .frame(height: viewModel.plotDetailsViewSize.height)
                    
                    switch viewModel.type {
                    case .oneLine(let data, _):
                        rightLabelsView(
                            topLabel: data.max(by: { $0.value < $1.value })?.value.formatted ?? "",
                            bottomLabel: data.min(by: { $0.value < $1.value })?.value.formatted ?? ""
                        )
                        
                    case .twoLines(let data, _):
                        let maxFirstValue = data.max(by: { $0.firstValue < $1.firstValue })?.firstValue
                        let maxSecondValue = data.max(by: { $0.secondValue < $1.secondValue })?.secondValue
                        let minFirstValue = data.min(by: { $0.firstValue < $1.firstValue })?.firstValue
                        let minSecondValue = data.min(by: { $0.secondValue < $1.secondValue })?.secondValue
                        rightLabelsView(
                            topLabel: max(
                                maxFirstValue ?? FormattedChartValue(value: 0, formatted: ""),
                                maxSecondValue ?? FormattedChartValue(value: 0, formatted: "")
                            ).formatted,
                            bottomLabel: min(
                                minFirstValue ?? FormattedChartValue(value: 0, formatted: ""),
                                minSecondValue ?? FormattedChartValue(value: 0, formatted: "")
                            ).formatted
                        )
                    }
                }
            }
            
            HStack {
                switch viewModel.type {
                case .oneLine(let data, _):
                    if let leadingLabel = data.first?.key, let trailingLabel = data.last?.key {
                        bottomLabelsView(leadingLabel: leadingLabel, trailingLabel: trailingLabel)
                    }
                    
                case .twoLines(let data, _):
                    if let leadingLabel = data.first?.key, let trailingLabel = data.last?.key {
                        bottomLabelsView(leadingLabel: leadingLabel, trailingLabel: trailingLabel)
                    }
                }
                
                Spacer()
                    .frame(width: viewModel.rightLabelsViewSize.width)
            }
        }
    }
}

// MARK: - Subviews

private extension LineChartView {
    func lineView(
        points: [CGPoint],
        color: Color
    ) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
        }
        .strokedPath(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        .fill(color)
        .saveSize(in: $viewModel.lineViewSize)
        .mask(alignment: .bottom) {
            Rectangle()
                .frame(height: viewModel.lineViewSize.height + viewModel.plotDetailsViewSize.height + 10)
        }
    }
    
    func gradientBackgroundView(color: Color) -> some View {
        LinearGradient(
            colors: [
                color.opacity(0.3),
                color.opacity(0.2),
                color.opacity(0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var plotDetailsView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(viewModel.selectedPlotData?.label ?? " ")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryLabel)
                
                Text(viewModel.selectedPlotData?.title ?? " ")
                    .font(.body)
                    .fontWeight(.bold)
                
                Text(viewModel.selectedPlotData?.subTitle ?? " ")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(viewModel.plotDetailsViewSubtitleColor)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 4).fill(Color.secondarySystemBackground))
            .saveSize(in: $viewModel.plotDetailsViewSize)
            .offset(x: viewModel.selectedPlotViewOffset)
            
            Rectangle()
                .fill(Color.systemGray2)
                .frame(width: 3)
                .frame(maxHeight: .infinity)
                .offset(x: viewModel.selectedPlotViewBarOffset)
        }
    }
    
    func bottomLabelsView(
        leadingLabel: String,
        trailingLabel: String
    ) -> some View {
        HStack {
            Text(leadingLabel)
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            
            Spacer()
            
            Text(trailingLabel)
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
        }
    }
    
    func rightLabelsView(
        topLabel: String,
        bottomLabel: String
    ) -> some View {
        VStack(alignment: .leading) {
            Text(topLabel)
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            
            Spacer()
            
            Text(bottomLabel)
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
        }
        .saveSize(in: $viewModel.rightLabelsViewSize)
    }
    
    func gradientBackgroundClipShape(points: [CGPoint]) -> some Shape {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(points)
            path.addLine(to: CGPoint(x: viewModel.playgroundSize.width, y: viewModel.playgroundSize.height))
            path.addLine(to: CGPoint(x: 0, y: viewModel.playgroundSize.height))
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                withAnimation {
                    viewModel.isPlotDetailsViewPresented = true
                }
                
                viewModel.updateSelectedPlot(from: value.location.x)
            }
            .onEnded { value in
                withAnimation {
                    viewModel.isPlotDetailsViewPresented = false
                }
            }
    }
}

// MARK: - Previews

struct LineChartView_Previews: PreviewProvider {
    static let oneLineData = [
        LineChartSimplePlotData(
            key: "Jan 1st, 2022",
            value: FormattedChartValue(value: CGFloat(990), formatted: "990 €")
        ),
        LineChartSimplePlotData(
            key: "Jan 2nd, 2022",
            value: FormattedChartValue(value: CGFloat(1300), formatted: "1 300 €")
        ),
        LineChartSimplePlotData(
            key: "Jan 3rd, 2022",
            value: FormattedChartValue(value: CGFloat(1200), formatted: "1 200 €")
        ),
        LineChartSimplePlotData(
            key: "Jan 4th, 2022",
            value: FormattedChartValue(value: CGFloat(600), formatted: "600 €")
        ),
        LineChartSimplePlotData(
            key: "Jan 5th, 2022",
            value: FormattedChartValue(value: CGFloat(500), formatted: "500 €")
        ),
        LineChartSimplePlotData(
            key: "Jan 6th, 2022",
            value: FormattedChartValue(value: CGFloat(600), formatted: "600 €")
        ),
        LineChartSimplePlotData(
            key: "Jan 7th, 2022",
            value: FormattedChartValue(value: CGFloat(1100), formatted: "1 100 €")
        )
    ]
    
    static let twoLinesData = [
        LineChartDoublePlotData(
            key: "Jan 1st, 2022",
            firstValue: FormattedChartValue(value: CGFloat(1200), formatted: "1 200 €"),
            secondValue: FormattedChartValue(value: CGFloat(800), formatted: "800 €")
        ),
        LineChartDoublePlotData(
            key: "Jan 2nd, 2022",
            firstValue: FormattedChartValue(value: CGFloat(1300), formatted: "1 300 €"),
            secondValue: FormattedChartValue(value: CGFloat(1000), formatted: "1 000 €")
        ),
        LineChartDoublePlotData(
            key: "Jan 3rd, 2022",
            firstValue: FormattedChartValue(value: CGFloat(1200), formatted: "1 200 €"),
            secondValue: FormattedChartValue(value: CGFloat(1250), formatted: "1 250 €")
        ),
        LineChartDoublePlotData(
            key: "Jan 4th, 2022",
            firstValue: FormattedChartValue(value: CGFloat(600), formatted: "600 €"),
            secondValue: FormattedChartValue(value: CGFloat(800), formatted: "800 €")
        ),
        LineChartDoublePlotData(
            key: "Jan 5th, 2022",
            firstValue: FormattedChartValue(value: CGFloat(500), formatted: "500 €"),
            secondValue: FormattedChartValue(value: CGFloat(500), formatted: "500 €")
        ),
        LineChartDoublePlotData(
            key: "Jan 6th, 2022",
            firstValue: FormattedChartValue(value: CGFloat(600), formatted: "600 €"),
            secondValue: FormattedChartValue(value: CGFloat(550), formatted: "550 €")
        ),
        LineChartDoublePlotData(
            key: "Jan 7th, 2022",
            firstValue: FormattedChartValue(value: CGFloat(1100), formatted: "1 100 €"),
            secondValue: FormattedChartValue(value: CGFloat(1150), formatted: "1 150 €")
        )
    ]

    static var previews: some View {
        LineChartView(type: .oneLine(data: oneLineData, detailsViewLabel: "PRICE"))
            .frame(height: 250)
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        
        LineChartView(type: .twoLines(data: twoLinesData, detailsViewPercentageSuffix: "vs LY"))
            .frame(height: 250)
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
