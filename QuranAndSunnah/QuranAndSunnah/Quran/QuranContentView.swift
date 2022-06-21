//
//  QuranContentView.swift
//  QuranAndSunnah
//
//  Created by Mamunul Mazid on 3/6/22.
//

import SwiftUI

struct QuranContentView: View {
    @StateObject var presenter = QuranPresenter()
    var body: some View {
        NavigationView {
            SurahListView()
        }

        .environmentObject(presenter)
        .onAppear {
            Task {
                presenter.getSurahList()
                presenter.getSurahTranslationList()
                presenter.getSurahTransliterationList()
                presenter.getSurahArabicList()
            }
        }
    }
}

struct SurahListView: View {
    @EnvironmentObject var presenter: QuranPresenter
    var body: some View {
        List {
            ForEach(self.presenter.surahList) { surah in
                NavigationLink {
                    SurahContentView(surah: surah, surahTransliteration: presenter.surahTranslilerationList[surah.surahNo]!)
                } label: {
                    HStack {
                        Text("\(surah.surahNo)").frame(width: 50)
                        VStack(alignment: .leading) {
                            Text(presenter.surahTranslilerationList[surah.surahNo]!.text)
                                .font(.system(size: 16))
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                            Text(presenter.surahTranslationList[surah.surahNo]!.text)
                                .font(.system(size: 14))
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(presenter.surahArabicList[surah.surahNo]!.text)
                            Text("\(surah.ayahCount)")
                                .font(.system(size: 13))
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
    }
}

struct SurahContentView: View {
    @EnvironmentObject var presenter: QuranPresenter
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    @State var surah: SurahInfo
    @State var surahTransliteration: SurahName
    @State var searchString: String = ""
    @State var showingPopover = false

    @State var filteredAyat = [Ayah]()
    @State var ayat = [Ayah]()
    @State var ayatTranslation = [Int: Ayah]()

    var body: some View {
        GeometryReader { proxy in
            List {
                ForEach(filteredAyat) { ayah in
                    VStack(spacing: 10) {
                        Text("\(ayah.ayahNo - surah.firstAyahNo + 1)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextView(
                            text: .constant(NSMutableAttributedString(string: ayah.text)),
                            searchString: self.$searchString,
                            paragraphAlignment: .right,
                            fontSize: fontSize
                        )
                        .frame(height: frameSize(for: ayah.text, fontSize: Int(fontSize), width: proxy.size.width, paragraphAlignment: .right).height)

                        TextView(
                            text: .constant(NSMutableAttributedString(string: ayatTranslation[ayah.ayahNo]!.text)),
                            searchString: self.$searchString,
                            paragraphAlignment: .left,
                            fontSize: fontSize
                        )
                        .frame(height: frameSize(for: ayatTranslation[ayah.ayahNo]!.text, fontSize: Int(fontSize), width: proxy.size.width, paragraphAlignment: .left).height)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchString)
            .onChange(of: searchString) { newValue in
                Task {
                    if newValue.isEmpty {
                        filteredAyat = ayat
                    } else {
                        let newList = ayat.filter { ayatTranslation[$0.ayahNo]?.text.localizedCaseInsensitiveContains(newValue) ?? false }
                        filteredAyat = newList
                    }
                }
            }
            .navigationTitle(Text(surahTransliteration.text))
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
            }.onAppear {
                Task {
                    ayat = presenter.getAyat(of: surah)
                    filteredAyat = ayat
                    ayatTranslation = presenter.getAyatTranslation(of: surah)
                }
            }
        }
    }

    func frameSize(for text: String, fontSize: Int, width: CGFloat, paragraphAlignment: CustomTextAlignment) -> CGSize {
        let attributedText = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        var attribute: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        switch paragraphAlignment {
        case .justify:
            paragraphStyle.alignment = .justified
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .left:
            paragraphStyle.alignment = .left
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .right:
            paragraphStyle.alignment = .right
            let attribute2 = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
            attribute += attribute2
        case .none:
            paragraphStyle.alignment = .natural
        }

        let attribute3: [NSAttributedString.Key: Any] = [NSAttributedString.Key.kern: 0]
        attribute += attribute3

        attributedText.addAttributes(attribute, range: fullRange)

        let textView = CustomUITextView()
        textView.frame.size.width = width

        textView.attributedText = attributedText

        let rect = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude))
        return rect
    }
}

struct QuranContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuranContentView().colorScheme(.dark)
    }
}
