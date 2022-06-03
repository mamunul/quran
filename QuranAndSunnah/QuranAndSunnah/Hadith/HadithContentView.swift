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
                    HadithChapterListView(hadithBook: presenter.getHadith(of: collector))
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
    var chapter: HadithChapter
    var body: some View {
        List {
            ForEach(self.chapter.hadithList) { hadith in
                VStack(spacing: 10) {
                    HStack {
                        Text(hadith.hadithNo)
                            .frame(alignment: .leading)
                        Spacer()
                        Text(hadith.gradeTranslations.first?.translation ?? "")
                            .frame(alignment: .trailing)
                    }
                    Text(hadith.hadith)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)
                    Text(hadith.hadithTranslations.first?.translation ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(chapter.chapterNo) - \(chapter.titleTranslations.first?.translation ?? "")"))
    }
}

struct HadithChapterListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    var hadithBook: HadithBook
    var body: some View {
        List {
            ForEach(self.hadithBook.chapters) { chapter in
                NavigationLink {
                    HadithListView(chapter: chapter)
                } label: {
                    HStack {
                        Text("\(chapter.chapterNo)").frame(width: 25)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(chapter.titleTranslations.first?.translation ?? "")
                            Text("\(chapter.hadithList.first?.hadithNo ?? "") - \(chapter.hadithList.last?.hadithNo ?? "")").font(.system(size: 14))
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(hadithBook.name)"))
    }
}

struct HadithContentView_Previews: PreviewProvider {
    static var previews: some View {
        HadithContentView().colorScheme(.dark)
    }
}
