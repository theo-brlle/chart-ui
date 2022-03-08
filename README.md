# ChartUI

A SwiftUI chart library.

## Installation

ChartUI is compatible with SPM and Cocoapods.

### SPM

Just add this repo as a dependency of your project. Here is the repo URL: https://github.com/theo-brlle/chart-ui.git

### Cocoapods

Add ChartUI as a dependency in your `Podfile`.

```
pod 'ChartUI', '~> 0.1.7'
```

Then run `pod install` and open the `.xcworkspace` file in Xcode.

## Sample usage 

### Line chart

First, import the library to you file.

```swift
import ChartUI
```

Then, create the data you want to display in the chart and create the `LineChartView`. Don't forget to give it a height with `.frame(height:)`. 

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
