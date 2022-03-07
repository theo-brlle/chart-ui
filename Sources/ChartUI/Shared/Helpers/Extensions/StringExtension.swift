import Foundation

extension String {
    func localized(withParameters parameters: CVarArg...) -> String {
#if SWIFT_PACKAGE
        return String(format: NSLocalizedString(self, bundle: .module, comment: ""), arguments: parameters)
#else
        guard let path = Bundle(for: LineChartView.self).path(forResource: "ChartUI", ofType: "bundle") else {
            return String(format: NSLocalizedString(self, bundle: .main, comment: ""), arguments: parameters)
        }
        let bundle = Bundle(path: path) ?? Bundle.main
        return String(format: NSLocalizedString(self, bundle: bundle, comment: ""), arguments: parameters)
#endif
    }
}
