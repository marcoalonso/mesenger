//
//  AppDelegate.swift
//  mesenger
//
//  Created by marco alonso on 01/12/20.
//

import UIKit
import Firebase
import UIKit
import FBSDKCoreKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        FirebaseApp.configure()
        return true }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
    }
    
}

