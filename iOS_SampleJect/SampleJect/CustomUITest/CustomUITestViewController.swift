//
//  CustomTableViewController.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 4. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class CustomUITestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController?
        
        switch indexPath.row {
        case 0:
            viewController = TagViewController(nibName: "TagViewController", bundle: Bundle.main)
        default:
            return
        }
        
        if let controller = viewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
