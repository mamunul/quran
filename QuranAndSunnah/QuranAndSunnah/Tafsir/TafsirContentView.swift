//
//  HTMLTextView.swift
//  Sample
//
//  Created by newone on 26/5/22.
//

import Combine
import SwiftUI

struct TafsirContentView: View {
    @StateObject var presenter = TafsirContentPresenter()
    @State var searchStrinng: String = ""


    var body: some View {
        ScrollView {
            HStack {
                TextField("Title", text: $searchStrinng, prompt: Text("search here"))
                    .keyboardType(UIKeyboardType.alphabet)
               
                Button {
                    presenter.recite()
                } label: {
                    Text("recite")
                }
            }
            .padding(.horizontal)
            Slider(value: $presenter.fontSize, in: presenter.fontRange, step: 1.0)
            TextView(text: $presenter.attributedContent, searchString: $searchStrinng)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .border(.yellow)
                .onAppear {
                    presenter.onViewAppear()
                }
        }
    }
}

struct HTMLTextView_Previews: PreviewProvider {
    static var previews: some View {
        TafsirContentView()
    }
}
