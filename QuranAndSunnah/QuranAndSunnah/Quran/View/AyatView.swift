//
//  QuranContentView.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import SwiftUI

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
                Task {
                    bookmark.toggle()
                    await presenter.bookmark(ayah: ayah, bookmark)
                }
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
                Task {
                    await presenter.onHighlightEvent(
                        textRange: highlightedRange,
                        ayah: translation,
                        fullString: translation.text
                    )
                    let ayahHighlights = await presenter.getHighlights(of: translation)
                    highlights = ayahHighlights
                }
            },
            onUnhighlight: { highlight in
                Task {
                    await presenter.remove(highlight: highlight, from: translation)
                }
            }
        )
        .padding(.horizontal, padding)
        .frame(height:
            TextViewFrameCalculator().frameSize(
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
        Task {
            async let ayat2 = presenter.getAyat(of: surah)
            async let ayatTranslation2 = presenter.getAyatTranslation(of: surah)
            async let bookmarks2 = presenter.getBookmarks(surah: surah)
            async let highlight2 = presenter.getHighlights(of: surah)

            var filtered2 = try await ayat2
            if !searchString.isEmpty {
                filtered2 = try await searchContent(in: ayat2, ayatTranslation2)
            }

            let (ayat, ayatTranslation, bookmarks, highlight, filtered) =
                try await(ayat2, ayatTranslation2, bookmarks2, highlight2, filtered2)

            await MainActor.run {
                self.ayat = ayat
                self.filteredAyat = filtered
                self.ayatTranslation = ayatTranslation
                self.bookmarks = bookmarks
                self.highlights = highlight
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
                            get: { bookmarks[ayah.wrappedValue.ayahNo] ?? false },
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
                    .frame(height: TextViewFrameCalculator().frameSize(for: ayah.wrappedValue.text, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .right).height)
                    AyahTranslationView(
                        translation: Binding<Ayah>(
                            get: { ayatTranslation[ayah.wrappedValue.ayahNo] ?? Ayah.empty },
                            set: { ayatTranslation[ayah.wrappedValue.ayahNo] = $0 }
                        ),
                        highlights: Binding<[Highlight]>(
                            get: { highlights[ayah.wrappedValue.ayahNo] ?? [Highlight]() },
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
            .onChange(of: searchString) { _,newValue in
                Task {
                    if newValue.isEmpty {
                        filteredAyat = ayat
                    } else {
                        let newList = searchContent(in: ayat, ayatTranslation)
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

    func searchContent(in ayat: [Ayah], _ translation: [Int: Ayah]) -> [Ayah] {
        let newList = ayat.filter { translation[$0.ayahNo]?.text.lowercased().contains(searchString.lowercased()) ?? false }
        return newList
    }
}

struct QuranContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuranContentView().colorScheme(.dark)
    }
}
