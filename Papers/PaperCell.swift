//
//  PaperCell.swift
//  Papers
//
//  Created by Mic Pringle on 09/01/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class PaperCell: UICollectionViewCell {
  
  @IBOutlet private weak var paperImageView: UIImageView!
  @IBOutlet private weak var gradientView: GradientView!
  @IBOutlet private weak var captionLabel: UILabel!
  @IBOutlet private weak var checkImageView: UIImageView!
    
    var editing = false {
        didSet {
            captionLabel.hidden = editing
            checkImageView.hidden = !editing
        }
    }
    
    var moving = false {
        didSet {
            let alpha:CGFloat = moving ? 0.0 : 1.0
            paperImageView.alpha = alpha
            gradientView.alpha = alpha
            captionLabel.alpha = alpha
        }
    }
    
    var snapshot: UIView {
        get {
            let snapshot = snapshotViewAfterScreenUpdates(true)
            let layer = snapshot.layer
            layer.masksToBounds = false // for the shadows. (masksToBounds clipps everything outside the bounds)
            layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
            layer.shadowRadius = 5.0
            layer.shadowOpacity = 0.4
            return snapshot
        }
    }
  
  var paper: Paper? {
    didSet {
      if let paper = paper {
        paperImageView.image = UIImage(named: paper.imageName)
        captionLabel.text = paper.caption
      }
    }
  }
    
    
    override var selected: Bool {
        didSet {
            if editing {
                checkImageView.image = UIImage(named: selected ? "Checked" : "Unchecked")
            }
        }
    }
  
}
