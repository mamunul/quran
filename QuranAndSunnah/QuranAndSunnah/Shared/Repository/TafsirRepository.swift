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

class TafsirRepository {
    enum TafsirError: Error {
        case nilData
    }

    func getContent(surah: Int, ayah: Int, configuraiton: TafsirContentConfiguration) throws -> NSMutableAttributedString {
        let fileName = "Tafsir/IbnKathir/\(surah)/\(ayah).html"
        let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "")!

        let header = getHeader(configuraiton)
        let footer = getFooter()

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
