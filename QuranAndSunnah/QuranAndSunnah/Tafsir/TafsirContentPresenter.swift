//
//  TafsirContentPresenter.swift
//  HTMLTextAttributes
//
//  Created by newone on 29/5/22.
//

import AVFoundation
import Foundation
import UIKit

class TafsirContentPresenter: ObservableObject {
    @Published var attributedContent = NSMutableAttributedString(string: "")
    private let synthesizer = AVSpeechSynthesizer()
    private var utterance: AVSpeechUtterance?
    private var isPlaying = false
//    private var surah: SurahInfo?
    private var ayah: TafsirAyah?
    private var tafsirRepository: ITafsirRead = TafsirRepository()
    @Published var surahList = [SurahInfo]()
    @Published var surahArabicList = [Int: SurahName]()
    @Published var surahTranslationList = [Int: SurahName]()
    @Published var surahTranslilerationList = [Int: SurahName]()
    private var repository = QuranJsonFacade.shared
    private var previousFontSize: Double = 15.0
    private var notebookRepo = TafsirNotebookRepository()

    func getHighlights(of ayah: TafsirAyah) -> [Highlight] {
        var highlights = [Highlight]()
        do {
            let tafsirHighlights = try notebookRepo.getHighlights(for: ayah)

            highlights = tafsirHighlights.map { hadith in
                Highlight(
                    id: UUID(),
                    range: hadith.markedRange,
                    markedText: hadith.highlightedText,
                    chapterTitle: "\(hadith.surahNo)",
                    contentNo: "AyatNo:\(hadith.tafsirAyah.ayahRange.lowerBound)",
                    bookName: "IbnKathir:\(hadith.tafsirAyah.contentId.contentId.getFilePath())"
                )
            }
        } catch {
            print(error)
        }

        return highlights
    }

    func remove(highlight: Highlight, from ayah: TafsirAyah) {
        let quranHighlight =
            TafsirHighlight(
                markedRange: highlight.range,
                highlightedText: highlight.markedText,
                tafsirAyah: ayah,
                surahNo: ayah.surahNo
            )
        do {
            try notebookRepo.remove(highlight: quranHighlight)
        } catch {
            print(error)
        }
    }

    func onHighlightEvent(textRange: ClosedRange<Int>) {
//        print(textRange)

        let markedString = attributedContent.attributedSubstring(from: NSRange(textRange)).string
//        let highlight =
//            TafsirHighlight(range: textRange, highlightedText: markedString, tafsirAyah: ayah!, surahNo: ayah!.surahNo)
        do {
            var ayatHighlights: [IHighlight] = try notebookRepo.getHighlights(for: ayah!)

            let highlight =
                TafsirHighlight(
                    markedRange: textRange,
                    highlightedText: markedString,
                    tafsirAyah: ayah!,
                    surahNo: ayah!.surahNo
                )

            ayatHighlights.append(highlight)
            MergeVisitor().mergeOverlapped(collection: &ayatHighlights)

            try notebookRepo.save(highlights: ayatHighlights as! [TafsirHighlight], for: ayah!)
        } catch {
            print(error)
        }
    }

    func getSurahList() {
        do {
            let surahList = try repository.getSurah()
            self.surahList = surahList
//            surah = surahList.first
        } catch {
            print(error)
        }
    }

    func getAyat(of surah: SurahInfo) -> [TafsirAyah] {
        do {
            let ayat = try tafsirRepository.getTafsirAyat(surah: surah)
            return ayat
        } catch {
            print(error)
        }
        return []
    }

    func getSurahArabicList() {
        do {
            let surahList = try repository.getSurahArabic(contentId: SurahNameContentID.en_unknown)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahArabicList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTransliterationList() {
        do {
            let surahList = try repository.getSurahTransliteration(contentId: SurahNameContentID.en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslilerationList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTranslationList() {
        do {
            let surahList = try repository.getSurahTranslation(contentId: SurahNameContentID.en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahName]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslationList = dict
        } catch {
            print(error)
        }
    }

    func updateFontSize(_ value: Double) {
        if previousFontSize == value { return }
        previousFontSize = value
        if ayah != nil {
            updateContent(ayah: ayah!, fontSize: value)
        }
    }

    func onViewAppear(ayah: TafsirAyah, fontSize: Double) {
        updateContent(ayah: ayah, fontSize: fontSize)
        setupReader()
    }

    private func setupReader() {
        utterance = AVSpeechUtterance(attributedString: attributedContent)
        let voice = AVSpeechSynthesisVoice()
        utterance?.voice = voice
    }

    private func updateContent(ayah: TafsirAyah, fontSize: Double) {
//        self.surah = surah
        self.ayah = ayah
        let config =
            TafsirContentConfiguration(
                arabicFontSize: Int(fontSize) + 2,
                titleFontSize: Int(fontSize),
                englishFontSize: Int(fontSize),
                arabicBackgroundColor: ""
            )
        do {
            let updatedContent = try tafsirRepository.getContent(ayah: ayah, configuraiton: config)
            DispatchQueue.main.async {
                self.attributedContent = updatedContent
            }

        } catch {
            print(error)
        }
    }

    func pause() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }

    func play() {
        if synthesizer.isSpeaking {
            synthesizer.continueSpeaking()
        } else {
            synthesizer.speak(utterance!)
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }

    func recite() {
        if isPlaying {
            pause()
        } else {
            play()
        }
        isPlaying.toggle()
    }

    func checkInAppFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            var scaledFont: UIFont?
            if let customFont = UIFont(name: family, size: UIFont.labelFontSize) {
                scaledFont = UIFontMetrics.default.scaledFont(for: customFont)
            }
            print("Family: \(family)  names: \(names) size:\(String(describing: scaledFont))")
        }
    }
}

extension TafsirContentPresenter {
    func addAttributeFonts(nsAttributedString: NSMutableAttributedString) {
        nsAttributedString.beginEditing()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "_PDMS_Saleem_QuranFont", size: UIFont.labelFontSize)!]
        nsAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: nsAttributedString.length)) { _, _, _ in
            nsAttributedString.removeAttribute(.font, range: NSRange(location: 0, length: nsAttributedString.length))
            nsAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: nsAttributedString.length))
        }
        nsAttributedString.endEditing()
    }

    func checkAttributeFonts(nsAttributedString: NSMutableAttributedString) {
        nsAttributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: nsAttributedString.length))
            { value, _, _ in
                print((value as! UIFont).fontName)
            }
    }

    func search(searchString: String) -> NSRange {
        let range = NSString(string: attributedContent.string).range(of: searchString, options: .caseInsensitive)
        return range
    }

    func searchAndHighlight(content: String, searchString: String, mutableAttributeString: NSMutableAttributedString)
        -> NSMutableAttributedString {
        let range = NSString(string: content).range(of: searchString, options: .caseInsensitive) // 2
        let highlightColor = UIColor.systemYellow
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.backgroundColor: highlightColor] // 4

        mutableAttributeString.addAttributes(highlightedAttributes, range: range) // 5

        return mutableAttributeString
    }
}
