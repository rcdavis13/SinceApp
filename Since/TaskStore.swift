import Foundation
import Combine

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet { save() }
    }

    private let saveKey = "since_tasks"

    init() {
        load()
    }

    // Sorted: most days since last done first
    var sortedTasks: [Task] {
        tasks.sorted { $0.daysSinceLastDone > $1.daysSinceLastDone }
    }

    func addTask(name: String, intervalDays: Int) {
        let task = Task(name: name, lastDone: Date(), intervalDays: intervalDays)
        tasks.append(task)
    }

    func markDoneToday(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].lastDone = Date()
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}
