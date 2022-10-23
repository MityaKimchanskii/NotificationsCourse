//
//  AppDelegate.swift
//  Huli Pizza Notification
//
//  Created by Mitya Kim on 10/19/22.
//  Copyright © 2022 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // for push notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // TODO: add code here
        print(tokenString(deviceToken))
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printError(error, location: "Remote notification registration")
    }

    
    
    // for notification in all viewControllers
    let ncDelegate = NotificationCenterDelegate()
    
    // for interaction with notifications
    func setCategories() {
        // add actions for notifications
        let nextStepAction = UNNotificationAction(identifier: "next.step", title: "Next", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze", options: [])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancel Pizza", options: [.destructive])
        
        let textInputAction = UNTextInputNotificationAction(identifier: "text.input", title: "Comments", textInputButtonTitle: "Send", textInputPlaceholder: "Comments here")
        
        let pizzaStepsCategory = UNNotificationCategory(identifier: "pizza.steps.category", actions: [nextStepAction, snoozeAction, textInputAction, cancelAction], intentIdentifiers: [], options: [])
        
        let snoozeCategory = UNNotificationCategory(identifier: "snooze.category", actions: [snoozeAction, textInputAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([pizzaStepsCategory, snoozeCategory])
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription) \n---\n \(error)")
            }
            
            // for push notifications
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        // for notification in all viewControllers
        UNUserNotificationCenter.current().delegate = ncDelegate
        
        setCategories()
        
        return true
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
    //MARK: - Support Methods
    
    
    
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
    
    // for push notification
    func tokenString(_ deviceToken:Data) -> String{
        //code to make a token string
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        return token
    }
    
    

}

