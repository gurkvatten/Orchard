//
//  OrchardApp.swift
//  Orchard
//
//  Created by Johan Karlsson on 2024-02-07.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct OrchardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            CardListView()
        }
    }
}
