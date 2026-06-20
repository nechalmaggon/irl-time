import SwiftUI

struct ContentView: View {
    @StateObject private var vm = TimerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("IRL Time")
                .font(.title)

            TextField("Task title", text: $vm.taskTitle)
                .textFieldStyle(.roundedBorder)
                .disabled(vm.isRunning)

            Text(vm.elapsedFormatted)
                .font(.system(size: 48, weight: .medium, design: .monospaced))

            HStack(spacing: 16) {
                Button("Start") { vm.start() }
                    .disabled(vm.isRunning || vm.taskTitle.trimmingCharacters(in: .whitespaces).isEmpty)

                Button("Stop") { vm.stop() }
                    .disabled(!vm.isRunning)
            }

            if !vm.isRunning && vm.elapsedSeconds > 0 {
                Text("Logged \(vm.elapsedSeconds)s — entry saved.")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }

            Divider()

            Text("Log file: \(TimerViewModel.logURL.path)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .textSelection(.enabled)
        }
        .padding(24)
        .frame(minWidth: 360, minHeight: 280)
    }
}

#Preview {
    ContentView()
}
