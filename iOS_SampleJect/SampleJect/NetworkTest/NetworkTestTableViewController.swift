//
//  NetworkTestTableViewController.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 8. 23..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class NetworkTestTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        switch(indexPath.row) {
        case 0:
            viewController = PINRemoteImageViewController(nibName: "PINRemoteImageViewController", bundle: Bundle.main)
            break;
        default:
            return;
        }
        
        if let controller = viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
