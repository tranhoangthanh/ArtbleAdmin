//
//  AppDelegate.swift
//  ArtbleAdmin
//
//  Created by Trần Thành on 12/6/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        return true
    }

    
}

