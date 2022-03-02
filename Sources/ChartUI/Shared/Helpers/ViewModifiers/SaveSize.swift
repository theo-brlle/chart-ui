import SwiftUI

extension View {
    func saveSize(in sizeHandler: Binding<CGSize>) -> some View {
        overlay(SizeSaver(sizeHandler: sizeHandler))
    }
}

fileprivate struct SizeSaver: View {
    @Binding var sizeHandler: CGSize

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .onAppear {
                    sizeHandler = geometry.size
                }
                .onChange(of: geometry.size) { size in
                    sizeHandler = size
                }
        }
    }
}

