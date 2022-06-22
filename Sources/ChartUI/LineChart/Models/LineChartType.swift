public enum LineChartType {
    case oneLine(data: [LineChartSimplePlotData], detailsViewLabel: String)
    case twoLines(data: [LineChartDoublePlotData], detailsViewPercentageSuffix: String = "")
}
