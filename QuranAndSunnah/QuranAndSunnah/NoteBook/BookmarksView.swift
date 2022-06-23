//
//  BookmarksView.swift
//  QuranAndSunnah
//
//  Created by newone on 23/6/22.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var presenter: NotebooksPresenter
    var body: some View {
        List {
            if !presenter.quranBookmarks.isEmpty {
                Section(header: Text("Quran")) {
                    ForEach(presenter.quranBookmarks) { highlight in
                        NavigationLink {
                            QuranViewRouter()
                                .routeToAyahListView(
                                    surah: presenter.surahInfo[highlight.surahNo]!,
                                    surahTransliteration: presenter.surahNames[highlight.surahNo]!
                                )

                        } label: {
                            HStack {
                                Text("Ayat: \(highlight.ayatNo - presenter.surahInfo[highlight.surahNo]!.firstAyahNo + 1)")
                                Spacer()
                                Text("\(highlight.surahNo): \(presenter.surahNames[highlight.surahNo]?.text ?? "")")
                            }
                        }
                    }.onDelete(perform: deleteQuranBookmark(at:))
                }
            }
            if !presenter.hadithBookmarks.isEmpty {
                Section(header: Text("Hadith")) {
                    ForEach(presenter.hadithBookmarks) { highlight in
                        NavigationLink {
                            HadithViewRouter()
                                .routeToHadithListView(
                                    chapter: presenter.hadithChapters[highlight.id]!,
                                    collector: presenter.hadithCollectors[highlight.id] ?? .none
                                )
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(highlight.chapterNo): \($presenter.hadithChapters[highlight.id].wrappedValue?.title ?? "")")
                                HStack {
                                    Text("Hadith: \(highlight.hadithNo)")

                                    Spacer()
                                    Text("\(highlight.contentId.contentId.getTitle())")
                                }
                                .padding(.top, 5)
                            }
                        }
                    }.onDelete(perform: deleteHadithBookmark(at:))
                }
            }
        }
    }

    func deleteHadithBookmark(at offsets: IndexSet) {
        let deleteItem = presenter.hadithBookmarks[offsets.first!]
        presenter.hadithBookmarks.remove(atOffsets: offsets)
        presenter.delete(bookmark: deleteItem)
    }

    func deleteQuranBookmark(at offsets: IndexSet) {
        let deleteItem = presenter.quranBookmarks[offsets.first!]
        presenter.quranBookmarks.remove(atOffsets: offsets)
        presenter.delete(bookmark: deleteItem)
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView().environmentObject(NotebooksPresenter())
    }
}
