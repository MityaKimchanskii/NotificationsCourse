//
//  NotificationCenterDelegate.swift
//  HuliPizzaNotifications
//
//  Created by Steven Lipton on 10/9/18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
   
    
    //MARK: - Support Methods
    let surferBullet = "🏄🏽‍♀️ "
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
    
    // for use notification for all viewControllers we need to create delegate method and create let in appDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
}
