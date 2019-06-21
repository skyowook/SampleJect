//
//  PINRemoteImageViewController.swift
//  TestProject
//
//  Created by IMC056 on 2018. 8. 23..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit
import PINCache

class PINRemoteImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrlArray: [String] = [String]()
    var currentUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUrlArray.append("http://images.coocha.co.kr/upload/2018/08/ticketmonster/22/thumb4_129913736.jpg")
        imageUrlArray.append("http://images.coocha.co.kr/upload/2018/08/WEMAKEPRICE/20/thumb4_129293980.jpg")
        imageUrlArray.append("http://images.coocha.co.kr/upload/2018/08/ticketmonster/23/thumb4_130291602.jpg")
        imageUrlArray.append("http://images.coocha.co.kr/upload/2018/08/g9g9/20/thumb4_129318972.jpg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    /// 이미지 불러오기
    @IBAction func touchImageLoadBtn(_ sender: AnyObject) {
        let url1: URL? = URL(string: imageUrlArray[0])
        let url2: URL? = URL(string: imageUrlArray[1])
        let url3: URL? = URL(string: imageUrlArray[2])
        let url4: URL? = URL(string: imageUrlArray[3])
        
        loadUrl(url1!, withIndex: 1)
        loadUrl(url2!, withIndex: 2)
        loadUrl(url3!, withIndex: 3)
        loadUrl(url4!, withIndex: 4)
    }
    
    /// 캐시 이미지 불러오기
    @IBAction func touchCacheImageLoadBtn(_ sender: AnyObject) {
        let url1: URL? = URL(string: imageUrlArray[0])
        let url2: URL? = URL(string: imageUrlArray[1])
        let url3: URL? = URL(string: imageUrlArray[2])
        let url4: URL? = URL(string: imageUrlArray[3])
        
        loadCacheImg(url1!, withIndex: 1)
        loadCacheImg(url2!, withIndex: 2)
        loadCacheImg(url3!, withIndex: 3)
        loadCacheImg(url4!, withIndex: 4)
    }
    
    func loadUrl(_ url: URL, withIndex index: Int) {
        

        self.imageView.currentUrl = url.absoluteString
        
        if index < 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                PINRemoteImageManager.shared().downloadImage(with: url) { (result) in
                    if let image = result.image {
                        DispatchQueue.main.async {
                            debugPrint(url.absoluteString)
                            
                            if self.imageView.currentUrl == url.absoluteString {
                                debugPrint("OK")
                                self.imageView.image = image
                            } else {
                                debugPrint("NO")
                            }
                        }
                    }
                }
            }
            
            return
        }
        
        PINRemoteImageManager.shared().downloadImage(with: url) { (result) in
            if let image = result.image {
                DispatchQueue.main.async {
                    debugPrint(url.absoluteString)

                    if self.imageView.currentUrl == url.absoluteString {
                        debugPrint("OK")
                        self.imageView.image = image
                    } else {
                        debugPrint("NO")
                    }
                }
                
                PINCache.shared().setObject(image, forKey: url.absoluteString)
            }
        }
    }
    
    func loadCacheImg(_ url: URL, withIndex index: Int) {
        self.imageView.currentUrl = url.absoluteString
        
        PINCache.shared().object(forKey: url.absoluteString) { (cache, key, object) in
            if self.imageView.currentUrl == key {
                debugPrint("key" + key)
                debugPrint("OK")
                DispatchQueue.main.async {
                    self.imageView.image = object as? UIImage
                }
            } else {
                debugPrint("NO")
            }
        }
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

private var key: Void?
extension UIImageView {
    public var currentUrl: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
    
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
