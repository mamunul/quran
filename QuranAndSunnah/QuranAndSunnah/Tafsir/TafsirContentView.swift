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
                    presenter.getSurah()
                }
                .environmentObject(presenter)
        }
    }
}

struct TafsirAyahListView: View {
    @EnvironmentObject var presenter: TafsirContentPresenter
    var surah: Surah
    var body: some View {
        List {
            ForEach(surah.ayat) { ayah in
                NavigationLink {
                    TafsirContentView(surah: surah, ayah: ayah)
                        .environmentObject(presenter)
                } label: {
                    VStack(spacing: 10) {
                        Text("\(ayah.ayahNo - surah.firstAyahNo + 1)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(ayah.arabic)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)

                        Text(ayah.translations.first?.translation ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .textSelection(.enabled)
                    }.padding(.vertical)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle(Text("\(surah.nameTransliterations.first?.transliteration ?? "")"))
    }
}

struct TafsirSurahListView: View {
    @EnvironmentObject var presenter: TafsirContentPresenter

    var body: some View {
        List {
            ForEach(self.presenter.quran.surah) { surah in
                NavigationLink {
                    TafsirAyahListView(surah: surah)
                        .environmentObject(presenter)
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

struct TafsirContentView: View {
    @EnvironmentObject var presenter: TafsirContentPresenter
    @State var searchStrinng: String = ""
    var surah: Surah
    var ayah: Ayah

    var body: some View {
        ScrollView {
            HStack {
                TextField("Title", text: $searchStrinng, prompt: Text("search here"))
                    .keyboardType(UIKeyboardType.alphabet)

                Button {
                    presenter.recite()
                } label: {
                    Text("recite")
                }
            }
            .padding(.horizontal)
            Slider(value: $presenter.fontSize, in: presenter.fontRange, step: 1.0)
            TextView(text: $presenter.attributedContent, searchString: $searchStrinng)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .border(.yellow)
                .onAppear {
                    presenter.onViewAppear(surah: surah, ayah: ayah)
                }
        }.navigationTitle(Text("\(surah.nameTransliterations.first?.transliteration ?? "") - \(ayah.ayahNo - surah.firstAyahNo + 1)"))
    }
}

// struct HTMLTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        TafsirContentView(, surah: <#Surah#>)
//    }
// }
