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
            Task {
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await presenter.getSurahList()
                    }
                    group.addTask {
                        await presenter.getSurahTranslationList()
                    }

                    group.addTask {
                        await presenter.getSurahTransliterationList()
                    }

                    group.addTask {
                        await presenter.getSurahArabicList()
                    }
                }
            }
        }
    }
}

struct SurahListView: View {
    @EnvironmentObject var presenter: QuranPresenter
    @State var searchString: String = ""
    @State var surahList = [SurahInfo]()
    var body: some View {
        List(self.surahList) { surah in
            NavigationLink {
                SurahContentView(
                    surah: surah,
                    surahTransliteration: presenter.surahTranslilerationList[surah.surahNo] ?? .empty,
                    searchString: searchString
                )
            } label: {
                HStack {
                    Text("\(surah.surahNo)").frame(width: 50)
                    VStack(alignment: .leading) {
                        Text(presenter.surahTranslilerationList[surah.surahNo]?.text ?? "")
                            .font(.system(size: 16))
                            .frame(alignment: .leading)
                            .multilineTextAlignment(.leading)
                        Text(presenter.surahTranslationList[surah.surahNo]?.text ?? "")
                            .font(.system(size: 14))
                            .frame(alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(presenter.surahArabicList[surah.surahNo]?.text ?? "")
                        Text("\(surah.ayahCount)")
                            .font(.system(size: 13))
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .listStyle(.sidebar)
        .searchable(text: $searchString)
        .onChange(of: searchString) { newValue in

            if newValue.isEmpty {
                surahList = self.presenter.surahList
            } else {
                Task.detached {
                    let surahList = await presenter.searchInSurahAndAyat(searchString: newValue) // presenter.filterbySurahNames(newValue)
                    await MainActor.run {
                        self.surahList = surahList
                    }
                }
            }
        }
        .onChange(of: self.presenter.surahList) { _ in
            surahList = self.presenter.surahList
        }
        .navigationTitle("All Surah")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SurahListView_Previews: PreviewProvider {
    static var previews: some View {
        SurahListView()
    }
}
