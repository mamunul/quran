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
                        Text(collector.contentId.contentId.getTitle())
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .listStyle(.sidebar)
    }
}

struct HadithChapterListView: View {
    @EnvironmentObject var presenter: HadithPresenter
    var collector: HadithCollector
    @State var filteredList = [HadithChapter]()
    @State var chapterList = [HadithChapter]()
    @State var searchString = ""
    var body: some View {
        List(self.filteredList) { chapter in
            NavigationLink {
                HadithListView(chapter: chapter, collector: collector, searchString: searchString)
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
        .listStyle(PlainListStyle())
        .listStyle(.sidebar)
        .navigationTitle(Text("\(self.collector.name)"))
        .searchable(text: $searchString)
        .onChange(of: searchString) { newValue in
            DispatchQueue.global().async {
                var filterList = chapterList
                if !searchString.isEmpty {
                    filterList = presenter.search(in: filteredList, collector: collector, searchString: searchString)
                }
                DispatchQueue.main.async {
                    self.filteredList = filterList
                }
            }
        }
        .onAppear {
            DispatchQueue.global().async {
                let chapterList = presenter.getChapterList(collector: collector)
                var filterList = chapterList
                if !searchString.isEmpty {
                    filterList = presenter.search(in: filterList, collector: collector, searchString: searchString)
                }
                DispatchQueue.main.async {
                    self.chapterList = chapterList
                    self.filteredList = filterList
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
