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
//    @Binding var chapter: HadithChapter
    @State var searchString: String = ""
    @State private var showingPopover = false
    @State var chapter: HadithChapter
    var collector: HadithCollector
    @State var hadithList = [Hadith]()
    @State var allHadithList = [Hadith]()

    var body: some View {
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
                    TextView(Binding<NSMutableAttributedString>(
                        get: { NSMutableAttributedString(string: hadith.wrappedValue.hadith) },
                        set: { hadith.wrappedValue.hadith = $0.string }
                    ),
                    searchString: .constant("")
                    )
                    .paragraphStyle(.right)
                    .fontSize(fontSize)
                    TextView(
                        Binding<NSMutableAttributedString>(
                            get: { NSMutableAttributedString(string: hadith.wrappedValue.hadithTranslations.first!.text) },
                            set: { hadith.wrappedValue.hadith = $0.string }
                        ),
                        searchString: $searchString
                    )
                    .paragraphStyle(.left)
                    .fontSize(fontSize)
                }
            }
        }
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
