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
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    var padding: CGFloat = 5

    var body: some View {
        GeometryReader { proxy in
            List(filteredAyat) { ayah in
                VStack {
                    HStack {
                        Text("\(ayah.surahNo)").padding(5)
                        Spacer()
                        Text("\(ayah.ayahNo)").padding(5)
                    }.padding(.horizontal, padding)
                    TextView(
                        text: .constant(NSMutableAttributedString(string: ayah.text)),
                        searchString: $searchString,
                        fontSize: fontSize,
                        highlights: [Highlight]()
                    )
                    .padding(.horizontal, padding)
                    .frame(height: TextViewFrameCalculator.frameSize(for: ayah.text, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .left).height)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
            .onChange(of: searchString, perform: { newValue in
                if newValue.isEmpty {
                    self.filteredAyat = allAyat
                } else {
                    Task(priority: .utility) {
                        let filteredAyat = allAyat.filter({ ayah in
                            ayah.text.lowercased().contains(searchString.lowercased())
                        })
                        Task(priority: .userInitiated) {
                            self.filteredAyat = filteredAyat
                        }
                    }
                }
            })
            .onAppear {
                Task(priority: .utility) {
                    let allAyat = presenter.getAyatTranslation()
                    var filteredAyat = allAyat
                    if !searchString.isEmpty {
                        filteredAyat = allAyat.filter({ ayah in
                            ayah.text.lowercased().contains(searchString.lowercased())
                        })
                    }
                    Task(priority: .userInitiated) {
                        self.allAyat = allAyat
                        self.filteredAyat = filteredAyat
                    }
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
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    var padding: CGFloat = 5

    var body: some View {
        GeometryReader { proxy in
            List(filteredHadithList) { hadith in
                VStack {
                    HStack {
                        Text("\(hadith.hadithNo) : \(hadith.contentId.contentId.getTitle())").padding(5)
                        Spacer()
                        Text("\(hadith.grade)").padding(5)
                    }.padding(.horizontal, padding)
                    TextView(
                        text: .constant(NSMutableAttributedString(string: hadith.matn)),
                        searchString: $searchString,
                        fontSize: fontSize,
                        highlights: [Highlight]()
                    )
                    .padding(.horizontal, padding)
                    .frame(height: TextViewFrameCalculator.frameSize(for: hadith.matn, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .left).height)
                }.listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
            .onChange(of: searchString, perform: { newValue in
                if newValue.isEmpty {
                    self.filteredHadithList = hadithList
                } else {
                    Task(priority: .utility) {
                        let filteredHadithList = hadithList.filter({ hadith in
                            hadith.matn.lowercased().contains(searchString.lowercased())
                        })
                        Task(priority: .userInitiated) {
                            self.filteredHadithList = filteredHadithList
                        }
                    }
                }
            })
            .onAppear {
                Task(priority: .utility) {
                    let hadithList = await presenter.getHadithList()
                    var filteredHadithList = hadithList
                    if !searchString.isEmpty {
                        filteredHadithList = hadithList.filter({ hadith in
                            hadith.matn.lowercased().contains(searchString.lowercased())
                        })
                    }
                    Task(priority: .userInitiated) {
                        self.hadithList = hadithList
                        self.filteredHadithList = filteredHadithList
                    }
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
            }.searchable(text: $presenter.searchString)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
