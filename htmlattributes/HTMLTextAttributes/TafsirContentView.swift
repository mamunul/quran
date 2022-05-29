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
    @GestureState var scaleState = 1.0
    
    var magnification: some Gesture {
          MagnificationGesture()
              .updating($scaleState) { currentState, gestureState, transaction in
                  gestureState = currentState
                  
                  presenter.scaleContent(scaleState: scaleState)
              }
              .onChanged { value in
                  
              }
      }
    
    var body: some View {
        ScrollView {
            Text("«هِيَ أُمُّ الْقُرْآنِ وَهِيَ السَّبْعُ الْمَثَانِي وَهِيَ الْقُرْآنُ الْعَظِيمُ»")
                .font(Font(UIFont(name: "_PDMS_Saleem_QuranFont", size: UIFont.labelFontSize)!))

            TextView(text: $content)
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
