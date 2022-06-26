//
//  SurahListView.swift
//  QuranAndSunnah
//
//  Created by newone on 26/6/22.
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
            DispatchQueue.global().async {
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
    @State var searchString: String = ""
    var body: some View {
        List(self.presenter.surahList) { surah in
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
        .listStyle(PlainListStyle())
        .listStyle(.sidebar)
        .searchable(text: $searchString)
    }
}

struct SurahListView_Previews: PreviewProvider {
    static var previews: some View {
        SurahListView()
    }
}
