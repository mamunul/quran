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
        List {
            ForEach(surah.ayat) { ayah in
                VStack(spacing: 10) {
                    Text("\(ayah.ayahNo - surah.firstAyahNo + 1)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextView(.constant(ayah.arabic))
                        .paragraphStyle(.right)
                        .fontSize(fontSize)

                    TextView(.constant(ayah.translations.first?.translation ?? ""), searchString: $searchString)
                        .paragraphStyle(.left)
                        .fontSize(fontSize)
                }.padding(.vertical)
            }
        }
        .searchable(text: $searchString)
        .onChange(of: searchString) { newValue in
            Task {
                if newValue.isEmpty {
                    surah.ayat = all.ayat
                } else {
                    let newList = all.ayat.filter { $0.translations.first?.translation.localizedCaseInsensitiveContains(newValue) ?? false }
                    surah.ayat = newList
                }
            }
        }
        .navigationTitle(Text("\(surah.nameTransliterations.first?.transliteration ?? "")"))
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
//        .sheet(isPresented: $showingPopover) {
//            SettingsView()
//        }
    }
}

struct QuranContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuranContentView().colorScheme(.dark)
    }
}
