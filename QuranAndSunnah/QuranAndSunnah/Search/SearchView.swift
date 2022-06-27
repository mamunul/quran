//
//  SearchView.swift
//  QuranAndSunnah
//
//  Created by newone on 12/6/22.
//

import SwiftUI

struct QuranSearchView: View {
    @EnvironmentObject var presenter: SearchPresenter
    @Binding var searchString: String
    @State var filteredAyat = [Ayah]()
    @State var allAyat = [Ayah]()
    var body: some View {
        List(filteredAyat) { ayah in
            VStack {
                HStack {
                    Text("\(ayah.surahNo)").padding(5)
                    Spacer()
                    Text("\(ayah.ayahNo)").padding(5)
                }
                Text(ayah.text)
            }
        }
        .listStyle(PlainListStyle())
        .searchable(text: $searchString)
        .onChange(of: searchString, perform: { newValue in
            if newValue.isEmpty {
                self.filteredAyat = allAyat
            } else {
                DispatchQueue.global().async {
                    let filteredAyat = allAyat.filter({ ayah in
                        ayah.text.lowercased().contains(searchString.lowercased())
                    })
                    DispatchQueue.main.async {
                        self.filteredAyat = filteredAyat
                    }
                }
            }
        })
        .onAppear {
            Task {
                let allAyat = presenter.getAyatTranslation()
                DispatchQueue.main.async {
                    self.allAyat = allAyat
                    self.filteredAyat = allAyat
                }
            }
        }
    }
}

struct SearchView: View {
    @StateObject var presenter = SearchPresenter()
    @State var searchString = ""
    var body: some View {
        NavigationView {
            VStack {
                Picker("Search", selection: $presenter.searchSelection) {
                    Text(SearchType.quran.rawValue).tag(SearchType.quran)
                    Text(SearchType.hadith.rawValue).tag(SearchType.hadith)
                    Text(SearchType.tafsir.rawValue).tag(SearchType.tafsir)
                }
                .pickerStyle(SegmentedPickerStyle())

                QuranSearchView(searchString: $searchString)
                    .environmentObject(presenter)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
