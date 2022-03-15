//
//  UITestTableViewController.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 3. 20..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit
import SafariServices

class UITestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBackTitle("뒤로")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController?
        
        switch indexPath.row {
        case 0: // TableView
            viewController = UITableViewTestController(nibName: "UITableViewTestController", bundle: Bundle.main)
        case 1: // StackView
            viewController = StackViewTestController(nibName: "StackViewTestController", bundle: Bundle.main)
        case 2: // WKWebView
            viewController = WKWebViewTestController(nibName: "WKWebViewTestController", bundle: Bundle.main)
        case 3: // SFSafariViewController
            let svc = SFSafariViewController(url: URL(string: "https://54o-a.tlnk.io/serve?action=click&campaign_id_ios=321662&destination_id_ios=481115&publisher_id=354907&site_id_ios=722001810_N&my_ad=N_1101&my_placement=")!)
            self.present(svc, animated: true, completion: nil)
        case 4: // Alert
            showAlertTest()
            return
        case 5: // Material Bottom Sheet
            BottomSheetContentController.open(from: self)
            return
        default:
            return
        }
        
        if let controller = viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    /// Alert 호출
    func showAlertTest() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            self.showAlertTest()
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        //            UIApplication.shared.delegate.window!?.rootViewController?.present(alert, animated: true, completion: nil)
        if let window: UIWindow = UIApplication.shared.delegate?.window.unsafelyUnwrapped {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
        //            self.present(alert, animated: true, completion: nil)
    }
}
