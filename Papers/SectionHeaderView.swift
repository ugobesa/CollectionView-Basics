//
//  SectionHeaderView.swift
//  Papers
//
//  Created by Ugo Besa on 24/03/2016.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SectionheaderView: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel:UILabel!
    @IBOutlet private weak var seasonImageView:UIImageView!
    
    var title:String? {
        didSet {
            titleLabel.text = title
            seasonImageView.image = UIImage(named: title!)
        }
    }
    
}
