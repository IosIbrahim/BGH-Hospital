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
    var onError: ((String) -> Void)?

    private let localeId: String

    init(localeId: String) {
        self.localeId = localeId
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
        guard let recognizer = recognizer else {
            print("🔴 [Speech] no recognizer for \(localeId)")
            onError?("Speech recognition not supported for \(localeId)")
            return
        }
        print("🎙️ [Speech] locale=\(localeId) available=\(recognizer.isAvailable)")
        guard recognizer.isAvailable else {
            onError?("Speech recognizer unavailable (check network / language)")
            return
        }

        do {
            let session = AVAudioSession.sharedInstance()
            // playAndRecord + default mode captures mic input reliably and keeps
            // output on the speaker; .measurement mode could yield no input.
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                                    with: [.defaultToSpeaker, .allowBluetooth])
            try session.setMode(AVAudioSessionModeDefault)
            try session.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("🔴 [Speech] audio session error: \(error)")
            onError?("Audio session error")
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        self.request = request

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        print("🎙️ [Speech] input format sampleRate=\(format.sampleRate) channels=\(format.channelCount)")
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("🔴 [Speech] engine start error: \(error)")
            onError?("Couldn't start the microphone")
            return
        }

        lastText = ""
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                self.lastText = result.bestTranscription.formattedString
                print("🎙️ [Speech] partial: \(self.lastText)")
                self.onPartial?(self.lastText)
                // Only start the finalize timer once speech has actually begun,
                // so we don't cut off before the user starts talking.
                self.resetSilenceTimer()
                if result.isFinal { self.finish() }
            }
            if let error = error {
                print("🔴 [Speech] task error: \(error.localizedDescription)")
                let text = self.lastText.trimmingCharacters(in: .whitespacesAndNewlines)
                self.stop()
                if !text.isEmpty {
                    self.onResult?(text)
                } else {
                    self.onError?("No speech detected. Tap the mic and try again.")
                }
            }
        }
        // NOTE: no silence timer here — it starts only after the first result.
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
