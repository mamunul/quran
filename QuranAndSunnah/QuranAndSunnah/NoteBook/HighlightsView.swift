//
//  HighlightsView.swift
//  QuranAndSunnah
//
//  Created by newone on 23/6/22.
//

import SwiftUI

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


struct HighlightsView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightsView()
    }
}
