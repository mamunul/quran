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
    @State var searchStrinng: String = ""

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
            HStack {
                TextField("TItle", text: $searchStrinng, prompt: Text("search here"))
                    .keyboardType(UIKeyboardType.alphabet)
                Button {
                    presenter.recite()
                } label: {
                    Text("recite")
                }
            }.padding(.horizontal)

            TextView(text: $content, scale: $scale , searchString:$searchStrinng)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .border(.yellow)
                .onAppear {
                    let text = QuranRepository().test()
                    print(text)
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
