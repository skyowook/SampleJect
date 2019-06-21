//
//  FilterTagCell.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 4. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class FilterTagCell: BaseTagCell {
    static let NIB: UINib = UINib(nibName: "FilterTagCell", bundle: nil)      // #. UINib Load
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 13
    }
    
    @IBAction func touchCloseBtn(_ sender: AnyObject) {
        deleteTag()
    }
    
    override func getDefaultSize() -> CGSize {
        return CGSize(width: 34, height: 26)
    }
    
}
