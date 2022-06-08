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
    @State private var chapter: HadithChapter
    private var all: HadithChapter
    init(chapter: HadithChapter) {
        all = chapter
        self.chapter = chapter
    }

    var body: some View {
        List {
            ForEach(self.$chapter.hadithList) { hadith in
                VStack(spacing: 10) {
                    HStack {
                        Text(hadith.wrappedValue.hadithNo)
                            .frame(alignment: .leading)
                        Spacer()
                        Text(hadith.wrappedValue.gradeTranslations.first?.translation ?? "")
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
                            get: { NSMutableAttributedString(string: hadith.wrappedValue.hadithTranslations.first!.translation) },
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
                    chapter.hadithList = all.hadithList
                } else {
                    let newList = all.hadithList.filter { $0.hadithTranslations.first!.translation.localizedCaseInsensitiveContains(newValue) }
                    chapter.hadithList = newList
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(chapter.chapterNo) - \(chapter.titleTranslations.first?.translation ?? "")"))
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
//        .sheet(isPresented: $showingPopover) {
//            SettingsView()
//        }
    }
}

struct HadithChapterListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    var collector: HadithCollector
    var body: some View {
        List {
            ForEach(self.$presenter.hadithBook.chapters) { chapter in
                NavigationLink {
                    HadithListView(chapter: chapter.wrappedValue)
                } label: {
                    HStack {
                        Text("\(chapter.wrappedValue.chapterNo)").frame(width: 25)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(chapter.wrappedValue.titleTranslations.first?.translation ?? "")
                            Text("\(chapter.wrappedValue.hadithList.first?.hadithNo ?? "") - \(chapter.wrappedValue.hadithList.last?.hadithNo ?? "")")
                                .font(.system(size: 14))
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(self.presenter.hadithBook.name)"))
        .onAppear {
            presenter.getHadith(of: collector)
        }
    }
}

struct HadithContentView_Previews: PreviewProvider {
    static var previews: some View {
        HadithContentView().colorScheme(.dark)
    }
}
