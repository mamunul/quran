//
//  HadithViewRouter.swift
//  QuranAndSunnah
//
//  Created by newone on 23/6/22.
//

import SwiftUI

struct HadithViewRouter {
    func routeToHadithListView(chapter: HadithChapter, collector: HadithCollector) -> some View {
        HadithListView(chapter: chapter, collector: collector).environmentObject(HadithPresenter())
    }
}
