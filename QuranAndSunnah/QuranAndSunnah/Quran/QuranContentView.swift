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
            presenter.getQuran()
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
                        Text(surah.name)
                        Text(surah.nameTransliterations.first!.transliteration)
                        Text(surah.nameTranslations.first!.translation)
                    }
                }
            }
        }.listStyle(.sidebar)
    }
}

struct SurahContentView: View {
    @EnvironmentObject var presenter: QuranPresenter
    var surah: Surah
    var body: some View {
        List {
            ForEach(surah.ayat) { ayah in
                VStack {
                    Text(ayah.arabic)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .multilineTextAlignment(.trailing)

                    Text(ayah.translations.first?.translation ?? "")
                }
            }
        }
    }
}

struct NextView: View {
    var body: some View {
        Text("Next View")
    }
}

struct QuranContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuranContentView()
    }
}
