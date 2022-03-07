import Foundation

extension String {
    func localized(withParameters parameters: CVarArg...) -> String {
#if SWIFT_PACKAGE
        return String(format: NSLocalizedString(self, bundle: .module, comment: ""), arguments: parameters)
#else
        let path = Bundle(for: ChartUI.self).path(forResource: "ChartUI", ofType: "bundle")!
        let bundle = Bundle(path: path) ?? Bundle.main
        return String(format: NSLocalizedString(self, bundle: bundle, comment: ""), arguments: parameters)
#endif
    }
}
