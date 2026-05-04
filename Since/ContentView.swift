import SwiftUI

struct ContentView: View {
    @StateObject private var store = TaskStore()
    @State private var showingAddTask = false

    var body: some View {
        NavigationView {
            Group {
                if store.tasks.isEmpty {
                    emptyState
                } else {
                    taskList
                }
            }
            .navigationTitle("Since App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(store: store)
            }
        }
    }

    private var taskList: some View {
        List {
            ForEach(store.sortedTasks) { task in
                TaskRowView(task: task, store: store)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            Text("No tasks yet")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Tap + to add your first task,\nlike \"Wash the car\" or \"Clean the shower\".")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Button(action: { showingAddTask = true }) {
                Label("Add Task", systemImage: "plus")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}
