//
//  AppDelegate.swift
//  leaning
//
//  Created by Tenna on 1/27/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import UIKit
import RealmSwift
import StoreKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        let config = Realm.Configuration(
            schemaVersion: 2,

            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                }
            })

        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        
        var index = 0
        var colorArray: [UIColor] = [UIColor(), UIColor(), UIColor()]
        
        if realm.objects(ThemeColor.self).first != nil {
            for realm in realm.objects(ThemeColor.self) {
                let r: CGFloat = CGFloat(NSString(string: realm.r ?? "1").floatValue)
                let g: CGFloat = CGFloat(NSString(string: realm.g ?? "1").floatValue)
                let b: CGFloat = CGFloat(NSString(string: realm.b ?? "1").floatValue)
                colorArray[index] = UIColor(red: r, green: g, blue: b, alpha: 1)
                index += 1
            }
        } else {
            colorArray[0] = UIColor(red: 184/255, green: 218/255, blue: 255/255, alpha: 1)
            colorArray[1] = UIColor(red: 242/255, green: 207/255, blue: 20/255, alpha: 1)
            colorArray[2] = UIColor(red: 242/255, green: 175/255, blue: 175/255, alpha: 1)
        }
        
        UserSetting.color1 = colorArray[0]
        UserSetting.color2 = colorArray[1]
        UserSetting.color3 = colorArray[2]
        
        if let pinImage = realm.objects(UserPin.self).first {
            UserSetting.pinImage = pinImage.name
        } else {
            UserSetting.pinImage = "hitoB.png"
        }
        
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


}

