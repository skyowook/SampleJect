//
//  UtilsTestViewControllerTableViewController.swift
//  SampleJect
//
//  Created by Sin's Retina on 2018. 8. 9..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class UtilsTestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Utils 테스트 화면"

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
        case 0:
            viewController = ImageColorFilterViewController(nibName: "ImageColorFilterViewController", bundle: Bundle.main)
        case 1:
            viewController = RunLoopViewController(nibName: "RunLoopViewController", bundle: Bundle.main)
        default:
            return
        }
        
        if let controller = viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
