//
//  AppDelegate.swift
//  Anchor
//
//  Created by Helen Cao on 7/20/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureInitialRootViewController(for: window)
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor(red:1.00, green:0.90, blue:0.71, alpha:1.0)
        navigationBarAppearace.barTintColor = UIColor(red:0.43, green:0.55, blue:0.70, alpha:1.0)
       
            navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Copperplate", size: 30)!, NSForegroundColorAttributeName: UIColor(red:1.00, green:0.90, blue:0.71, alpha:1.0)]
        
        
        
        return true
    }
    
    override init() {
        FirebaseApp.configure()

    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
        // other URL handling goes here
        
        return false
    }
    

}
extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            
            User.setCurrent(user)
            
            initialViewController = UIStoryboard.initialViewController(for: .main)
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
    
    
        
    }
    
   
}

