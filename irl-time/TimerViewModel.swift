import Foundation
import Combine

struct LogEntry: Codable {
    let taskTitle: String
    let startTime: Date
    let endTime: Date
    let durationSeconds: Int
}

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var taskTitle: String = ""
    @Published var isRunning: Bool = false
    @Published var elapsedSeconds: Int = 0

    private var startDate: Date?
    private var tickCancellable: AnyCancellable?

    // ~/Library/Application Support/com.nechalmaggon.irltime/timer-log.json
    static let logURL: URL = {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = appSupport.appendingPathComponent("com.nechalmaggon.irltime", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("timer-log.json")
    }()

    func start() {
        guard !taskTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        startDate = Date()
        elapsedSeconds = 0
        isRunning = true
        tickCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let start = self.startDate else { return }
                self.elapsedSeconds = Int(Date().timeIntervalSince(start))
            }
    }

    func stop() {
        guard isRunning, let start = startDate else { return }
        tickCancellable?.cancel()
        tickCancellable = nil
        isRunning = false

        let end = Date()
        let entry = LogEntry(
            taskTitle: taskTitle.trimmingCharacters(in: .whitespaces),
            startTime: start,
            endTime: end,
            durationSeconds: Int(end.timeIntervalSince(start))
        )
        appendEntry(entry)
        startDate = nil
    }

    private func appendEntry(_ entry: LogEntry) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        var entries: [LogEntry] = []
        if let data = try? Data(contentsOf: Self.logURL),
           let existing = try? decoder.decode([LogEntry].self, from: data) {
            entries = existing
        }
        entries.append(entry)

        if let data = try? encoder.encode(entries) {
            try? data.write(to: Self.logURL, options: .atomic)
        }
    }

    var elapsedFormatted: String {
        let h = elapsedSeconds / 3600
        let m = (elapsedSeconds % 3600) / 60
        return String(format: "%02d:%02d", h, m)
    }
}

