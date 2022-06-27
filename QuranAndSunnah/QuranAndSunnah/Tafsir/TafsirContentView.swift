//
//  HTMLTextView.swift
//  Sample
//
//  Created by newone on 26/5/22.
//

import Combine
import SwiftUI

struct TafsirMainView: View {
    @StateObject var presenter = TafsirContentPresenter()
    var body: some View {
        NavigationView {
            TafsirSurahListView()
                .onAppear {
                    Task {
                        presenter.getSurahList()
                        presenter.getSurahTranslationList()
                        presenter.getSurahTransliterationList()
                        presenter.getSurahArabicList()
                    }
                }
                .environmentObject(presenter)
        }
    }
}

struct TafsirAyahListView: View {
    @EnvironmentObject var presenter: TafsirContentPresenter
    var surah: SurahInfo
    var surahTransliteration: SurahName
    @State var ayat = [TafsirAyah]()
    var body: some View {
        List(ayat) { ayah in
            NavigationLink {
                TafsirContentView(surah: surah, ayah: ayah, surahTransliteration: surahTransliteration)
                    .environmentObject(presenter)
            } label: {
                VStack(spacing: 10) {
                    Text(getAyahNo(ayah: ayah))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.vertical)
            }
        }
        .listStyle(PlainListStyle())
        .listStyle(.sidebar)
        .navigationTitle(Text(surahTransliteration.text))
        .onAppear {
            DispatchQueue.global().async {
                let ayat = presenter.getAyat(of: surah)
                DispatchQueue.main.async {
                    self.ayat = ayat
                }
            }
        }
    }

    func getAyahNo(ayah: TafsirAyah) -> String {
        if ayah.ayahRange.count == 1 {
            return "\(ayah.ayahRange.lowerBound)"
        } else {
            return "\(ayah.ayahRange.lowerBound)-\(ayah.ayahRange.upperBound)"
        }
    }
}

struct TafsirSurahListView: View {
    @EnvironmentObject var presenter: TafsirContentPresenter

    var body: some View {
        List(self.presenter.surahList) { surah in
            NavigationLink {
                TafsirAyahListView(surah: surah, surahTransliteration: presenter.surahTranslilerationList[surah.surahNo]!)
                    .environmentObject(presenter)
            } label: {
                HStack {
                    Text("\(surah.surahNo)").frame(width: 50)
                    Text(presenter.surahTranslilerationList[surah.surahNo]!.text)
                        .font(.system(size: 16))
                        .frame(alignment: .leading)
                        .multilineTextAlignment(.leading)

                    Spacer()
                    Text("\(surah.ayahCount)")
                        .font(.system(size: 13))
                }
            }
            .isDetailLink(false)
        }
        .listStyle(PlainListStyle())
        .listStyle(.sidebar)
        .navigationTitle("Tafsir Ibn Kathir")
    }
}

struct TafsirContentView: View {
    @EnvironmentObject var presenter: TafsirContentPresenter
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    @State var searchString: String = ""
    @State private var showingPopover = false
    var surah: SurahInfo
    var ayah: TafsirAyah
    var surahTransliteration: SurahName
    @State var highlights = [Highlight]()
    var padding: CGFloat = 5
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                TextView(
                    text: $presenter.attributedContent,
                    searchString: self.$searchString,
                    paragraphAlignment: .none,
                    fontSize: nil,
                    highlights: highlights,
                    onHighlight: { highlightedString in
                        presenter.onHighlightEvent(textRange: highlightedString)
                    },
                    onUnhighlight: { highlight in
                        presenter.remove(highlight: highlight, from: ayah)
                    }
                )
                .padding(.horizontal, padding)
                .frame(height: frameSize(for: presenter.attributedContent, width: proxy.size.width - padding * 2).height)
                .onAppear {
                    DispatchQueue.global().async {
                        presenter.onViewAppear(ayah: ayah, fontSize: fontSize)
                        let highlights = presenter.getHighlights(of: ayah)
                        DispatchQueue.main.async {
                            self.highlights = highlights
                        }
                    }
                }
            }
            .searchable(text: $searchString)
            .navigationTitle(Text(getAyahNo(ayah: ayah)))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        presenter.recite()
                    } label: {
                        Text("recite")
                    }
                    Button(action: {
                        showingPopover = true
                    }, label: {
                        Image(systemName: "gear")
                    }).alwaysPopover(isPresented: $showingPopover) {
                        SettingsView()
                    }
                }
            }
            .onChange(of: fontSize) { newValue in
                DispatchQueue.global().async {
                    presenter.updateFontSize(newValue)
                }
            }
        }
    }

    func getAyahNo(ayah: TafsirAyah) -> String {
        if ayah.ayahRange.count == 1 {
            return "\(surahTransliteration.text)  - \(ayah.ayahRange.lowerBound)"
        } else {
            return "\(surahTransliteration.text)  - \(ayah.ayahRange.lowerBound)-\(ayah.ayahRange.upperBound)"
        }
    }

    func frameSize(for attributedText: NSMutableAttributedString, width: CGFloat) -> CGSize {
        let textView = CustomUITextView()
        textView.frame.size.width = width

        textView.attributedText = attributedText

        let rect = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude))
        return rect
    }
}

// struct HTMLTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        TafsirContentView(, surah: <#Surah#>)
//    }
// }
