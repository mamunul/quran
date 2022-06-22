//
//  TafsirRepository.swift
//  QuranAndSunnah
//
//  Created by newone on 2/6/22.
//

import Foundation

struct TafsirContentConfiguration {
    var arabicFontSize: Int
    var titleFontSize: Int
    var englishFontSize: Int
    var arabicBackgroundColor: String
}

protocol ITafsirRead {
    func getTafsirAyat(surah: SurahInfo) throws -> [TafsirAyah]
    func getContent(ayah: TafsirAyah, configuraiton: TafsirContentConfiguration) throws -> NSMutableAttributedString
}

class TafsirRepository: ITafsirRead {
    enum TafsirError: Error {
        case nilData
    }

    func getTafsirAyat(surah: SurahInfo) throws -> [TafsirAyah] {
        let folder = "/Tafsir/IbnKathir/"

        let surahFolder = folder.appending("\(surah.surahNo)/")
        let surahPath = Bundle.main.bundlePath.appending(surahFolder)
        let contents =
            try FileManager.default.contentsOfDirectory(atPath: surahPath)
                .sorted(by: { left, right in
                    let leftayahNo = Int((left as NSString).deletingPathExtension)!
                    let rightayahNo = Int((right as NSString).deletingPathExtension)!
                    return leftayahNo < rightayahNo
                })
        var ayat = [TafsirAyah]()
        for index in 0 ..< contents.count {
            let ayahFileName = contents[index]
            let ayahNo = Int((ayahFileName as NSString).deletingPathExtension)!
            var nextayahNo = ayahNo

            if index + 1 < contents.count {
                let nextayahFileName = contents[index + 1]
                nextayahNo = Int((nextayahFileName as NSString).deletingPathExtension)!
                nextayahNo -= 1
            }
            let ayayPath = "Tafsir/IbnKathir/".appending("\(surah.surahNo)/").appending(ayahFileName)
            let contentId =
                ContentIdentity<TafsirContentID>(
                    contentId: .ibnKathir_shahih,
                    lang: .en,
                    contentType: .translation
                )
            let ayah = TafsirAyah(
                id: ayahNo,
                ayahRange: ayahNo ... nextayahNo,
                filePath: ayayPath,
                surahNo: surah.surahNo,
                contentId: contentId
            )
            ayat.append(ayah)
        }
        return ayat
    }

    func getContent(ayah: TafsirAyah, configuraiton: TafsirContentConfiguration) throws -> NSMutableAttributedString {
        let header = getHeader(configuraiton)
        let footer = getFooter()

        let fileUrl = Bundle.main.url(forResource: ayah.filePath, withExtension: "")!

        let body = try String(contentsOf: fileUrl)

        let content = header + body + footer

        guard let data = content.data(using: .utf8) else { throw TafsirError.nilData }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] =
            [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue),
            ]
        let nsAttributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        return nsAttributedString
    }

//    func getContent(ayah: TafsirAyah2, configuraiton: TafsirContentConfiguration) throws -> NSMutableAttributedString {
//        let fileName = "Tafsir/IbnKathir/\(ayah.surahNo)/\(ayah.ayahRange.lowerBound).html"
    ////        let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "")!
//
//        return try getContent(ayahUrl: fileName, configuraiton: configuraiton)
//    }

    private func getHeader(_ configuraiton: TafsirContentConfiguration) -> String {
        let header =
            """
            <!doctype html>
            <html>
              <head>
                <style>
                  html,
                  body {
                  }

                  div.content {
                    font-size: \(configuraiton.englishFontSize)px;/* english text fontsize */
                  }
                    .tafsir-content .title {
                        font-weight:600!important;
                        margin-top: 5px;
                    }
                  p {
                    margin-top: 0
                    margin-bottom: 1rem;
                  }

                  p {
                    display: block
                    margin-block-start: 1em;
                    margin-block-end: 1em;
                    margin-inline-start: 0px;
                    margin-inline-end: 0px;
                    text-align:justify;
                  }

                  div.title,
                  div.tafsir-ayah {
                    border: 2px solid black;
                    font-size: \(configuraiton.titleFontSize)px;/* english title fontsize */
                  }

                  .arabic-ayah-tafsir {
                    font-family: me_quran;
                    font-size: \(configuraiton.arabicFontSize)px;/* arabic text fontsize */
                    /* background: #f8f8f8; /* light - #f8f8f8  dark - #1c1c1c */ */
                  }

                  .arabic-ayah-tafsir {
                    text-align: -webkit-right;
                    direction: rtl;
                    unicode-bidi: isolate;
                  }
                </style>
              </head>
              <body>
            """

        return header
    }

    private func getFooter() -> String {
        let header =
            """
                    </body>
                  </html>
            """

        return header
    }
}
