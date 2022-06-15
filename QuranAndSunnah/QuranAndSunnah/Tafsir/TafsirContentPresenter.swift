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
    private var surah: Surah2?
    private var ayah: TafsirAyah?
    private var tafsirRepository = TafsirRepository()
    @Published var surahList = [Surah2]()
    @Published var surahTranslationList = [Int: SurahNameTranslation<SurahTranslationID>]()
    @Published var surahTranslilerationList = [Int: SurahNameTranslation<SurahTranslationID>]()
    private var repository = QuranJsonFacade.shared
    private var previousFontSize: Double = 15.0

    func getSurahList() {
        do {
            let surahList = try repository.getSurah(contentID: .en_unknown)
            self.surahList = surahList
            surah = surahList.first
        } catch {
            print(error)
        }
    }

    func getAyat(of surah: Surah2) -> [TafsirAyah] {
        do {
            let ayat = try tafsirRepository.getTafsirAyat(surah: surah)
            return ayat
        } catch {
            print(error)
        }
        return []
    }

    func getSurahTransliterationList() {
        do {
            let surahList = try repository.getSurahTransliteration(contentID: SurahTranslationID.en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahNameTranslation<SurahTranslationID>]()) {
                $0[$1.surahNo] = $1
            }
            surahTranslilerationList = dict
        } catch {
            print(error)
        }
    }

    func getSurahTranslationList() {
        do {
            let surahList = try repository.getSurahTranslation(contentID: SurahTranslationID.en_tanzil, language: .en)

            let dict = surahList.reduce(into: [Int: SurahNameTranslation<SurahTranslationID>]()) {
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
        if surah != nil && ayah != nil {
            updateContent(surah: surah!, ayah: ayah!, fontSize: value)
        }
    }

    func onViewAppear(surah: Surah2, ayah: TafsirAyah, fontSize: Double) {
        updateContent(surah: surah, ayah: ayah, fontSize: fontSize)
        setupReader()
    }

    private func setupReader() {
        utterance = AVSpeechUtterance(attributedString: attributedContent)
        let voice = AVSpeechSynthesisVoice()
        utterance?.voice = voice
    }

    private func updateContent(surah: Surah2, ayah: TafsirAyah, fontSize: Double) {
        self.surah = surah
        self.ayah = ayah
        let config =
            TafsirContentConfiguration(
                arabicFontSize: Int(fontSize) + 2,
                titleFontSize: Int(fontSize),
                englishFontSize: Int(fontSize),
                arabicBackgroundColor: ""
            )
        do {
            let updatedContent = try tafsirRepository.getContent(ayahUrl: ayah.path, configuraiton: config)
            attributedContent = updatedContent

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
