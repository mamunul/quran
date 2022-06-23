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
                        HStack {
                            Text("Ayat: \(highlight.ayatNo)")
                            Spacer()
                            Text("\(highlight.surahNo): \(presenter.surahNames[highlight.surahNo]?.text ?? "")")
                        }
                    }
                }
            }
            if !presenter.hadithBookmarks.isEmpty {
                Section(header: Text("Hadith")) {
                    ForEach(presenter.hadithBookmarks) { highlight in
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
                }
            }
        }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView().environmentObject(NotebooksPresenter())
    }
}
