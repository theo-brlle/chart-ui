import Foundation

extension String {
    func localized(from bundle: Bundle = .module, withParameters parameters: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, bundle: bundle, comment: ""), arguments: parameters)
    }
}
