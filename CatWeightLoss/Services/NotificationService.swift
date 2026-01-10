import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private init() {}

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    // MARK: - Feeding Reminders

    func scheduleFeedingReminder(for schedule: FeedingSchedule, catName: String) {
        guard schedule.notificationEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time to feed \(catName)!"
        content.body = "\(schedule.mealName): \(String(format: "%.0f", schedule.portionGrams))g of \(schedule.foodType.rawValue)"
        content.sound = .default
        content.categoryIdentifier = "FEEDING_REMINDER"

        let components = schedule.timeComponents
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let identifier = "feeding-\(schedule.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling feeding reminder: \(error)")
            }
        }
    }

    func cancelFeedingReminder(for schedule: FeedingSchedule) {
        let identifier = "feeding-\(schedule.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func updateFeedingReminders(for cat: Cat) {
        // Cancel all existing reminders for this cat
        let identifiers = cat.feedingSchedules.map { "feeding-\($0.id.uuidString)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)

        // Re-schedule enabled reminders
        for schedule in cat.feedingSchedules where schedule.isEnabled {
            scheduleFeedingReminder(for: schedule, catName: cat.name)
        }
    }

    // MARK: - Weigh-In Reminders

    func scheduleWeighInReminder(for cat: Cat, dayOfWeek: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Weigh-in day for \(cat.name)!"
        content.body = "Time to track \(cat.name)'s progress. Tap to log weight."
        content.sound = .default
        content.categoryIdentifier = "WEIGHIN_REMINDER"

        var components = DateComponents()
        components.weekday = dayOfWeek // 1 = Sunday, 7 = Saturday
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let identifier = "weighin-\(cat.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling weigh-in reminder: \(error)")
            }
        }
    }

    func cancelWeighInReminder(for cat: Cat) {
        let identifier = "weighin-\(cat.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - Activity Reminders

    func scheduleActivityReminder(for cat: Cat, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Playtime with \(cat.name)!"
        content.body = "Daily goal: \(cat.dailyActivityMinutes) minutes of activity"
        content.sound = .default
        content.categoryIdentifier = "ACTIVITY_REMINDER"

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let identifier = "activity-\(cat.id.uuidString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling activity reminder: \(error)")
            }
        }
    }

    // MARK: - Cancel All

    func cancelAllReminders(for cat: Cat) {
        var identifiers = [String]()
        identifiers.append("weighin-\(cat.id.uuidString)")
        identifiers.append("activity-\(cat.id.uuidString)")
        identifiers.append(contentsOf: cat.feedingSchedules.map { "feeding-\($0.id.uuidString)" })

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
