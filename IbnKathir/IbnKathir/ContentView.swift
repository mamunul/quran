//
//  ContentView.swift
//  IbnKathir
//
//  Created by newone on 29/5/22.
//

import SwiftUI

struct ContentView: View {
    @State var parser = HTMLContentParser()
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear {
                parser.execute()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
