//
//  RelationKeywordTagCell.swift
//  SampleJect
//
//  Created by IMC056 on 2018. 4. 17..
//  Copyright © 2018년 SinKyoUk. All rights reserved.
//

import UIKit

class RelationKeywordTagCell: BaseTagCell {
    static let NIB: UINib = UINib(nibName: "RelationKeywordTagCell", bundle: nil)      // #. UINib Load
    
    override func getDefaultSize() -> CGSize {
        return CGSize(width: 12, height: 23)
    }
}
