import SwiftUI

struct EditTaskView: View {
    let task: Task
    @ObservedObject var store: TaskStore
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var intervalDays: Int

    init(task: Task, store: TaskStore) {
        self.task = task
        self.store = store
        _name = State(initialValue: task.name)
        _intervalDays = State(initialValue: task.intervalDays)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Name")) {
                    TextField("Task name", text: $name)
                }

                Section(header: Text("Target Interval"),
                        footer: Text("The counter turns red after this many days.")) {
                    Stepper("\(intervalDays) day\(intervalDays == 1 ? "" : "s")", value: $intervalDays, in: 1...365)

                    HStack(spacing: 8) {
                        ForEach([1, 3, 7, 14, 30], id: \.self) { preset in
                            Button(action: { intervalDays = preset }) {
                                Text(presetLabel(preset))
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(intervalDays == preset ? Color.accentColor : Color(.systemGray5))
                                    .foregroundColor(intervalDays == preset ? .white : .primary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section(header: Text("Not Completed Since")) {
                    Text(task.lastDone, style: .date)
                        .foregroundColor(.secondary)
                    Text("\(task.daysSinceLastDone) day\(task.daysSinceLastDone == 1 ? "" : "s") ago")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var updated = task
                        updated.name = name.trimmingCharacters(in: .whitespaces)
                        updated.intervalDays = intervalDays
                        store.updateTask(updated)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func presetLabel(_ days: Int) -> String {
        switch days {
        case 1: return "Daily"
        case 7: return "Weekly"
        case 14: return "2 weeks"
        case 30: return "Monthly"
        default: return "\(days)d"
        }
    }
}
