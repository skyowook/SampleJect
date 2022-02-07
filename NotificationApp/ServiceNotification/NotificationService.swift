//
//  NotificationService.swift
//  ServiceNotification
//
//  Created by IMC056 on 2018. 10. 1..
//  Copyright © 2018년 IMC056. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            bestAttemptContent.userInfo["imageWidth"] = 0
            bestAttemptContent.userInfo["imageHeight"] = 0
            
            var urlString:String? = nil
            if let urlImageString = request.content.userInfo["urlImageString"] as? String {
                urlString = urlImageString
            }
            
            if urlString != nil, let fileUrl = URL(string: urlString!) {
                print("fileUrl: \(fileUrl)")
                
                do {
                    let imageData = try Data(contentsOf: fileUrl)
                    
                    guard let attachment = UNNotificationAttachment.saveImageToDisk(fileIdentifier: "image.jpg", data: imageData, options: nil) else {
                        print("error in UNNotificationAttachment.saveImageToDisk()")
                        contentHandler(bestAttemptContent)
                        return
                    }
                    
                    if let uiImage: UIImage = UIImage(data: imageData) {
                        bestAttemptContent.userInfo["imageWidth"] = uiImage.size.width
                        bestAttemptContent.userInfo["imageHeight"] = uiImage.size.height
                    }
                    
                    bestAttemptContent.attachments = [ attachment ]
                } catch {
                    contentHandler(bestAttemptContent)
                    return
                }
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}

@available(iOSApplicationExtension 10.0, *)
extension UNNotificationAttachment {
    
    static func saveImageToDisk(fileIdentifier: String, data: Data, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: folderURL!, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileURL!, options: [])
            let attachment = try UNNotificationAttachment(identifier: fileIdentifier, url: fileURL!, options: options)
            return attachment
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}
