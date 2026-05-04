import SwiftUI

struct AddTaskView: View {
    @ObservedObject var store: TaskStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var intervalDays = 7

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Name")) {
                    TextField("e.g. Wash the car", text: $name)
                }

                Section(header: Text("How often should you do this?"),
                        footer: Text("The counter will turn red when you go past this many days.")) {
                    Stepper("\(intervalDays) day\(intervalDays == 1 ? "" : "s")", value: $intervalDays, in: 1...365)

                    // Quick presets
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quick presets")
                            .font(.caption)
                            .foregroundColor(.secondary)
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
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        store.addTask(name: name.trimmingCharacters(in: .whitespaces), intervalDays: intervalDays)
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
