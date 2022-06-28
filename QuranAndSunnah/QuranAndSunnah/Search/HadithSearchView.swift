//
//  HadithSearchView.swift
//  QuranAndSunnah
//
//  Created by newone on 28/6/22.
//

import SwiftUI

struct HadithSearchView: View {
    @EnvironmentObject var presenter: SearchPresenter
    @Binding var searchString: String
    @State var filteredHadithList = [HadithText]()
    @State var hadithList = [HadithText]()
    @AppStorage(StorageName.fontSize) var fontSize: Double = 20.0
    var padding: CGFloat = 5
    var body: some View {
        GeometryReader { proxy in
            List(filteredHadithList) { hadith in
                VStack {
                    HStack {
                        Text("\(hadith.hadithNo) : \(hadith.contentId.contentId.getTitle())").padding(5)
                        Spacer()
                        Text("\(hadith.grade)").padding(5)
                    }.padding(.horizontal, padding)
                    TextView(
                        text: .constant(NSMutableAttributedString(string: hadith.matn)),
                        searchString: $searchString,
                        fontSize: fontSize,
                        highlights: [Highlight]()
                    )
                    .padding(.horizontal, padding)
                    .frame(height: TextViewFrameCalculator.frameSize(for: hadith.matn, fontSize: Int(fontSize), width: proxy.size.width - padding * 2, paragraphAlignment: .left).height)
                }.listRowInsets(EdgeInsets())
            }
            .listStyle(PlainListStyle())
            .onChange(of: searchString, perform: { newValue in
                if newValue.isEmpty {
                    self.filteredHadithList = hadithList
                } else {
                    Task.detached(priority: .medium) {
                        let search = await searchString.lowercased()
                        let filteredHadithList = await hadithList.filter({ hadith in
                            hadith.matn.lowercased().contains(search)
                        })
                        await MainActor.run {
                            self.filteredHadithList = filteredHadithList
                        }
                    }
                }
            })
            .onAppear {
                Task.detached(priority: .medium) {
                    let hadithList = await presenter.getHadithList()
                    var filteredHadithList = hadithList
                    let search = await searchString.lowercased()
                    if !search.isEmpty {
                        filteredHadithList = filteredHadithList.filter({ hadith -> Bool in
                            hadith.matn.lowercased().contains(search)
                        })
                    }

                    let filtered = filteredHadithList
                    await MainActor.run {
                        self.hadithList = hadithList
                        self.filteredHadithList = filtered
                    }
                }
            }
        }
    }
}

// struct HadithSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        HadithSearchView()
//    }
// }
