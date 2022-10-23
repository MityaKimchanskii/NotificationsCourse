//
//  NotificationCenterDelegate.swift
//  HuliPizzaNotifications
//
//  Created by Mitya Kim on 10/19/22.
//  Copyright © 2022 Steven Lipton. All rights reserved.
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
    
    // add actions for notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let action = response.actionIdentifier
        let request = response.notification.request
        
        let content = request.content.mutableCopy() as! UNMutableNotificationContent
        
        if action == "text.input" {
            let textResponse = response as! UNTextInputNotificationResponse
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            newContent.subtitle = textResponse.userText
            
            let request = UNNotificationRequest(identifier: request.identifier, content: newContent, trigger: request.trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                self.printError(error, location: "Text Input Action")
            }
        }
        
        if action == "cancel" {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
        }
        
        // for local notification
//        if action == "snooze" {
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//            let request = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { error in
//                self.printError(error, location: "Snooze Action")
//            }
//        }
        
        // for push notification
        if action == "snooze" {
            
            let content = changePizzaNotification(content: request.content)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: request.identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                self.printError(error, location: "Snooze Action")
            }
        }
        
        if action == "next.step" {
            guard var step = content.userInfo["step"] as? Int else { return }
            step += 1
            if step < pizzaSteps.count {
                content.body = pizzaSteps[step]
                content.userInfo["step"] = step
                let request = UNNotificationRequest(identifier: request.identifier, content: content, trigger: request.trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    self.printError(error, location: "Next step")
                }
            } else {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [request.identifier])
            }
        }
        
        completionHandler()
    }
    
    // for push notification
    func changePizzaNotification(content oldContent: UNNotificationContent) -> UNMutableNotificationContent {
        let content = oldContent.mutableCopy() as! UNMutableNotificationContent
        let userInfo = content.userInfo as! [String: Any]
        
        if let orders = userInfo["order"] as? [String] {
            content.body = "You going to love this: \n"
            
            for item in orders {
                content.body += surferBullet + item + "\n"
            
            }
        }
        return content
    }
}
