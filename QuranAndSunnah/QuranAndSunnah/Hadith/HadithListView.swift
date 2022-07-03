//
//  HadithListView.swift
//  QuranAndSunnah
//
//  Created by newone on 26/6/22.
//

import SwiftUI

struct HadithHeaderView: View {
    @EnvironmentObject var presenter: HadithPresenter
    var hadith: HadithText
    @Binding var hadithBookmarks: [Int: Bool]
    var body: some View {
        HStack {
            Text("\(hadith.hadithNo)")
                .frame(alignment: .leading)
                .padding()
            Spacer()
            Button {
                hadithBookmarks[hadith.hadithNo]!.toggle()
                presenter.bookmark(hadith: hadith, hadithBookmarks[hadith.hadithNo]!)
            } label: {
                if hadithBookmarks[hadith.hadithNo]! {
                    Image(systemName: "bookmark.fill").padding()
                } else {
                    Image(systemName: "bookmark").padding()
                }
            }.buttonStyle(PlainButtonStyle())

            Text(hadith.grade)
                .frame(alignment: .trailing)
                .padding()
        }
    }
}

struct HadithEnglishView: View {
    @EnvironmentObject var presenter: HadithPresenter
    @Binding var hadith: HadithText
    @Binding var hadithHighlights: [Int: [Highlight]]
    var fontSize: Double
    var height: CGFloat
    var padding: CGFloat
    @Binding var searchString: String

    var body: some View {
        TextView(
            text: Binding<NSMutableAttributedString>(
                get: { NSMutableAttributedString(string: hadith.matn) },
                set: { hadith.matn = $0.string }
            ),
            searchString: self.$searchString,
            paragraphAlignment: .left,
            fontSize: fontSize,
            highlights: hadithHighlights[hadith.hadithNo]!,
            onHighlight: { highlightedRange in
                presenter.onHighlightEvent(
                    hadith: hadith,
                    textRange: highlightedRange
                )

                hadithHighlights[hadith.hadithNo] = presenter.getHighlights(of: hadith)
            },
            onUnhighlight: { highlight in
                presenter.remove(highlight: highlight, from: hadith)
            }
        )
        .padding(.horizontal, padding)
        .frame(height: height)
    }
}

struct HadithArabicView: View {
    @Binding var hadith: HadithText
    @Binding var hadithArabicList: [Int: HadithText]
    var fontSize: Double
    var height: CGFloat
    var padding: CGFloat
    @Binding var searchString: String

    var body: some View {
        TextView(
            text: Binding<NSMutableAttributedString>(
                get: { NSMutableAttributedString(string: hadithArabicList[hadith.hadithNo]!.matn) },
                set: { hadith.matn = $0.string }
            ),
            searchString: self.$searchString,
            paragraphAlignment: .right,
            fontSize: fontSize,
            highlights: [Highlight]()
        )
        .padding(.horizontal, padding)
        .frame(height: height)
    }
}

struct HadithListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0

    @State var chapter: HadithChapter
    var collector: HadithCollector
    @State var searchString: String = ""

    @State private var showingPopover = false
    @State var hadithArabicList = [Int: HadithText]()
    @State var filteredHadithEnglishList = [HadithText]()
    @State var allHadithEnglishList = [HadithText]()
    @State var hadithBookmarks = [Int: Bool]()
    @State var hadithHighlights = [Int: [Highlight]]()
    @State var englishHeights = [Int: CGSize]()
    @State var arabicHeights = [Int: CGSize]()
    var padding: CGFloat = 5

    fileprivate func loadOnAppear(_ width: CGFloat) {
        Task.detached {
            async let hadithArabicList1 = presenter.getHadithArabicList(of: chapter, collector: collector)
            async let allHadithEnglishList1 = presenter.getHadithEnglishList(of: chapter, collector: collector)
            async let hadithBookmarks1 = presenter.getBookmarks(of: chapter)
            async let hadithHighlights1 = presenter.getHighlights(of: chapter)

            var filteredList1 = await allHadithEnglishList1
            let searchLC = await searchString.lowercased()
            if !searchLC.isEmpty {
                filteredList1 = await allHadithEnglishList1.filter { $0.matn.lowercased().contains(searchLC) }
            }

            let (hadithArabicList, allHadithEnglishList, hadithBookmarks, hadithHighlights, filteredList) =
                await(hadithArabicList1, allHadithEnglishList1, hadithBookmarks1, hadithHighlights1, filteredList1)
            async let arabicHeights1 = presenter.getHeights(of: hadithArabicList, fontSize: fontSize, viewWidth: width)
            async let englishHeights1 = presenter.getHeights(of: allHadithEnglishList, fontSize: fontSize, viewWidth: width)

            let (arabicHeights, englishHeights) = await(arabicHeights1, englishHeights1)
            
            await MainActor.run {
                self.hadithArabicList = hadithArabicList
                self.allHadithEnglishList = allHadithEnglishList
                self.filteredHadithEnglishList = filteredList
                self.hadithBookmarks = hadithBookmarks
                self.hadithHighlights = hadithHighlights
                self.arabicHeights = arabicHeights
                self.englishHeights = englishHeights
            }
        }
    }

    fileprivate func searchHadith(_ newValue: String) -> Task<Void, Never> {
        return Task.detached {
            var filteredList = await allHadithEnglishList
            if !newValue.isEmpty {
                filteredList = await allHadithEnglishList.filter { $0.matn.lowercased().contains(newValue.lowercased()) }
            }
            let filtered = filteredList
            await MainActor.run {
                self.filteredHadithEnglishList = filtered
            }
        }
    }

    var body: some View {
        GeometryReader { proxy in
            List(self.$filteredHadithEnglishList) { hadith in
                VStack(spacing: 10) {
                    HadithHeaderView(hadith: hadith.wrappedValue, hadithBookmarks: $hadithBookmarks)
                    HadithArabicView(
                        hadith: hadith,
                        hadithArabicList: $hadithArabicList,
                        fontSize: fontSize,
                        height: arabicHeights[hadith.wrappedValue.hadithNo]?.height ?? 0, // proxy.size.width - 2 * padding,
                        padding: padding,
                        searchString: $searchString
                    )
                    HadithEnglishView(
                        hadith: hadith,
                        hadithHighlights: $hadithHighlights,
                        fontSize: fontSize,
                        height: englishHeights[hadith.wrappedValue.hadithNo]?.height ?? 0,// proxy.size.width - 2 * padding,
                        padding: padding,
                        searchString: $searchString)

                }.listRowInsets(EdgeInsets())
            }
            .task {
                loadOnAppear(proxy.size.width - 2 * padding)
            }
            .onChange(of: searchString) { newValue in
                _ = searchHadith(newValue)
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchString)
            .listStyle(.sidebar)
        }

        .navigationTitle(Text("\(chapter.chapterNo) - \(chapter.title)"))
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
        }
    }
}

// struct HadithListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HadithListView()
//    }
// }
