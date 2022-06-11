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
    @State var hadithList = [Hadith]()
    @State var allHadithList = [Hadith]()

    var body: some View {
        GeometryReader { proxy in
            List {
                ForEach(self.$hadithList) { hadith in
                    VStack(spacing: 10) {
                        HStack {
                            Text(hadith.wrappedValue.hadithNo)
                                .frame(alignment: .leading)
                            Spacer()
                            Text(hadith.wrappedValue.gradeTranslations.first?.text ?? "")
                                .frame(alignment: .trailing)
                        }
                        TextViewRepresentable2(
                            text: Binding<NSMutableAttributedString>(
                                get: { NSMutableAttributedString(string: hadith.wrappedValue.hadith) },
                                set: { hadith.wrappedValue.hadith = $0.string }
                            ),
                            searchString: self.$searchString,
                            paragraphAlignment: .right,
                            fontSize: fontSize
                        )
                        .frame(height: frameSize(for: hadith.wrappedValue.hadith, fontSize: Int(fontSize), width: proxy.size.width, paragraphAlignment: .right).height)

                        TextViewRepresentable2(
                            text: Binding<NSMutableAttributedString>(
                                get: { NSMutableAttributedString(string: hadith.wrappedValue.hadithTranslations.first!.text) },
                                set: { hadith.wrappedValue.hadith = $0.string }
                            ),
                            searchString: self.$searchString,
                            paragraphAlignment: .left,
                            fontSize: fontSize
                        )
                        .frame(height: frameSize(for: hadith.wrappedValue.hadithTranslations.first!.text, fontSize: Int(fontSize), width: proxy.size.width, paragraphAlignment: .left).height)
                    }.listRowInsets(EdgeInsets())
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchString)
            .onChange(of: searchString) { newValue in
                Task {
                    if newValue.isEmpty {
                        hadithList = allHadithList
                    } else {
                        let newList = allHadithList.filter { $0.hadithTranslations.first!.text.localizedCaseInsensitiveContains(newValue) }
                        hadithList = newList
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle(Text("\(chapter.chapterNo) - \(chapter.titleTranslations.first?.text ?? "")"))
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
                Task {
                    allHadithList = presenter.getHadithList(of: chapter, collector: collector)
                    hadithList = allHadithList
                }
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
    @State var book = HadithBook.empty
    var body: some View {
        List {
            ForEach(self.book.chapters) { chapter in
                NavigationLink {
                    HadithListView(chapter: chapter, collector: collector)
                } label: {
                    HStack {
                        Text("\(chapter.chapterNo)").frame(width: 25)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(chapter.titleTranslations.first?.text ?? "")
                            Text("\(chapter.hadithNo.lowerBound) - \(chapter.hadithNo.upperBound)")
                                .font(.system(size: 14))
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(self.book.name)"))
        .onAppear {
            Task {
                book = presenter.getHadithBook(of: collector)
            }
        }
    }
}

struct HadithContentView_Previews: PreviewProvider {
    static var previews: some View {
        HadithContentView().colorScheme(.dark)
    }
}
