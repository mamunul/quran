//
//  ContentView.swift
//  Sample
//
//  Created by newone on 23/5/22.
//

import SwiftUI
import UIKit

enum StorageName {
    static let fontSize = "fontSize"
}

struct MainView: View {
    static let fontRange: ClosedRange<Double> = 15.0 ... 30.0
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    @State var searchString: String = ""
    var body: some View {
        TabView {
            QuranContentView()
                .tabItem {
                    Label("Quran", systemImage: "book")
                }
            TafsirMainView()
                .tabItem {
                    Label("Tafsir", systemImage: "character.book.closed")
                }
            HadithContentView()
                .tabItem {
                    Label("Hadith", systemImage: "books.vertical")
                }
            NoteBookView()
                .tabItem {
                    Label("Notebook", systemImage: "bookmark")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .searchable(text: $searchString)
    }
}

struct SettingsView: View {
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    var body: some View {
        VStack {
            Text("FontSize").padding()
            Slider(value: $fontSize, in: MainView.fontRange, step: 1.0) {
                Text("FontSize").padding()
            } minimumValueLabel: {
                Text("\(MainView.fontRange.lowerBound.formatted())").padding()

            } maximumValueLabel: {
                Text("\(MainView.fontRange.upperBound.formatted())").padding()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")
        SettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro (11-inch)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
            .previewDisplayName("iPad Pro (11-inch)")
    }
}
