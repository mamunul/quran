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
                .navigationBarItems(trailing: Button(action: {
                    
                }, label: {
                    Image(systemName: "gear")
                }))
                .navigationBarItems(leading: Button(action: {
                    
                }, label: {
                    Image(systemName: "menubar.rectangle")
                }))
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
                        Text("\(surah.surahNo)").frame(width: 50)
                        VStack(alignment: .leading) {
                            Text(surah.nameTransliterations.first!.transliteration)
                                .font(.system(size: 16))
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                            Text(surah.nameTranslations.first!.translation)
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
    var surah: Surah
    var body: some View {
        List {
            ForEach(surah.ayat) { ayah in
                VStack(spacing: 10) {
                    Text("\(ayah.ayahNo - surah.firstAyahNo + 1)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextView(.constant(ayah.arabic))
                        .paragraphStyle(.right)

                    TextView(.constant(ayah.translations.first?.translation ?? ""))
                        .paragraphStyle(.left)
                }.padding(.vertical)
            }
        }
        .navigationTitle(Text("\(surah.nameTransliterations.first?.transliteration ?? "")"))
    }
}

struct NextView: View {
    var body: some View {
        Text("Next View")
    }
}

struct QuranContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuranContentView().colorScheme(.dark)
    }
}
