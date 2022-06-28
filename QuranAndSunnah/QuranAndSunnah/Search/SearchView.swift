//
//  SearchView.swift
//  QuranAndSunnah
//
//  Created by newone on 12/6/22.
//

import SwiftUI

struct TafsirSearchView: View {
    @EnvironmentObject var presenter: SearchPresenter
    @Binding var searchString: String
    var body: some View {
        Text("test")
    }
}

struct SearchView: View {
    @StateObject var presenter = SearchPresenter()
//    @StateObject var searchString = ""
    var body: some View {
        NavigationView {
            VStack {
                Picker("Search", selection: $presenter.searchSelection) {
                    Text(SearchType.quran.rawValue).tag(SearchType.quran)
                    Text(SearchType.hadith.rawValue).tag(SearchType.hadith)
                    Text(SearchType.tafsir.rawValue).tag(SearchType.tafsir)
                }
                .pickerStyle(SegmentedPickerStyle())
                if presenter.searchSelection == .hadith {
                    HadithSearchView(searchString: $presenter.searchString)
                        .environmentObject(presenter)
                } else if presenter.searchSelection == .quran {
                    QuranSearchView(searchString: $presenter.searchString)
                        .environmentObject(presenter)
                } else if presenter.searchSelection == .tafsir {
                    QuranSearchView(searchString: $presenter.searchString)
                        .environmentObject(presenter)
                }
            }.searchable(text: $presenter.searchString)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
