//
//  UITableViewTestController.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 3. 20..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

/// UITableView에 관련된 기능들을 테스트하는 샘플
class UITableViewTestController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var isRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Table View"
        setNavigationBackTitle("뒤로")

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "BaseTableViewCell")
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

// MARK: - UITableView Delegate, DataSource
extension UITableViewTestController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        debugPrint("섹션 개수 변경::: ")
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("줄 개수 변경::: \(section)")
        if isRefresh && section == 1{
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BaseTableViewCell") as! BaseTableViewCell
        
        let contentView: RefreshContentView = RefreshContentView.createView()
        
        contentView.titleLabel.text = "타이틀 \(indexPath.row)번째 입니다."
        contentView.delegate = self
        cell.setContentSubView(contentSubView: contentView)
        
        debugPrint("몇번째 갱신? \(indexPath.row)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isRefresh && indexPath.row == 3{
            return 50.0
        }
        
        debugPrint("몇번째 높이? \(indexPath.row) :::: \(indexPath.section)")
        
        return 200.0
    }
}

extension UITableViewTestController: BaseContentViewDelegate {
    func refreshContentView() {
        isRefresh = !isRefresh
        
        tableView.beginUpdates()
        //tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: UITableViewRowAnimation.fade)
        tableView.reloadSections(IndexSet([1]), with: UITableViewRowAnimation.none)
        tableView.endUpdates()
    }
}
