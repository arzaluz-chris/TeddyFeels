import Foundation
import AVFoundation

@Observable
final class AudioPlayerService {
    var currentlyPlayingID: UUID?

    private var players: [UUID: AVAudioPlayer] = [:]
    private var delegates: [UUID: PlayerDelegate] = [:]

    func isPlaying(_ id: UUID) -> Bool {
        currentlyPlayingID == id && players[id]?.isPlaying == true
    }

    func togglePlayPause(id: UUID, url: URL) {
        // Pause current if same
        if currentlyPlayingID == id, let player = players[id], player.isPlaying {
            player.pause()
            currentlyPlayingID = nil
            return
        }

        // Pause any currently playing
        if let currentID = currentlyPlayingID, let currentPlayer = players[currentID] {
            currentPlayer.pause()
        }

        do {
            let player: AVAudioPlayer
            if let existing = players[id] {
                player = existing
            } else {
                player = try AVAudioPlayer(contentsOf: url)
                let delegate = PlayerDelegate(id: id) { [weak self] finishedID in
                    if self?.currentlyPlayingID == finishedID {
                        self?.currentlyPlayingID = nil
                    }
                }
                player.delegate = delegate
                delegates[id] = delegate
                players[id] = player
            }

            player.currentTime = 0
            player.prepareToPlay()
            player.play()
            currentlyPlayingID = id
        } catch {
            print("Error reproduciendo: \(error.localizedDescription)")
        }
    }

    func stopAll() {
        currentlyPlayingID = nil
        players.values.forEach { $0.stop() }
        players.removeAll()
        delegates.removeAll()
    }

    static func durationString(for url: URL) -> String {
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return "?" }
        let total = Int(player.duration)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}

final class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
    let id: UUID
    let onFinish: (UUID) -> Void

    init(id: UUID, onFinish: @escaping (UUID) -> Void) {
        self.id = id
        self.onFinish = onFinish
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [self] in
            onFinish(id)
        }
    }
}
