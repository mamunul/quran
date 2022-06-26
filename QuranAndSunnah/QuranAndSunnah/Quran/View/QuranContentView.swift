//
//  QuranContentView.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import SwiftUI

struct QuranContentView: View {
    @StateObject var presenter = QuranPresenter()
    var body: some View {
        NavigationView {
            SurahListView()
        }

        .environmentObject(presenter)
        .onAppear {
            DispatchQueue.global().async {
                presenter.getSurahList()
                presenter.getSurahTranslationList()
                presenter.getSurahTransliterationList()
                presenter.getSurahArabicList()
            }
        }
    }
}

struct AyahHeaderView: View {
    @Binding var ayah: Ayah
    var surah: SurahInfo
    @Binding var bookmark: Bool
    @EnvironmentObject var presenter: QuranPresenter

    var body: some View {
        HStack {
            Text("\(ayah.ayahNo - surah.firstAyahNo + 1)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            Button {
                bookmark.toggle()
                presenter.bookmark(ayah: ayah, bookmark)
            } label: {
                if bookmark {
                    Image(systemName: "bookmark.fill").padding()
                } else {
                    Image(systemName: "bookmark").padding()
                }
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct AyahTranslationView: View {
    @Binding var translation: Ayah
    @Binding var highlights: [Highlight]
    @Binding var fontSize: Double
    var viewWidth: CGFloat
    @Binding var searchString: String
    var padding: CGFloat
    @EnvironmentObject var presenter: QuranPresenter

    var body: some View {
        TextView(
            text: Binding<NSMutableAttributedString>(
                get: { NSMutableAttributedString(string: translation.text) },
                set: { translation.text = $0.string }
            ),
            searchString: self.$searchString,
            paragraphAlignment: .left,
            fontSize: fontSize,
            highlights: highlights,
            onHighlight: { highlightedRange in

                presenter.onHighlightEvent(
                    textRange: highlightedRange,
                    ayah: translation,
                    fullString: translation.text
                )
                let ayahHighlights = presenter.getHighlights(of: translation)
                highlights = ayahHighlights
            },
            onUnhighlight: { highlight in
                presenter.remove(highlight: highlight, from: translation)
            }
        )
        .padding(.horizontal, padding)
        .frame(height:
            TextViewFrameCalculator.frameSize(
                for: translation.text,
                fontSize: Int(fontSize),
                width: viewWidth - padding * 2,
                paragraphAlignment: .left
            ).height
        )
    }
}

struct SurahContentView: View {
    @EnvironmentObject var presenter: QuranPresenter
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    @State var surah: SurahInfo
    @State var surahTransliteration: SurahName
    @State var searchString: String = ""
    @State var showingPopover = false

    @State var filteredAyat = [Ayah]()
    @State var ayat = [Ayah]()
    @State var ayatTranslation = [Int: Ayah]()
    @State var bookmarks = [Int: Bool]()
    @State var highlights = [Int: [Highlight]]()
    var padding: CGFloat = 5

    fileprivate func loadInitialProperties() {
        DispatchQueue.global().async {
            let ayat = presenter.getAyat(of: surah)
            let filteredAyat = ayat
            let ayatTranslation = presenter.getAyatTranslation(of: surah)
            let bookmarks = presenter.getBookmarks(surah: surah)
            let highlights = presenter.getHighlights(of: surah)
            
            DispatchQueue.main.async {
                self.ayat = ayat
                self.filteredAyat = filteredAyat
                self.ayatTranslation = ayatTranslation
                self.bookmarks = bookmarks
                self.highlights = highlights
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
//            List {
            List($filteredAyat) { ayah in
                VStack(spacing: 10) {
                    AyahHeaderView(
                        ayah: ayah,
                        surah: surah,
                        bookmark: Binding<Bool>(
                            get: { bookmarks[ayah.wrappedValue.ayahNo]! },
                            set: { bookmarks[ayah.wrappedValue.ayahNo] = $0 }
                        )
                    )
                    TextView(
                        text: .constant(NSMutableAttributedString(string: ayah.wrappedValue.text)),
                        searchString: self.$searchString,
                        paragraphAlignment: .right,
                        fontSize: fontSize,
                        highlights: [Highlight]()
                    )
                    .padding(.horizontal, padding)
                    .frame(height: TextViewFrameCalculator.frameSize(for: ayah.wrappedValue.text, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .right).height)
                    AyahTranslationView(
                        translation: Binding<Ayah>(
                            get: { ayatTranslation[ayah.wrappedValue.ayahNo]! },
                            set: { ayatTranslation[ayah.wrappedValue.ayahNo] = $0 }
                        ),
                        highlights: Binding<[Highlight]>(
                            get: { highlights[ayah.wrappedValue.ayahNo]! },
                            set: { highlights[ayah.wrappedValue.ayahNo] = $0 }
                        ),
                        fontSize: $fontSize,
                        viewWidth: proxy.size.width,
                        searchString: $searchString,
                        padding: padding
                    )
                    .environmentObject(presenter)
                }
                .listRowInsets(EdgeInsets())
            }
//            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchString)
            .onChange(of: searchString) { newValue in
                Task {
                    if newValue.isEmpty {
                        filteredAyat = ayat
                    } else {
                        let newList = ayat.filter { ayatTranslation[$0.ayahNo]?.text.localizedCaseInsensitiveContains(newValue) ?? false }
                        filteredAyat = newList
                    }
                }
            }
            .navigationTitle(Text(surahTransliteration.text))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingPopover = true
                    }, label: {
                        Image(systemName: "gear")
                    })
                        .alwaysPopover(isPresented: $showingPopover) {
                            SettingsView()
                        }
                }
            }.onAppear {
                loadInitialProperties()
            }
        }
    }
}

struct QuranContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuranContentView().colorScheme(.dark)
    }
}
