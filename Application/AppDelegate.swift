//
//  AppDelegate.swift
//  Template
//
//  Created by Anton Bal’ on 11/6/19.
//  Copyright © 2019 Anton Bal'. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private lazy var platform = Platform(environment: Environment.current)
    private lazy var appCoordinator = ApplicationCoordinator(useCases: self.platform)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        platform.didFinishLaunching(with: launchOptions)
        window = appCoordinator.window
        return true
    }
}

