//
//  ImageColorFilterViewController.swift
//  TestProject
//
//  Created by Sin's Retina on 2018. 8. 9..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

/*
    이미지에 컬러 필터 입히기 우선 UIImage의 렌더링 모드를 automatic -> alwaysTemplate로 변경
    그다음 UIImageView에 담고 나서 UIImageView의 tintColor를 바꿔주면 해당 컬러가 입혀진다.
 */
class ImageColorFilterViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Image Color Filter"
        setNavigationBackTitle("뒤로")
        
        self.imageView.image = UIImage(named: "imageColorFilter")
        
        // 이미지의 기본 렌더링은 automatic으로 지정되어 있음.
        self.imageView.image = self.imageView.image?.withRenderingMode(.alwaysTemplate)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchGreenBtn(_ sender: AnyObject) {
        self.imageView.image = self.imageView.image?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = UIColor.green
    }
    
    @IBAction func touchBlueBtn(_ sender: AnyObject) {
        self.imageView.image = self.imageView.image?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = UIColor.blue
    }
    
    @IBAction func touchOriginBtn(_ sender: AnyObject) {
        self.imageView.image = self.imageView.image?.withRenderingMode(.automatic)
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
