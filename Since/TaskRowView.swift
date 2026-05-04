import SwiftUI

struct TaskRowView: View {
    let task: Task
    @ObservedObject var store: TaskStore
    @State private var showingEdit = false
    @State private var showingDeleteConfirm = false
    @State private var justMarkedDone = false

    private var statusColor: Color {
        switch task.statusColor {
        case "green":  return .green
        case "yellow": return Color.orange
        default:       return .red
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Color indicator bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(statusColor)
                    .frame(width: 5)
                    .frame(maxHeight: .infinity)

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.caption)
                            .foregroundColor(statusColor)
                        Text(task.statusLabel)
                            .font(.subheadline)
                            .foregroundColor(statusColor)
                            .fontWeight(.medium)
                    }

                    Text("Goal: every \(task.intervalDays) day\(task.intervalDays == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Done Today button
                Button(action: markDone) {
                    VStack(spacing: 3) {
                        Image(systemName: justMarkedDone ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.title2)
                            .foregroundColor(justMarkedDone ? .green : .accentColor)
                        Text("Done")
                            .font(.caption2)
                            .foregroundColor(justMarkedDone ? .green : .accentColor)
                    }
                }
                .buttonStyle(.plain)
                .disabled(task.daysSinceLastDone == 0)
                .opacity(task.daysSinceLastDone == 0 ? 0.4 : 1.0)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray5))
                        .frame(height: 4)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(statusColor.opacity(0.7))
                        .frame(width: min(geo.size.width * CGFloat(task.progress), geo.size.width), height: 4)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            showingEdit = true
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                store.deleteTask(task)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                showingEdit = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .sheet(isPresented: $showingEdit) {
            EditTaskView(task: task, store: store)
        }
    }

    private func markDone() {
        withAnimation {
            justMarkedDone = true
            store.markDoneToday(task)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            justMarkedDone = false
        }
    }
}
