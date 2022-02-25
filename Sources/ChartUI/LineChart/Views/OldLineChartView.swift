import SwiftUI

public struct OldLineChartView: View {
    @State private var data: [CGFloat]
    
    @State var selectedPlot = "Test"
    
    @State var offset: CGSize = .zero
    
    @State var isPlotPresented = false
    
    public init(data: [CGFloat]) {
        self.data = data
    }
    
    public var body: some View {
        GeometryReader { container in
            let height = container.size.height
            let width = container.size.width / CGFloat(data.count - 1)
            
            let maxPoint = (data.max() ?? 0) + 100
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = item.element / maxPoint
                let pathHeight = progress * height
                let pathWidth = width * CGFloat(item.offset)
                
                return CGPoint(x: pathWidth, y: -pathHeight + height)
            }
            
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .fill(.green)
                
                LinearGradient(colors: [.green.opacity(0.3), .clear],
                               startPoint: .top,
                               endPoint: .bottom)
                    .clipShape(Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLines(points)
                        path.addLine(to: CGPoint(x: container.size.width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    })
            }
            .overlay(
                VStack(spacing: 0) {
                    Text(selectedPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.gray, in: RoundedRectangle(cornerRadius: 4))
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 2, height: 150)
                }
                .frame(width: 80, height: 200)
                .offset(offset)
                .opacity(isPlotPresented ? 1 : 0)
                , alignment: .bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            isPlotPresented = true
                            
                            data[8] = 1300
                        }
                        
                        let translation = value.location.x - 40
                        
                        let index = max(min(Int((translation / width).rounded() + 1), data.count - 1), 0)
                        
//                        selectedPlot = "$ \(data[index])"
                        
                        offset = CGSize(width: points[index].x - 20, height: 0)
                    }
                    .onEnded { value in
                        withAnimation {
                            isPlotPresented = false
                            
                            data[8] = 500
                        }
                    }
            )
        }
    }
}

struct OldLineChartView_Previews: PreviewProvider {
    static let data: [CGFloat] = [989, 1200, 750, 790, 650, 950, 1200, 600, 500, 600, 890, 1203, 1400, 900, 1250, 1600, 1200]
    
    static var previews: some View {
        OldLineChartView(data: data)
            .preferredColorScheme(.dark)
            .frame(height: 250)
            .padding(.horizontal)
    }
}
