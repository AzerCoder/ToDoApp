//
//  CheckListItem.swift
//  ToDoApp
//
//  Created by A'zamjon Abdumuxtorov on 12/03/24.
//

import Foundation
import UserNotifications

class CheckListItem:NSObject,Codable{
    var id = UUID().uuidString
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false

    init(text: String = "", checked: Bool = false) {
        self.text = text
        self.checked = checked
    }
    
    override init() {
        
    }
    
    func scheduleNotification(){
        removeNotification()
        if shouldRemind && dueDate > Date(){
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let colendar = Calendar(identifier: .gregorian)
            let component = colendar.dateComponents([.year,.month,.day,.hour,.minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification (){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    deinit{
        removeNotification()
    }
}


class CheckList: NSObject,Codable{
    
    var name = ""
    var items : [CheckListItem] = []
    var iconName = "clock"
    
    init(name: String = "",iconName: String = "clock") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems()->String{
        var count = 0
        
        for item in items where !item.checked{
            count += 1
        }
        
        if count == 0{
            return "No items"
        }else{
            return "\(count) Remaning"
        }
    }
}
