//
//  AIBotSpeechRecognizer.swift
//  CareMate
//
//  On-device live speech-to-text for the voice mode, mirroring the Android
//  net.gotev.speech usage: listen, report partial results, and finalize after
//  a short silence.
//

import Foundation
import Speech
import AVFoundation

final class AIBotSpeechRecognizer {

    private let recognizer: SFSpeechRecognizer?
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var silenceTimer: Timer?
    private var lastText = ""

    var onPartial: ((String) -> Void)?
    var onResult: ((String) -> Void)?
    var onError: (() -> Void)?

    init(localeId: String) {
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: localeId))
    }

    /// Requests both speech-recognition and microphone permission.
    static func requestAuthorization(_ completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            let speechOK = (status == .authorized)
            AVAudioSession.sharedInstance().requestRecordPermission { micOK in
                DispatchQueue.main.async { completion(speechOK && micOK) }
            }
        }
    }

    func start() {
        stop()
        guard let recognizer = recognizer, recognizer.isAvailable else { onError?(); return }

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setMode(AVAudioSessionModeMeasurement)
            try session.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            onError?(); return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            onError?(); return
        }

        lastText = ""
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                self.lastText = result.bestTranscription.formattedString
                self.onPartial?(self.lastText)
                self.resetSilenceTimer()
                if result.isFinal { self.finish() }
            }
            if error != nil {
                self.stop()
                self.onError?()
            }
        }
        resetSilenceTimer()
    }

    func stop() {
        silenceTimer?.invalidate(); silenceTimer = nil
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        request?.endAudio()
        task?.cancel()
        task = nil
        request = nil
    }

    // MARK: - Silence handling

    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { [weak self] _ in
            self?.finish()
        }
    }

    private func finish() {
        let text = lastText.trimmingCharacters(in: .whitespacesAndNewlines)
        stop()
        if !text.isEmpty { onResult?(text) }
    }
}
