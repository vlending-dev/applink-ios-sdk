//
//  SceneDelegate.swift
//  AppLinkExample
//
//  Created by Hyunjoon Ko on 8/1/24.
//  Copyright © 2024 Vlending Co., Ltd. All rights reserved.
//

import UIKit
import AppLink

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        // The app was launched from a link while it was not running.
        if let url = connectionOptions.urlContexts.first?.url {
            handleAppLink(url)
        } else if let userActivity = connectionOptions.userActivities.first(where: { $0.activityType == NSUserActivityTypeBrowsingWeb }),
                  let url = userActivity.webpageURL {
            handleAppLink(url)
        }
    }

    // Custom URL scheme
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleAppLink(url)
    }

    // Universal Links
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL else { return }
        handleAppLink(url)
    }

    private func handleAppLink(_ url: URL) {
        guard AppLink.isAppLink(url) else { return }
        AppLink.parse(url: url) { linkInfo, key, queries, error in
            guard let info = linkInfo else {
                print("AppLink parse error :: \(String(describing: error))")
                return
            }
            print("AppLink \(key) :: \(String(describing: info.title))")

            // Actions are executed according to the received deep link information.
            if let scheme = info.scheme, let action = info.deeplinkAction, let url = URL(string: scheme + "://" + action) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

