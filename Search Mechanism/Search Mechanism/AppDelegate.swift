//
//  AppDelegate.swift
//  Search Mechanism
//
//  Created by E. Mozharovsky on 11/6/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Return status bar to the screen & set its style.
        let application = UIApplication.sharedApplication()
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        application.statusBarStyle = UIStatusBarStyle.LightContent
        
        // Setup navigation bar appearance.
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = UIColor.colorFromCode(0x2ecc71)
        
        return true
    }
}

