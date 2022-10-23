//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by Mitya Kim on 10/23/22.
//  Copyright © 2022 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentSubtitle: UILabel!
    @IBOutlet weak var contentBody: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    
    @IBAction func snoozeButton(_ sender: Any) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            
        }
        extensionContext?.dismissNotificationContentExtension()
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Like" {
            sender.setTitle("Unlike", for: .normal)
            extensionContext?.notificationActions = [snoozeAction, unlikeAction]
        } else {
            sender.setTitle("Like", for: .normal)
            extensionContext?.notificationActions = [snoozeAction, likeAction]
        }
    }
    
    var content = UNMutableNotificationContent()
    var requestIdentifier = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    let unlikeAction = UNNotificationAction(identifier: "unlike", title: "Unlike", options: [])
    let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
    let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze 5 Seconds", options: [])
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        let action = response.actionIdentifier
        if action == "like"{
            extensionContext?.notificationActions = [snoozeAction,unlikeAction]
        }
        if action == "unlike"{
            extensionContext?.notificationActions = [snoozeAction,likeAction]
        }
        if action == "snooze"{
            completion(.dismissAndForwardAction)
        }
        
        completion(.doNotDismiss)
    }
    func didReceive(_ notification: UNNotification) {
        requestIdentifier = notification.request.identifier
        content = notification.request.content.mutableCopy() as! UNMutableNotificationContent
        contentTitle.text = content.title
        contentSubtitle.text = content.subtitle
        contentBody.text = content.body
        contentImageView.image = UIImage(named: "HuliLogo_20")
        let URLString = "http://www.sliceofapppie.com/wp-content/uploads/2018/11/PizzaParm.jpg"
        if let url = URL(string: URLString){
            DispatchQueue.global().async {
                [weak self] in
                if let data = try? Data(contentsOf: url){
                    if let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            self?.contentImageView.image = image
                        }
                    }
                }
            }
        }
        extensionContext?.notificationActions = [snoozeAction,likeAction]
    }
}
