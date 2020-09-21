//
//  NotificationManager.swift
//  MilkshakrKit
//
//  Created by Guilherme Rambo on 21/09/20.
//  Copyright © 2020 Guilherme Rambo. All rights reserved.
//

import Foundation
import UserNotifications
import os.log

let milkshakrKitSubsystem = "MilkshakrKit"

public final class NotificationManager: NSObject {

    private let log = OSLog(subsystem: milkshakrKitSubsystem, category: String(describing: NotificationManager.self))

    public static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()

    @Published public private(set) var canAskForNonProvisionalPermission = false

    public override init() {
        super.init()

        updateProvisionalPermissionState()
    }

    public func setup() {
        center.delegate = self
    }

    private func updateProvisionalPermissionState() {
        center.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied {
                    self.canAskForNonProvisionalPermission = false
                } else {
                    self.canAskForNonProvisionalPermission = settings.alertSetting == .disabled
                }
            }
        }
    }

    public func requestAuthorization(provisional: Bool = true) {
        var options: UNAuthorizationOptions = [.alert, .sound, .announcement]

        if provisional { options.insert(.provisional) }

        center.requestAuthorization(options: options) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                os_log("Failed to request notification permissions: %{public}@", log: self.log, type: .fault, String(describing: error))
                return
            }

            os_log("Notification authorization result: %{public}@", log: self.log, type: .debug, String(describing: result))

            self.updateProvisionalPermissionState()
        }
    }

    public func scheduleNotification(for purchase: PurchaseViewModel) {
        os_log("%{public}@", log: log, type: .debug, #function)

        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Your order is ready!", comment: "Order ready notification title")
        content.body = purchase.readyMessage

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                os_log("Failed to schedule purchase ready notification: %{public}@", log: self.log, type: .fault, String(describing: error))
                return
            }
        }
    }

}

extension NotificationManager: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }

}
