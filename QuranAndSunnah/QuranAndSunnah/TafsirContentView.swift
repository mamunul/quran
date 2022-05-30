//
//  HTMLTextView.swift
//  Sample
//
//  Created by newone on 26/5/22.
//

import Combine
import SwiftUI

struct TafsirContentView: View {
    @State var presenter = TafsirContentPresenter()
    @State var content = NSMutableAttributedString(string: "")
    @State var scale = 1.0
    @GestureState var scaleState = 1.0

    var magnification: some Gesture {
        MagnificationGesture()
            .updating($scaleState) { currentState, gestureState, _ in
                gestureState = currentState
            }
            .onChanged { _ in
                scale *= scaleState
                if scale < 1 { scale = 1 }
                else if scale > 2 { scale = 2 }
            }
    }

    var body: some View {
        ScrollView {
            Text("«هِيَ أُمُّ الْقُرْآنِ وَهِيَ السَّبْعُ الْمَثَانِي وَهِيَ الْقُرْآنُ الْعَظِيمُ»")
                .font(Font(UIFont(name: "_PDMS_Saleem_QuranFont", size: UIFont.labelFontSize)!))

            TextView(text: $content, scale: $scale)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .border(.yellow)
                .onAppear {
                    self.content = presenter.onViewAppear()
                }
                .gesture(magnification)
        }
    }
}

struct HTMLTextView_Previews: PreviewProvider {
    static var previews: some View {
        TafsirContentView()
    }
}
