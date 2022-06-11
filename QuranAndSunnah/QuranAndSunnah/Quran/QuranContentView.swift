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
                presenter.getQuran()
            }
        }
    }
}

struct SurahListView: View {
    @EnvironmentObject var presenter: QuranPresenter
    var body: some View {
        List {
            ForEach(self.presenter.quran.surah) { surah in
                NavigationLink {
                    SurahContentView(surah: surah)
                } label: {
                    HStack {
                        Text("\(surah.surahNo)").frame(width: 50)
                        VStack(alignment: .leading) {
                            Text(surah.nameTransliterations.first!.text)
                                .font(.system(size: 16))
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                            Text(surah.nameTranslations.first!.text)
                                .font(.system(size: 14))
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(surah.name)
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
    @State var searchString: String = ""
    @State private var showingPopover = false
    @State private var surah: Surah
    private var all: Surah
    init(surah: Surah) {
        all = surah
        self.surah = surah
    }

    var body: some View {
        GeometryReader { proxy in
            List {
                ForEach(surah.ayat) { ayah in
                    VStack(spacing: 10) {
                        Text("\(ayah.ayahNo - surah.firstAyahNo + 1)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextViewRepresentable2(
                            text: .constant(NSMutableAttributedString(string: ayah.arabic)),
                            searchString: self.$searchString,
                            paragraphAlignment: .right,
                            fontSize: fontSize
                        )
                        .frame(height: frameSize(for: ayah.arabic, fontSize: Int(fontSize), width: proxy.size.width, paragraphAlignment: .right).height)

                        TextViewRepresentable2(
                            text: .constant(NSMutableAttributedString(string: ayah.translations.first?.text ?? "")),
                            searchString: self.$searchString,
                            paragraphAlignment: .left,
                            fontSize: fontSize
                        )
                        .frame(height: frameSize(for: ayah.translations.first?.text ?? "", fontSize: Int(fontSize), width: proxy.size.width, paragraphAlignment: .left).height)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchString)
            .onChange(of: searchString) { newValue in
                Task {
                    if newValue.isEmpty {
                        surah.ayat = all.ayat
                    } else {
                        let newList = all.ayat.filter { $0.translations.first?.text.localizedCaseInsensitiveContains(newValue) ?? false }
                        surah.ayat = newList
                    }
                }
            }
            .navigationTitle(Text("\(surah.nameTransliterations.first?.text ?? "")"))
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
