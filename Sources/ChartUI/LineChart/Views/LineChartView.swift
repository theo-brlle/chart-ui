import SwiftUI

public struct LineChartView: View {
    @ObservedObject private var viewModel: LineChartViewModel
    
    public init(data: [LineChartPlotData], type: LineChartDataType) {
        viewModel = LineChartViewModel(data: data, type: type)
    }
    
    public var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                GeometryReader { geometry in
                    ZStack {
                        VStack(spacing: 10) {
                            Spacer()
                                .frame(height: viewModel.plotDetailsViewSize.height)
                            
                            gradiantBackgroundView
                                .clipShape(gradiantBackgroundClipShape)
                        }
                        
                        VStack(spacing: 10) {
                            Spacer()
                                .frame(height: viewModel.plotDetailsViewSize.height)
                            
                            lineView
                                .border(width: 1, edges: [.bottom, .trailing], color: .systemGray3)
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
                    
                    rightLabelsView
                }
            }
            
            HStack {
                bottomLabelsView
                
                Spacer()
                    .frame(width: viewModel.rightLabelsViewSize.width)
            }
        }
    }
}

// MARK: - Subviews

private extension LineChartView {
    var lineView: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(viewModel.points)
        }
        .strokedPath(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        .fill(viewModel.chartColor)
        .saveSize(in: $viewModel.lineViewSize)
        .mask(alignment: .bottom) {
            Rectangle()
                .frame(height: viewModel.lineViewSize.height + viewModel.plotDetailsViewSize.height + 10)
        }
    }
    
    var gradiantBackgroundView: some View {
        LinearGradient(colors: [viewModel.chartColor.opacity(0.3), .clear],
                       startPoint: .top,
                       endPoint: .bottom)
    }
    
    var plotDetailsView: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(viewModel.type.localizedTitle.localized().uppercased())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryLabel)
                
                Text(viewModel.type.localizedFormatter.localized(withParameters: Int(round(viewModel.selectedPlotData?.amount ?? 0))))
                    .font(.body)
                    .fontWeight(.bold)
                
                Text(viewModel.selectedPlotData?.label ?? "")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryLabel)
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
    
    @ViewBuilder var bottomLabelsView: some View {
        if let firstLabel = viewModel.data.first?.label, let lastLabel = viewModel.data.last?.label {
            HStack {
                Text(firstLabel)
                    .font(.caption2)
                    .foregroundColor(.secondaryLabel)
                
                Spacer()
                
                Text(lastLabel)
                    .font(.caption2)
                    .foregroundColor(.secondaryLabel)
            }
        }
    }
    
    var rightLabelsView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.type.localizedFormatter.localized(withParameters: Int(round(viewModel.data.map { $0.amount }.max() ?? 0))))
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            
            Spacer()
            
            Text(viewModel.type.localizedFormatter.localized(withParameters: 0))
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
        }
        .saveSize(in: $viewModel.rightLabelsViewSize)
    }
    
    var gradiantBackgroundClipShape: some Shape {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLines(viewModel.points)
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

// MARK: - Preview

struct LineChartView_Previews: PreviewProvider {
    static let data = [
        LineChartPlotData(label: "Jan 1st, 2022", amount: CGFloat(990)),
        LineChartPlotData(label: "Jan 2nd, 2022", amount: CGFloat(1300)),
        LineChartPlotData(label: "Jan 3rd, 2022", amount: CGFloat(1200)),
        LineChartPlotData(label: "Jan 4th, 2022", amount: CGFloat(600)),
        LineChartPlotData(label: "Jan 5th, 2022", amount: CGFloat(500)),
        LineChartPlotData(label: "Jan 6th, 2022", amount: CGFloat(600)),
        LineChartPlotData(label: "Jan 7th, 2022", amount: CGFloat(1100))
    ]
    
    static var previews: some View {
        LineChartView(data: data, type: .price)
            .frame(height: 250)
            .padding()
            .preferredColorScheme(.dark)
    }
}
