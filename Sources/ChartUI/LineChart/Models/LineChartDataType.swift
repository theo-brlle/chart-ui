public enum LineChartDataType {
    case price
    case speed
    case custom(title: String, formatter: String)
    
    var localizedTitle: String {
        switch self {
        case .price:
            return "price.title"
            
        case .speed:
            return "speed.title"
            
        case .custom(title: let title, formatter: _):
            return title
        }
    }
    
    var localizedFormatter: String {
        switch self {
        case .price:
            return "price.formatter"
            
        case .speed:
            return "speed.formatter"
            
        case .custom(title: _, formatter: let formatter):
            return formatter
        }
    }
}
