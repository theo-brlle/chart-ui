# ChartUI

A SwiftUI chart library.

## Usage

### Line chart

```swift
struct ContentView: View {
    let data = [
        LineChartPlotData(label: "Jan 1st, 2022", amount: CGFloat(990)),
        LineChartPlotData(label: "Jan 2nd, 2022", amount: CGFloat(1300)),
        LineChartPlotData(label: "Jan 3rd, 2022", amount: CGFloat(1200)),
        LineChartPlotData(label: "Jan 4th, 2022", amount: CGFloat(600)),
        LineChartPlotData(label: "Jan 5th, 2022", amount: CGFloat(500)),
        LineChartPlotData(label: "Jan 6th, 2022", amount: CGFloat(600)),
        LineChartPlotData(label: "Jan 7th, 2022", amount: CGFloat(1100))
    ]
    
    var body: some View {
        LineChartView(data: data, type: .price)
            .frame(height: 250)
            .padding()
    }
}
``` 
