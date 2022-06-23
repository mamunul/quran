//
//  TafsirViewRouter.swift
//  QuranAndSunnah
//
//  Created by newone on 23/6/22.
//

import SwiftUI

struct TafsirViewRouter {
    func routeToTafsirView(surah: SurahInfo, ayah: TafsirAyah, surahTransliteration: SurahName) -> some View {
        TafsirContentView(surah: surah, ayah: ayah, surahTransliteration: surahTransliteration)
            .environmentObject(TafsirContentPresenter())
    }
}
