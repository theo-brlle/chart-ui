# ChartUI

A SwiftUI chart library.

## Installation

ChartUI is compatible with SPM and Cocoapods.

### SPM

Just add this repo as a dependency of your project. Here is the repo URL: https://github.com/theo-brlle/chart-ui.git

### Cocoapods

Add ChartUI as a dependency in your `Podfile`.

```
pod 'ChartUI', '~> 0.4.0'
```

Then run `pod install` and open the `.xcworkspace` file in Xcode.

## Sample usage 

### Line chart (with one line)

First, import the library to your file.

```swift
import ChartUI
```

Then, create the data you want to display in the chart and create the `LineChartView`.
Don't forget to give it a height with `.frame(height:)`. 

```swift
struct ContentView: View {
    let data = [
        LineChartSimplePlotData(key: "Jan 1st, 2022", value: FormattedChartValue(value: CGFloat(990), formatted: "990 €")),
        LineChartSimplePlotData(key: "Jan 2nd, 2022", value: FormattedChartValue(value: CGFloat(1300), formatted: "1 300 €")),
        LineChartSimplePlotData(key: "Jan 3rd, 2022", value: FormattedChartValue(value: CGFloat(1200), formatted: "1 200 €")),
        LineChartSimplePlotData(key: "Jan 4th, 2022", value: FormattedChartValue(value: CGFloat(600), formatted: "600 €")),
        LineChartSimplePlotData(key: "Jan 5th, 2022", value: FormattedChartValue(value: CGFloat(500), formatted: "500 €")),
        LineChartSimplePlotData(key: "Jan 6th, 2022", value: FormattedChartValue(value: CGFloat(600), formatted: "600 €")),
        LineChartSimplePlotData(key: "Jan 7th, 2022", value: FormattedChartValue(value: CGFloat(1100), formatted: "1 100 €"))
    ]
    
    var body: some View {
        LineChartView(type: .oneLine(data: oneLineData, detailsViewLabel: "PRICE"))
            .frame(height: 250)
            .padding()
    }
}
``` 
