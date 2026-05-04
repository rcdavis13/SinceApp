import Foundation

struct Task: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var lastDone: Date
    var intervalDays: Int // target interval in days

    var daysSinceLastDone: Int {
        Calendar.current.dateComponents([.day], from: lastDone, to: Date()).day ?? 0
    }

    var progress: Double {
        // 0.0 = just done, 1.0 = at interval, >1.0 = overdue
        guard intervalDays > 0 else { return 0 }
        return Double(daysSinceLastDone) / Double(intervalDays)
    }

    var statusColor: String {
        switch progress {
        case ..<0.5:  return "green"
        case 0.5..<1.0: return "yellow"
        default:        return "red"
        }
    }

    var statusLabel: String {
        switch daysSinceLastDone {
        case 0:       return "0 Days Since 😍"
        case 1..<7:   return "\(daysSinceLastDone) Days Since 😁"
        case 7..<14:  return "\(daysSinceLastDone) Days Since 😅"
        default:      return "\(daysSinceLastDone) Days Since 😬"
        }
    }
}
