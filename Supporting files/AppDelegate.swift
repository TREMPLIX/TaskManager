//
//  AppDelegate.swift
//  TaskManager
//
//  Created by SERGEY TREMPLIX on 23.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Настройка внешнего вида приложения
    UINavigationBar.appearance().barTintColor = .white
    UINavigationBar.appearance().tintColor = .black
    UINavigationBar.appearance().titleTextAttributes = [
      .foregroundColor: UIColor.black,
    ]

    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {}
}
