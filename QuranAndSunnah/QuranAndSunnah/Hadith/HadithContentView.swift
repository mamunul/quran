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

                Text(hadith.hadith)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                Text(hadith.hadithTranslations.first?.translation ?? "")
            }
        }.listStyle(.sidebar)
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
                        Text(chapter.titleTranslations.first?.translation ?? "")
                    }
                }
            }
        }.listStyle(.sidebar)
    }
}

struct HadithContentView_Previews: PreviewProvider {
    static var previews: some View {
        HadithContentView()
    }
}
