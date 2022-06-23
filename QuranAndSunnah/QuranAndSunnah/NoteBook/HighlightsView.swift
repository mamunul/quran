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
                        NavigationLink {
                            QuranViewRouter().routeToAyahListView(surah: presenter.surahInfo[highlight.surahNo]!, surahTransliteration: presenter.surahNames[highlight.surahNo]!)

                        } label: {
                            VStack {
                                Text("\(highlight.highlightedText)")

                                HStack {
                                    Text("Ayat: \(highlight.ayatNo)")
                                    Spacer()
                                    Text("\(highlight.surahNo): \(presenter.surahNames[highlight.surahNo]?.text ?? "")")

                                }.padding(.top, 5)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    presenter.delete(highlight: highlight)
                                } label: {
                                    Label("Delete", systemImage: "delete")
                                }
                            }
                        }
                    }.onDelete(perform: deleteQuranHighlights(at:))
                }
            }
            if !presenter.hadithHighlights.isEmpty {
                Section(header: Text("Hadith")) {
                    ForEach(presenter.hadithHighlights) { highlight in
                        NavigationLink {
                            HadithViewRouter()
                                .routeToHadithListView(
                                    chapter: presenter.hadithChapters[highlight.id]!,
                                    collector: presenter.hadithCollectors[highlight.id] ?? .none
                                )
                        } label: {
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
                    .onDelete(perform: deleteHadithHighlights(at:))
                }
            }
            if !presenter.tafsirHighlights.isEmpty {
                Section(header: Text("Tafsir")) {
                    ForEach(presenter.tafsirHighlights) { highlight in
                        NavigationLink {
                            TafsirViewRouter()
                                .routeToTafsirView(
                                    surah: presenter.surahInfo[highlight.surahNo]!,
                                    ayah: highlight.tafsirAyah,
                                    surahTransliteration: presenter.surahNames[highlight.surahNo]!
                                )

                        } label: {
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
                    .onDelete(perform: deleteTafsirHighlights(at:))
                }
            }
        }
    }

    func deleteTafsirHighlights(at offsets: IndexSet) {
        let deleteItem = presenter.tafsirHighlights[offsets.first!]
        presenter.tafsirHighlights.remove(atOffsets: offsets)
        presenter.delete(highlight: deleteItem)
    }

    func deleteHadithHighlights(at offsets: IndexSet) {
        let deleteItem = presenter.hadithHighlights[offsets.first!]
        presenter.hadithHighlights.remove(atOffsets: offsets)
        presenter.delete(highlight: deleteItem)
    }

    func deleteQuranHighlights(at offsets: IndexSet) {
        let deleteItem = presenter.quranHighlights[offsets.first!]
        presenter.quranHighlights.remove(atOffsets: offsets)
        presenter.delete(highlight: deleteItem)
    }
}

struct HighlightsView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightsView()
    }
}
