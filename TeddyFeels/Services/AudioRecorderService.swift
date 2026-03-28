import Foundation
import AVFoundation

@Observable
final class AudioRecorderService {
    var isRecording = false
    var recordingURL: URL?
    var error: String?

    private var audioRecorder: AVAudioRecorder?

    func requestPermissions() {
        AVAudioApplication.requestRecordPermission { granted in
            if !granted {
                DispatchQueue.main.async {
                    self.error = "Permiso de micrófono denegado"
                }
            }
        }
    }

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = "nota_\(Date().timeIntervalSince1970).m4a"
            let url = documents.appendingPathComponent(fileName)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.record()
            isRecording = true
            recordingURL = url
        } catch {
            self.error = "Error al iniciar grabación: \(error.localizedDescription)"
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    /// Returns relative path for storage in SwiftData
    var recordingRelativePath: String? {
        recordingURL?.lastPathComponent
    }

    func clearRecording() {
        recordingURL = nil
    }
}
