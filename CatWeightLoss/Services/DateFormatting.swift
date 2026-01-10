import Foundation

/// Cached DateFormatters for performance
/// DateFormatter allocation is expensive (~2ms each), so we cache common configurations
enum DateFormatting {

    // MARK: - Cached Formatters

    /// Date only, medium style (e.g., "Jan 10, 2026")
    static let dateMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    /// Date and time, medium/short style (e.g., "Jan 10, 2026 at 9:30 AM")
    static let dateTimeMediumShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    /// Time only, short style (e.g., "9:30 AM")
    static let timeShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    /// Relative date formatting (e.g., "Today", "Yesterday", "2 days ago")
    static let relativeDate: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    // MARK: - Convenience Methods

    static func formatDate(_ date: Date) -> String {
        dateMedium.string(from: date)
    }

    static func formatDateTime(_ date: Date) -> String {
        dateTimeMediumShort.string(from: date)
    }

    static func formatTime(_ date: Date) -> String {
        timeShort.string(from: date)
    }

    static func formatRelative(_ date: Date) -> String {
        relativeDate.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Duration Formatting

enum DurationFormatting {

    /// Format minutes to human-readable string (e.g., "45 min", "1h 30m")
    static func format(minutes: Int) -> String {
        if minutes >= 60 {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
        return "\(minutes) min"
    }

    /// Format seconds to human-readable string
    static func format(seconds: Int) -> String {
        if seconds >= 3600 {
            let hours = seconds / 3600
            let mins = (seconds % 3600) / 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        } else if seconds >= 60 {
            let mins = seconds / 60
            let secs = seconds % 60
            return secs > 0 ? "\(mins)m \(secs)s" : "\(mins)m"
        }
        return "\(seconds)s"
    }
}
