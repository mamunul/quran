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
//        .searchable(text: $searchString)
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
            DispatchQueue.global().async {
                let allAyat = presenter.getAyatTranslation()
                var filteredAyat = allAyat
                if !searchString.isEmpty {
                    filteredAyat = allAyat.filter({ ayah in
                        ayah.text.lowercased().contains(searchString.lowercased())
                    })
                }
                DispatchQueue.main.async {
                    self.allAyat = allAyat
                    self.filteredAyat = filteredAyat
                }
            }
        }
    }
}

struct HadithSearchView: View {
    @EnvironmentObject var presenter: SearchPresenter
    @Binding var searchString: String
    @State var filteredHadithList = [HadithText]()
    @State var hadithList = [HadithText]()
    var body: some View {
        List(filteredHadithList) { hadith in
            VStack {
                HStack {
                    Text("\(hadith.hadithNo) : \(hadith.contentId.contentId.getTitle())").padding(5)
                    Spacer()
                    Text("\(hadith.grade)").padding(5)
                }
                Text(hadith.matn)
            }
        }
        .listStyle(PlainListStyle())
        .onChange(of: searchString, perform: { newValue in
            if newValue.isEmpty {
                self.filteredHadithList = hadithList
            } else {
                DispatchQueue.global().async {
                    let filteredHadithList = hadithList.filter({ hadith in
                        hadith.matn.lowercased().contains(searchString.lowercased())
                    })
                    DispatchQueue.main.async {
                        self.filteredHadithList = filteredHadithList
                    }
                }
            }
        })
        .onAppear {
            DispatchQueue.global().async {
                let hadithList = presenter.getHadithList()
                var filteredHadithList = hadithList
                if !searchString.isEmpty {
                    filteredHadithList = hadithList.filter({ hadith in
                        hadith.matn.lowercased().contains(searchString.lowercased())
                    })
                }
                DispatchQueue.main.async {
                    self.hadithList = hadithList
                    self.filteredHadithList = filteredHadithList
                }
            }
        }
    }
}

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
            }  .searchable(text: $presenter.searchString)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
