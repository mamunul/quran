//
//  BookMarkView.swift
//  QuranAndSunnah
//
//  Created by newone on 12/6/22.
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
                            }.padding(.top, 5)
                        }
                    }
                }
            }
        }
    }
}

struct HighlightsView: View {
    @EnvironmentObject var presenter: NotebooksPresenter
    var body: some View {
        List {
            if !presenter.quranHighlights.isEmpty {
                Section(header: Text("Quran")) {
                    ForEach(presenter.quranHighlights) { highlight in
                        VStack {
                            Text("\(highlight.highlightedText)")

                            HStack {
                                Text("Ayat: \(highlight.ayatNo)")
                                Spacer()
                                Text("\(highlight.surahNo): \(presenter.surahNames[highlight.surahNo]?.text ?? "")")

                            }.padding(.top, 5)
                        }
                    }
                }
            }
            if !presenter.hadithHighlights.isEmpty {
                Section(header: Text("Hadith")) {
                    ForEach(presenter.hadithHighlights) { highlight in
                        VStack(alignment: .leading) {
                            Text("\(highlight.highlightedText)")
                            Text("\(highlight.chapterNo): \(presenter.hadithChapters[highlight.id]?.title ?? "")")
                                .padding(.vertical, 5)
                            HStack {
                                Text("Hadith: \(highlight.hadithNo)")
                                Spacer()
                                Text("\(highlight.contentId.contentId.getTitle())")
                            }.padding(.top, 5)
                        }
                    }
                }
            }
            if !presenter.tafsirHighlights.isEmpty {
                Section(header: Text("Tafsir")) {
                    ForEach(presenter.tafsirHighlights) { highlight in
                        VStack(alignment: .leading) {
                            Text("\(highlight.highlightedText)")

                            HStack {
                                Text("Ayat: \(highlight.tafsirAyah.ayahRange.description)")
                                Spacer()
                                Text("\(highlight.surahNo): \(presenter.surahNames[highlight.surahNo]?.text ?? "")")

                            }.padding(.top, 5)
                        }
                    }
                }
            }
        }
    }
}

struct SuggestedView: View {
    var body: some View {
        TabView {
            HStack {
                Text("SuggestedView 1")
            }

            HStack {
                Text("SuggestedView 2")
            }

            HStack {
                Text("SuggestedView 3")
            }
        }
        .frame(height: 200)
        .tabViewStyle(.page)
    }
}

struct NoteBookView: View {
    @StateObject var presenter = NotebooksPresenter()
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Highlights")
                        .padding()
                }
                NavigationLink {
                    BookmarksView()
                } label: {
                    Text("Bookmarks")
                        .padding()
                }
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Tags")
                        .padding()
                }
                NavigationLink {
                    HighlightsView()
                } label: {
                    Text("Notes")
                        .padding()
                }
                SuggestedView()
                Spacer()
            }
            .listStyle(PlainListStyle())
        }.onAppear {
            presenter.loadSurah()
            presenter.getBookmarks()
            presenter.getHighlights()
        }
        .environmentObject(presenter)
    }
}

struct BookMarkView_Previews: PreviewProvider {
    static var previews: some View {
        NoteBookView()
    }
}
