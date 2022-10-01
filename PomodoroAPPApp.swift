//
//  PomodoroAPPApp.swift
//  PomodoroAPP
//
//  Created by mak on 30.09.2022.
//

import SwiftUI

@main
struct PomodoroAPPApp: App {
//    MARK: Since we're doing background fetching initializing here
    @StateObject var pomodoroModel: PomodoroModel = .init()
//    MARK: Scene Phase
    @Environment(\.scenePhase) var phase
//    MARK: Storing last time stamp
    @State var lastActiveTimeStamp: Date = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pomodoroModel)
        }
        .onChange(of: phase) { newValue in
            if pomodoroModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
//                    MARK: Finding the difference
                    let currentTimeStampDif = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDif) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                    } else {
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDif)
                    }
                }
            }
        }
    }
}
