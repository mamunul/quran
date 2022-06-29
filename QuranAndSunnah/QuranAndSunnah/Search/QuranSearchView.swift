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
                    .frame(height: TextViewFrameCalculator().frameSize(for: ayah.text, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .left).height)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
            .onChange(of: searchString, perform: { newValue in
                if newValue.isEmpty {
                    self.filteredAyat = allAyat
                } else {
                    Task.detached {
                        let search = await searchString.lowercased()
                        let filteredAyat = await allAyat.filter({ ayah in
                            ayah.text.lowercased().contains(search)
                        })
                        await MainActor.run {
                            self.filteredAyat = filteredAyat
                        }
                    }
                }
            })
            .onAppear {
                Task.detached {
                    async let allAyat1 = presenter.getAyatTranslation()
                    async let surahNames1 = presenter.getSurahTransliterationList()
                    async let surahList1 = presenter.getSurahList()

                    var filteredAyat1 = await allAyat1
                    let search = await searchString.lowercased()
                    if !search.isEmpty {
                        filteredAyat1 = filteredAyat1.filter({ ayah in
                            ayah.text.lowercased().contains(search)
                        })
                    }

                    let (surahNames, surahList, allAyat, filteredAyat) = await(surahNames1, surahList1, allAyat1, filteredAyat1)
                    await MainActor.run {
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

// struct QuranSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuranSearchView()
//    }
// }
