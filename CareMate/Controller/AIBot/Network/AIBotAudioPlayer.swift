//
//  AIBotAudioPlayer.swift
//  CareMate
//
//  Plays the mp3 returned by text_to_speech_v2 (bot "speaking").
//

import AVFoundation

final class AIBotAudioPlayer: NSObject, AVAudioPlayerDelegate {

    static let shared = AIBotAudioPlayer()
    private override init() { super.init() }

    private var player: AVAudioPlayer?
    private var onFinish: (() -> Void)?

    /// The url currently playing (so cells can reflect play state).
    private(set) var currentURL: URL?

    var isPlaying: Bool { player?.isPlaying ?? false }

    func play(url: URL, onFinish: (() -> Void)? = nil) {
        stop()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayback)
            // Reset the mode: the speech recognizer leaves it on .measurement,
            // which makes playback quiet and can route it to the earpiece.
            try session.setMode(AVAudioSessionModeDefault)
            try session.setActive(true)
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            player.volume = 1.0
            self.player = player
            self.onFinish = onFinish
            self.currentURL = url
            player.play()
        } catch {
            self.onFinish = nil
            self.currentURL = nil
            onFinish?()
        }
    }

    func stop() {
        player?.stop()
        player = nil
        currentURL = nil
    }

    /// Duration string ("m:ss") for a local audio file, or "0:00" if unknown.
    static func durationString(for url: URL) -> String {
        guard let audio = try? AVAudioPlayer(contentsOf: url) else { return "0:00" }
        let total = Int(audio.duration.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let finish = onFinish
        onFinish = nil
        currentURL = nil
        self.player = nil
        finish?()
    }
}
