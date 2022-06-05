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
    @Published var quran: Quran = Quran(surah: [])
    @Published var attributedContent = NSMutableAttributedString(string: "")
    @Published var tafsir: Tafsir?
    private let synthesizer = AVSpeechSynthesizer()
    private var utterance: AVSpeechUtterance?
    private var isPlaying = false
    private var surah: TafsirSurah?
    private var ayah: TafsirAyah?
    private var tafsirRepository = TafsirRepository()
    @Published var fontSize: Float = 15.0 {
        didSet {
            if previousFontSize == fontSize { return }
            previousFontSize = fontSize
            DispatchQueue.global().async { [self] in
                if surah != nil && ayah != nil {
                    self.updateContent(surah: surah!, ayah: ayah!)
                }
            }
        }
    }

    private var repository = QuranRepository()
    private var previousFontSize: Float = 15.0

    var fontRange: ClosedRange<Float> = 15.0 ... 30.0

    func getSurah() {
        DispatchQueue.global().async {
            let quran = self.repository.requestQuran()
            let tafsir = self.tafsirRepository.getTafsir(surah: quran.surah)
            DispatchQueue.main.async {
                self.quran = quran
                self.tafsir = tafsir
            }
        }
    }

    func onViewAppear(surah: TafsirSurah, ayah: TafsirAyah) {
        DispatchQueue.global().async {
            self.updateContent(surah: surah, ayah: ayah)
            self.setupReader()
        }
    }

    private func setupReader() {
        utterance = AVSpeechUtterance(attributedString: attributedContent)
        let voice = AVSpeechSynthesisVoice()
        utterance?.voice = voice
    }

    private func updateContent(surah: TafsirSurah, ayah: TafsirAyah) {
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
//            let updatedContent = try TafsirRepository().getContent(surah: surah.surahNo, ayah: 1, configuraiton: config)
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
