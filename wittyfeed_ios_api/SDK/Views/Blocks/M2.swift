//
//  M2.swift
//  wittyfeed_ios_sdk
//
//  Created by Sudama Dewda on 29/12/17.
//  Copyright © 2017 Vatsana Technologies. All rights reserved.
//

import UIKit

class M2: UICollectionViewCell {
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    var blockDataObject = BlockDataClass()
    class BlockDataClass{
        var position: Int?
        var block: Block!
        var section_name: String = ""
        var block_type: String = ""
        var block_count = 0
        var column_count = 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
