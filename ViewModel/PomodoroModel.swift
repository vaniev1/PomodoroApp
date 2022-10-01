//
//  PomodoroModel.swift
//  PomodoroAPP
//
//  Created by mak on 30.09.2022.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject , UNUserNotificationCenterDelegate{
//    MARK: Timer properties
    @Published var progress: CGFloat = 1
    @Published var timeStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
//    MARK: Total secons
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSecond: Int = 0
    
//    MARK: Post timer properties
    @Published var isFinished: Bool = false
    
//    Since it NSOBJECT
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
//    MARK: Requesting Notifications Access
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _,_ in
        }
//        MARK: TO show in app notification
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
//    MARK: Start  timer
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
//        MARK: Setting string time value
        timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)": "0\(seconds)")"
//        MARK: Calculating total secons for timer animation
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSecond = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
//    MARK: Stopping timer
    
    func stopTimer() {
        withAnimation{
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        totalSeconds = 0
        staticTotalSecond = 0
        timeStringValue = "00:00"
    }
    
//    MARK: Updating timer
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSecond)
        progress = (progress < 0 ? 0 : progress)
//        60 minutes * 60 seconds
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)": "0\(seconds)")"
        if hour == 0 && seconds == 0 && minutes == 0 {
            isStarted = false
            isFinished = true
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "myApp"
        content.subtitle = "Congratulate!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(staticTotalSecond), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}
