//
//  NotificationViewController.swift
//  ContentNotification
//
//  Created by IMC056 on 2018. 10. 1..
//  Copyright © 2018년 IMC056. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageRatio: NSLayoutConstraint!
    
    @IBOutlet var logLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewSize: CGSize = self.view.bounds.size
        self.preferredContentSize = CGSize(width: viewSize.width, height: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        completion(.dismiss)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        let imageWidth: CGFloat = content.userInfo["imageWidth"] as! CGFloat
        let imageHeight: CGFloat = content.userInfo["imageHeight"] as! CGFloat
        
        let viewSize = self.view.bounds
        let viewSizeHeight: CGFloat = viewSize.size.width * imageHeight / imageWidth
        
        self.preferredContentSize = CGSize(width: viewSize.size.width, height: viewSizeHeight)
        let _ = self.imageRatio.setMultiplier(multiplier: viewSize.size.width / viewSizeHeight)
        
        if let urlImageString = content.userInfo["urlImageString"] as? String {
            if let url = URL(string: urlImageString) {
                URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                    if let _ = error {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        debugPrint("asdf")
                        let image: UIImage! = UIImage(data: data)
//                        self?.logLabel.text = "width ::: \(image.size.width) height ::: \(image.size.height)"
                        self?.imageView.image = image
//                        self?.logLabel.text = content.userInfo.description
//                        self?.logLabel.text = """
//                                didLoad = width ::: \(self?.didloadSize.width) height ::: \(self?.didloadSize.height)
//                                willLoad = width ::: \(self?.willLoadSize.width) height ::: \(self?.willLoadSize.height)
//                                receive = width ::: \(viewSize?.size.width) height ::: \(viewSize?.size.height)
//
//                                계산된 높이는 ::: \(viewSizeHeight)
//                        """
                    }
                }
            }
        }
    }
    
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension URLSession {
    class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            completionHandler(data, nil)
        }
        dataTask.resume()
    }
}
