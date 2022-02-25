# ChartUI

A SwiftUI chart library.

## Usage

### Line chart

```swift
struct ContentView: View {
    let data = [
        Date.from(string: "01-01-2022") : CGFloat(990),
        Date.from(string: "02-01-2022") : CGFloat(1300),
        Date.from(string: "03-01-2022") : CGFloat(1200),
        Date.from(string: "04-01-2022") : CGFloat(600),
        Date.from(string: "05-01-2022") : CGFloat(500),
        Date.from(string: "06-01-2022") : CGFloat(650),
        Date.from(string: "07-01-2022") : CGFloat(1100)
    ]
    
    var body: some View {
        LineChartView(data: data)
            .frame(height: 250)
            .padding()
    }
}
``` 
