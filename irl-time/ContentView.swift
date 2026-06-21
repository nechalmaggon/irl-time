import SwiftUI

struct LiveDot: View {
    @State private var pulsing = false

    var body: some View {
        Circle()
            .fill(Color("LiveIndicatorGreen"))
            .frame(width: 8, height: 8)
            .scaleEffect(pulsing ? 1.35 : 1.0)
            .opacity(pulsing ? 0.4 : 1.0)
            .animation(
                .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: pulsing
            )
            .onAppear { pulsing = true }
    }
}

struct ContentView: View {
    @StateObject private var vm = TimerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text(vm.taskTitle.trimmingCharacters(in: .whitespaces).isEmpty ? "IRL Time" : vm.taskTitle)
                .font(.system(size: 13, weight: .medium, design: .default))
                .foregroundStyle(Color("AppForeground").opacity(0.5))

            TextField("Task title", text: $vm.taskTitle)
                .textFieldStyle(.roundedBorder)
                .disabled(vm.isRunning)

            ZStack(alignment: .bottomTrailing) {
                Text(vm.elapsedFormatted)
                    .font(.system(size: 64, weight: .semibold, design: .monospaced))
                    .monospacedDigit()
                    .foregroundStyle(Color("AppForeground"))

                if vm.isRunning {
                    LiveDot()
                        .offset(x: 6, y: -4)
                }
            }

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
        .background(Color("AppBackground"))
    }
}

#Preview {
    ContentView()
}
