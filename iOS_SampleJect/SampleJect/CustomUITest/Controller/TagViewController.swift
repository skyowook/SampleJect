//
//  TagViewController.swift
//  TestProject
//
//  Created by IMC056 on 2018. 4. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {
    
    @IBOutlet private weak var tagView: TagView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Tag View"
        setNavigationBackTitle("뒤로")
        
        var tags = [String]()
        
        var tagStrings = ["길이", "두번째 길이", "세번째 길이는 이거", "네번째 길이는 다시 이거"]
        
        for i in 0...32 {
            tags.append("\(tagStrings[i / 10])태그 몇번 \(i)")
        }
        
        tagView.tags = tags
        tagView.registerTag(RelationKeywordTagCell.NIB)
        tagView.reloadData()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
