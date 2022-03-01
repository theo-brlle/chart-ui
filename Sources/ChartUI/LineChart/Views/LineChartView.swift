import SwiftUI

public struct LineChartView: View {
    @StateObject private var viewModel: LineChartViewModel
    
    public init(data: [Date : CGFloat]) {
        _viewModel = StateObject(wrappedValue: LineChartViewModel(data: data))
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
                Text("PRICE")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryLabel)
                
                Text("$\(Int(round(viewModel.selectedPlotValue)))K")
                    .font(.body)
                    .fontWeight(.bold)
                
                Text("18:00, sep 6th")
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
    
    var bottomLabelsView: some View {
        HStack {
            Text("00:00")
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            
            Spacer()
            
            Text("23:59")
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
        }
    }
    
    var rightLabelsView: some View {
        VStack(alignment: .leading) {
            Text("$1,500K")
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            
            Spacer()
            
            Text("$0")
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
                viewModel.isPlotDetailsViewPresented = true
                let touchLocation: CGFloat = value.location.x
                let stepWidth: CGFloat = viewModel.playgroundSize.width / CGFloat(viewModel.points.count - 1)
                let index: Int = Int(round(touchLocation / stepWidth))

                guard 0 <= index && index < viewModel.data.count else {
                    return
                }
                
                viewModel.selectedPlotValue = viewModel.data.sorted { $0.key < $1.key }.map {
                    return $0.value
                }[index]
                
                viewModel.selectedPlotViewBarOffset = CGFloat(index) * stepWidth - viewModel.playgroundSize.width / 2
                
                if viewModel.selectedPlotViewBarOffset - viewModel.plotDetailsViewSize.width / 2 < 0 - (viewModel.playgroundSize.width / 2) {
                    viewModel.selectedPlotViewOffset = 0 - (viewModel.playgroundSize.width / 2) + viewModel.plotDetailsViewSize.width / 2 - 6
                } else {
                    viewModel.selectedPlotViewOffset = viewModel.selectedPlotViewBarOffset
                }
            }
            .onEnded { value in
                viewModel.isPlotDetailsViewPresented = false
            }
    }
}

// MARK: - Preview

public extension Date {
    static func from(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: string) ?? Date()
    }
}


struct LineChartView_Previews: PreviewProvider {
    static let data = [
        Date.from(string: "01-01-2022") : CGFloat(990),
        Date.from(string: "02-01-2022") : CGFloat(1300),
        Date.from(string: "03-01-2022") : CGFloat(1200),
        Date.from(string: "04-01-2022") : CGFloat(600),
        Date.from(string: "05-01-2022") : CGFloat(500),
        Date.from(string: "06-01-2022") : CGFloat(600),
        Date.from(string: "07-01-2022") : CGFloat(1100),
        
//        Date.from(string: "08-01-2022") : CGFloat(990),
//        Date.from(string: "09-01-2022") : CGFloat(1300),
//        Date.from(string: "10-01-2022") : CGFloat(1200),
//        Date.from(string: "11-01-2022") : CGFloat(0),
//        Date.from(string: "12-01-2022") : CGFloat(500),
//        Date.from(string: "13-01-2022") : CGFloat(600),
//        Date.from(string: "14-01-2022") : CGFloat(1100),
//        Date.from(string: "15-01-2022") : CGFloat(990),
//        Date.from(string: "16-01-2022") : CGFloat(1300),
//        Date.from(string: "17-01-2022") : CGFloat(1200),
//        Date.from(string: "18-01-2022") : CGFloat(0),
//        Date.from(string: "19-01-2022") : CGFloat(500),
//        Date.from(string: "20-01-2022") : CGFloat(600),
//        Date.from(string: "21-01-2022") : CGFloat(1100),
//        Date.from(string: "22-01-2022") : CGFloat(990),
//        Date.from(string: "23-01-2022") : CGFloat(1300),
//        Date.from(string: "24-01-2022") : CGFloat(1200),
//        Date.from(string: "25-01-2022") : CGFloat(0),
//        Date.from(string: "26-01-2022") : CGFloat(500),
//        Date.from(string: "27-01-2022") : CGFloat(600),
//        Date.from(string: "28-01-2022") : CGFloat(1100)
    ]
    
    static var previews: some View {
        LineChartView(data: data)
            .frame(height: 250)
            .padding()
            .preferredColorScheme(.dark)
    }
}
