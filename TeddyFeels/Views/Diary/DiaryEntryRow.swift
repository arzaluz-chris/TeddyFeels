import SwiftUI

struct DiaryEntryRow: View {
    let entry: EntradaDiario
    @Bindable var playerService: AudioPlayerService

    var body: some View {
        TeddyCard {
            VStack(alignment: .leading, spacing: TeddyTheme.spacingSM) {
                Text(entry.fecha.formatted(date: .abbreviated, time: .shortened))
                    .font(TeddyTheme.caption())
                    .foregroundColor(TeddyTheme.textSecondary)

                if !entry.texto.isEmpty {
                    Text(entry.texto)
                        .font(TeddyTheme.body())
                        .foregroundColor(TeddyTheme.textPrimary)
                }

                if let trans = entry.transcribedText, !trans.isEmpty {
                    HStack(spacing: TeddyTheme.spacingXS) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 12))
                            .foregroundColor(TeddyTheme.primary)
                        Text(trans)
                            .font(TeddyTheme.caption())
                            .foregroundColor(TeddyTheme.textSecondary)
                    }
                }

                if let audioURL = entry.audioURL {
                    HStack(spacing: TeddyTheme.spacingSM) {
                        Button {
                            playerService.togglePlayPause(id: entry.id, url: audioURL)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(playerService.isPlaying(entry.id) ? TeddyTheme.secondary.opacity(0.1) : TeddyTheme.primary.opacity(0.1))
                                    .frame(width: 44, height: 44)

                                Image(systemName: playerService.isPlaying(entry.id) ? "pause.fill" : "play.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(playerService.isPlaying(entry.id) ? TeddyTheme.secondary : TeddyTheme.primary)
                            }
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(playerService.isPlaying(entry.id) ? "Reproduciendo..." : "Nota de voz")
                                .font(TeddyTheme.caption())
                                .foregroundColor(TeddyTheme.textPrimary)

                            Text(AudioPlayerService.durationString(for: audioURL))
                                .font(TeddyTheme.badge())
                                .foregroundColor(TeddyTheme.textTertiary)
                        }

                        Spacer()
                    }
                    .padding(.top, TeddyTheme.spacingXS)
                }
            }
        }
    }
}
