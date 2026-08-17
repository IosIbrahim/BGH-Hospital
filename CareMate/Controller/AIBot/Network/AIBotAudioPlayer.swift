//
//  AIBotAudioPlayer.swift
//  CareMate
//
//  Plays the mp3s returned by text_to_speech_v2 (bot "speaking"). Conversation
//  replies are queued and played one after another so they never cut each other
//  off; tapping a bubble plays that clip immediately.
//

import AVFoundation

final class AIBotAudioPlayer: NSObject, AVAudioPlayerDelegate {

    static let shared = AIBotAudioPlayer()
    private override init() { super.init() }

    private var player: AVAudioPlayer?
    private var queue: [URL] = []
    private var manualFinish: (() -> Void)?

    /// The url currently playing (so cells can reflect play state).
    private(set) var currentURL: URL?

    /// Called when the auto-play queue empties (all replies spoken).
    var onDrained: (() -> Void)?

    var isPlaying: Bool { (player?.isPlaying ?? false) || !queue.isEmpty }

    // MARK: - Queue (conversation replies)

    /// Adds a reply to the play queue; starts playing if idle.
    func enqueue(_ url: URL) {
        queue.append(url)
        if player == nil { playNext() }
    }

    private func playNext() {
        guard !queue.isEmpty else {
            currentURL = nil
            onDrained?()
            return
        }
        let url = queue.removeFirst()
        if !startPlaying(url) { playNext() }
    }

    // MARK: - Manual (tap a bubble)

    func play(url: URL, onFinish: (() -> Void)? = nil) {
        queue.removeAll()
        manualFinish = onFinish
        _ = startPlaying(url)
    }

    func stop() {
        queue.removeAll()
        manualFinish = nil
        player?.stop()
        player = nil
        currentURL = nil
    }

    // MARK: - Core

    private func startPlaying(_ url: URL) -> Bool {
        player?.stop()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayback)
            // Reset the mode: the recognizer leaves it on .measurement which
            // makes playback quiet / routes it to the earpiece.
            try session.setMode(AVAudioSessionModeDefault)
            try session.setActive(true)
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.volume = 1.0
            player = newPlayer
            currentURL = url
            newPlayer.play()
            return true
        } catch {
            player = nil
            currentURL = nil
            return false
        }
    }

    static func durationString(for url: URL) -> String {
        guard let audio = try? AVAudioPlayer(contentsOf: url) else { return "0:00" }
        let total = Int(audio.duration.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
        currentURL = nil
        if let finish = manualFinish {
            manualFinish = nil
            finish()
            return
        }
        playNext()
    }
}
