//
//  AIBotAudioRecorder.swift
//  CareMate
//
//  Records a short voice clip (WAV) for the input-bar "record" option, which is
//  uploaded to the speech-to-text endpoint (mirrors the Android WaveRecorder).
//

import AVFoundation

final class AIBotAudioRecorder {

    private var recorder: AVAudioRecorder?
    private(set) var fileURL: URL?

    var isRecording: Bool { recorder?.isRecording ?? false }

    static func requestPermission(_ completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func start() throws {
        stopAndDiscard()

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.setActive(true, with: .notifyOthersOnDeactivation)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("aibot_rec_\(UUID().uuidString).wav")
        self.fileURL = url

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ]

        let recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder.isMeteringEnabled = true
        recorder.record()
        self.recorder = recorder
    }

    /// Stops and returns the recorded file url.
    @discardableResult
    func stop() -> URL? {
        recorder?.stop()
        recorder = nil
        return fileURL
    }

    /// Stops and deletes the recording.
    func cancel() {
        stopAndDiscard()
    }

    private func stopAndDiscard() {
        recorder?.stop()
        recorder = nil
        if let url = fileURL {
            try? FileManager.default.removeItem(at: url)
        }
        fileURL = nil
    }

    /// Current input power (0...1) for a simple live level meter.
    func level() -> Float {
        guard let recorder = recorder, recorder.isRecording else { return 0 }
        recorder.updateMeters()
        let db = recorder.averagePower(forChannel: 0)
        // Map -60...0 dB to 0...1
        let clamped = max(-60, min(0, db))
        return (clamped + 60) / 60
    }
}
