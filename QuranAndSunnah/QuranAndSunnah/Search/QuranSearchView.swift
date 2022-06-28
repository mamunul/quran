//
//  QuranSearchView.swift
//  QuranAndSunnah
//
//  Created by newone on 28/6/22.
//

import SwiftUI

struct QuranSearchView: View {
    @EnvironmentObject var presenter: SearchPresenter
    @Binding var searchString: String
    @State var filteredAyat = [Ayah]()
    @State var allAyat = [Ayah]()
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    var padding: CGFloat = 5
    @State var surahTranslilerationList = [Int: SurahName]()
    @State var surahList = [SurahInfo]()
    var body: some View {
        GeometryReader { proxy in
            List(filteredAyat) { ayah in
                VStack {
                    HStack {
                        Text("\(ayah.surahNo): \(surahTranslilerationList[ayah.surahNo]?.text ?? "")").padding(5)
                        Spacer()
                        Text("\(ayah.ayahNo - surahList[ayah.surahNo - 1].firstAyahNo + 1)").padding(5)
                    }.padding(.horizontal, padding)
                    TextView(
                        text: .constant(NSMutableAttributedString(string: ayah.text)),
                        searchString: $searchString,
                        fontSize: fontSize,
                        highlights: [Highlight]()
                    )
                    .padding(.horizontal, padding)
                    .frame(height: TextViewFrameCalculator.frameSize(for: ayah.text, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .left).height)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
            .onChange(of: searchString, perform: { newValue in
                if newValue.isEmpty {
                    self.filteredAyat = allAyat
                } else {
                    Task(priority: .utility) {
                        let filteredAyat = allAyat.filter({ ayah in
                            ayah.text.lowercased().contains(searchString.lowercased())
                        })
                        Task(priority: .userInitiated) {
                            self.filteredAyat = filteredAyat
                        }
                    }
                }
            })
            .onAppear {
                Task(priority: .utility) {
                    let allAyat = presenter.getAyatTranslation()
                    var filteredAyat = allAyat
                    if !searchString.isEmpty {
                        filteredAyat = allAyat.filter({ ayah in
                            ayah.text.lowercased().contains(searchString.lowercased())
                        })
                    }
                    let surahNames = presenter.getSurahTransliterationList()
                    let surahList = presenter.getSurahList()
                    Task(priority: .userInitiated) {
                        self.surahTranslilerationList = surahNames
                        self.surahList = surahList
                        self.allAyat = allAyat
                        self.filteredAyat = filteredAyat
                    }
                }
            }
        }
    }
}

//struct QuranSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuranSearchView()
//    }
//}
