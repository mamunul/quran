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
    var width: CGFloat
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
        .frame(height:
            TextViewFrameCalculator.frameSize(
                for: hadith.matn,
                fontSize: Int(fontSize),
                width: width,
                paragraphAlignment: .left
            ).height
        )
    }
}

struct HadithArabicView: View {
    @Binding var hadith: HadithText
    @Binding var hadithArabicList: [Int: HadithText]
    var fontSize: Double
    var width: CGFloat
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
        .frame(
            height: TextViewFrameCalculator.frameSize(
                for: hadithArabicList[hadith.hadithNo]!.matn,
                fontSize: Int(fontSize),
                width: width,
                paragraphAlignment: .right
            ).height
        )
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
    var padding: CGFloat = 5

    var body: some View {
        GeometryReader { proxy in
//            List {
            List(self.$filteredHadithEnglishList) { hadith in
                VStack(spacing: 10) {
                    HadithHeaderView(hadith: hadith.wrappedValue, hadithBookmarks: $hadithBookmarks)
                    HadithArabicView(
                        hadith: hadith,
                        hadithArabicList: $hadithArabicList,
                        fontSize: fontSize,
                        width: proxy.size.width - 2 * padding,
                        padding: padding,
                        searchString: $searchString
                    )
                    HadithEnglishView(
                        hadith: hadith,
                        hadithHighlights: $hadithHighlights,
                        fontSize: fontSize,
                        width: proxy.size.width - 2 * padding,
                        padding: padding,
                        searchString: $searchString)

                }.listRowInsets(EdgeInsets())
            }
        }
        .listStyle(PlainListStyle())
        .searchable(text: $searchString)
        .onChange(of: searchString) { newValue in

            DispatchQueue.global().async {
                var filteredList = allHadithEnglishList
                if !newValue.isEmpty {
                    filteredList = allHadithEnglishList.filter { $0.matn.lowercased().contains(newValue.lowercased()) }
                }

                DispatchQueue.main.async {
                    self.filteredHadithEnglishList = filteredList
                }
            }
        }
        .listStyle(.sidebar)
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
        .onAppear {
            DispatchQueue.global().async {
                let hadithArabicList = presenter.getHadithArabicList(of: chapter, collector: collector)
                let allHadithEnglishList = presenter.getHadithEnglishList(of: chapter, collector: collector)
                var filteredList = allHadithEnglishList
                let hadithBookmarks = presenter.getBookmarks(of: chapter)
                let hadithHighlights = presenter.getHighlights(of: chapter)

                if !searchString.isEmpty {
                    filteredList = allHadithEnglishList.filter { $0.matn.lowercased().contains(searchString.lowercased()) }
                }

                DispatchQueue.main.async {
                    self.hadithArabicList = hadithArabicList
                    self.allHadithEnglishList = allHadithEnglishList
                    self.filteredHadithEnglishList = filteredList
                    self.hadithBookmarks = hadithBookmarks
                    self.hadithHighlights = hadithHighlights
                }
//                }
            }
        }
    }
}

// struct HadithListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HadithListView()
//    }
// }
