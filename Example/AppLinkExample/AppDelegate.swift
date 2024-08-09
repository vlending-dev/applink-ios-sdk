//
//  AppDelegate.swift
//  AppLinkExample
//
//  Created by Hyunjoon Ko on 8/1/24.
//  Copyright © 2024 Vlending Co., Ltd. All rights reserved.
//

import UIKit
import AppLink

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // TODO: AppLink Setting (apiKey, domainURIPrefix, customScheme)
        AppLink.apiKey = #"{your app key}"#
        AppLink.domainURIPrefix = "{yout domain uri}" // ex) https://{subdomain}.applink.info/
        AppLink.customScheme = "{your scheme}"
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AppLink.isAppLink(url) {
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
            return true
        }
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL, AppLink.isAppLink(url) {
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
            return true
        }
        return false
    }


}

