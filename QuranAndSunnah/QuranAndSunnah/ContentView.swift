//
//  ContentView.swift
//  Sample
//
//  Created by newone on 23/5/22.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        TabView {
            QuranContentView()
                .tabItem {
                    Label("Quran", systemImage: "list.dash")
                }
            TafsirContentView()
                .tabItem {
                    Label("Tafsir", systemImage: "list.dash")
                }
            HadithContentView()
                .tabItem {
                    Label("Hadith", systemImage: "list.dash")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro (11-inch)")
    }
}
