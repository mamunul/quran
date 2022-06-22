//
//  HadithContentView.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import SwiftUI

struct HadithContentView: View {
    @StateObject var presenter = HadithPresenter()
    var body: some View {
        NavigationView {
            HadithCollectorListView()
                .environmentObject(presenter)
        }
        .environmentObject(presenter)
        .onAppear {
            presenter.getHadithCollectorList()
        }
    }
}

struct HadithCollectorListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    var body: some View {
        List {
            ForEach(self.presenter.collectors) { collector in
                NavigationLink {
                    HadithChapterListView(collector: collector)
                } label: {
                    HStack {
                        Text(collector.name)
                    }
                }
            }
        }.listStyle(.sidebar)
    }
}

struct HadithListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    @State var searchString: String = ""
    @State private var showingPopover = false
    @State var chapter: HadithChapter
    var collector: HadithCollector
    @State var hadithArabicList = [Int: HadithText]()
    @State var hadithEnglishList = [HadithText]()
    @State var allHadithEnglishList = [HadithText]()
    @State var hadithBookmarks = [Int: Bool]()
    @State var hadithHighlights = [Int: [Highlight]]()
    var padding: CGFloat = 5

    var body: some View {
        GeometryReader { proxy in
//            List {
            List(self.$hadithEnglishList) { hadith in
                VStack(spacing: 10) {
                    HStack {
                        Text("\(hadith.wrappedValue.hadithNo)")
                            .frame(alignment: .leading)
                            .padding()
                        Spacer()
                        Button {
                            hadithBookmarks[hadith.wrappedValue.hadithNo]!.toggle()
                            presenter.bookmark(hadith: hadith.wrappedValue, hadithBookmarks[hadith.wrappedValue.hadithNo]!)
                        } label: {
                            if hadithBookmarks[hadith.wrappedValue.hadithNo]! {
                                Image(systemName: "bookmark.fill").padding()
                            } else {
                                Image(systemName: "bookmark").padding()
                            }
                        }.buttonStyle(PlainButtonStyle())

                        Text(hadith.wrappedValue.grade)
                            .frame(alignment: .trailing)
                            .padding()
                    }
                    TextView(
                        text: Binding<NSMutableAttributedString>(
                            get: { NSMutableAttributedString(string: hadithArabicList[hadith.wrappedValue.hadithNo]!.matn) },
                            set: { hadith.wrappedValue.matn = $0.string }
                        ),
                        searchString: self.$searchString,
                        paragraphAlignment: .right,
                        fontSize: fontSize,
                        highlights: [Highlight]()
                    )
                    .padding(.horizontal, padding)
                    .frame(height: frameSize(for: hadithArabicList[hadith.wrappedValue.hadithNo]!.matn, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .right).height)

                    TextView(
                        text: Binding<NSMutableAttributedString>(
                            get: { NSMutableAttributedString(string: hadith.wrappedValue.matn) },
                            set: { hadith.wrappedValue.matn = $0.string }
                        ),
                        searchString: self.$searchString,
                        paragraphAlignment: .left,
                        fontSize: fontSize,
                        highlights: hadithHighlights[hadith.wrappedValue.hadithNo]!,
                        onHighlight: { highlightedRange in
                            presenter.onHighlightEvent(
                                hadith: hadith.wrappedValue,
                                textRange: highlightedRange
                            )

                            hadithHighlights[hadith.wrappedValue.hadithNo] = presenter.getHighlights(of: hadith.wrappedValue)
                        },
                        onUnhighlight: { highlight in
                            presenter.remove(highlight: highlight, from: hadith.wrappedValue)
                        }
                    )
                    .padding(.horizontal, padding)
                    .frame(height:
                        frameSize(
                            for: hadith.wrappedValue.matn,
                            fontSize: Int(fontSize),
                            width: proxy.size.width - padding * 2,
                            paragraphAlignment: .left
                        ).height
                    )
                }.listRowInsets(EdgeInsets())
            }
        }
        .listStyle(PlainListStyle())
        .searchable(text: $searchString)
        .onChange(of: searchString) { newValue in
            Task {
                if newValue.isEmpty {
                    hadithEnglishList = allHadithEnglishList
                } else {
                    let newList = hadithEnglishList.filter { $0.matn.localizedCaseInsensitiveContains(newValue) }
                    hadithEnglishList = newList
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
                let hadithEnglishList = allHadithEnglishList
                let hadithBookmarks = presenter.getBookmarks(of: chapter)
                let hadithHighlights = presenter.getHighlights(of: chapter)
                DispatchQueue.main.async {
                    self.hadithArabicList = hadithArabicList
                    self.allHadithEnglishList = allHadithEnglishList
                    self.hadithEnglishList = hadithEnglishList
                    self.hadithBookmarks = hadithBookmarks
                    self.hadithHighlights = hadithHighlights
                }
//                }
            }
        }
    }

    func frameSize(for text: String, fontSize: Int, width: CGFloat, paragraphAlignment: CustomTextAlignment) -> CGSize {
        let attributedText = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        var attribute: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        switch paragraphAlignment {
        case .justify:
            paragraphStyle.alignment = .justified
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .left:
            paragraphStyle.alignment = .left
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .right:
            paragraphStyle.alignment = .right
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .none:
            paragraphStyle.alignment = .natural
        }

        let attribute3: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 0]
        attribute += attribute3

        attributedText.addAttributes(attribute, range: fullRange)

        let textView = CustomUITextView()
        textView.frame.size.width = width

        textView.attributedText = attributedText

        let rect = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude))
        return rect
    }
}

struct HadithChapterListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    var collector: HadithCollector
    @State var chapterList = [HadithChapter]()
    var body: some View {
//        List {
        List(self.chapterList) { chapter in
            NavigationLink {
                HadithListView(chapter: chapter, collector: collector)
            } label: {
                HStack {
                    Text("\(chapter.chapterNo)").frame(width: 25)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(chapter.title)
                        Text("\(chapter.hadithNo.lowerBound) - \(chapter.hadithNo.upperBound)")
                            .font(.system(size: 14))
                    }
                }
            }
        }
//        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(self.collector.name)"))
        .onAppear {
            DispatchQueue.global().async {
                let chapterList = presenter.getChapterList(collector: collector)
                DispatchQueue.main.async {
                    self.chapterList = chapterList
                }
            }
        }
    }
}

struct HadithContentView_Previews: PreviewProvider {
    static var previews: some View {
        HadithContentView().colorScheme(.dark)
    }
}
