//
//  QuranViewRouter.swift
//  QuranAndSunnah
//
//  Created by newone on 23/6/22.
//

import SwiftUI

struct QuranViewRouter {
    @MainActor func routeToAyahListView(surah: SurahInfo, surahTransliteration: SurahName) -> some View {
        SurahContentView(surah: surah, surahTransliteration: surahTransliteration).environmentObject(QuranPresenter())
    }
}
