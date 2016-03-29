//
//  MasterViewController.swift
//  Papers
//
//  Created by Mic Pringle on 09/01/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {
    
    @IBOutlet private weak var addButton:UIBarButtonItem!
  
  private var papersDataSource = PapersDataSource()
    
  private var snapshot: UIView?
  private var sourceIndexPath: NSIndexPath?
  
  // MARK: UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.toolbarHidden = true
    navigationItem.leftBarButtonItem = editButtonItem()
    
    let width = CGRectGetWidth(collectionView!.frame) / 3
    let layout = collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: width)
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MasterViewController.handleLongPress(_:)))
    collectionView?.addGestureRecognizer(longPressGestureRecognizer)
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MasterToDetail" {
      let detailViewController = segue.destinationViewController as! DetailViewController
      detailViewController.paper = sender as? Paper
    }
  }
    
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.enabled = !editing
        collectionView?.allowsMultipleSelection = editing
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems() {
            
            for indexPath in indexPaths {
                collectionView?.deselectItemAtIndexPath(indexPath, animated: true)
                let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PaperCell
                cell.editing = editing
            }
        }
        
        if !editing {
            navigationController?.setToolbarHidden(true, animated: animated)
        }
        
    }
    
    // MARK: MasterViewController
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        // Create a new object, insert it in the datasource and retrieve its indexPath
        let indexPath = papersDataSource.indexPathForNewRandomPaper()
        let layout = collectionViewLayout as! PapersFlowLayout
        layout.appearingItemIndexPath = indexPath
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.collectionView!.insertItemsAtIndexPaths([indexPath])
            }, completion: { (finished) -> Void in
                layout.appearingItemIndexPath = nil
        })
    }
    
    
    @IBAction func deleteButtonTapped(sender: UIBarButtonItem) {
        
        
        if let indexPaths = collectionView?.indexPathsForSelectedItems() {
            
            let layout = collectionViewLayout as! PapersFlowLayout
            layout.disappearingItemIndexPaths = indexPaths
            papersDataSource.deleteItemsAtIndexPaths(indexPaths)
            
            UIView.animateWithDuration(0.65, delay: 0, options:UIViewAnimationOptions.CurveEaseIn, animations: {
                self.collectionView?.deleteItemsAtIndexPaths(indexPaths)
                }, completion: { (finished) -> Void in
                    layout.disappearingItemIndexPaths = nil
            })
            
        }
    }
    
    
    private func updateSnapshotView(center:CGPoint, transform: CGAffineTransform, alpha:CGFloat){
        if let snapshot = snapshot {
            snapshot.center = center
            snapshot.transform = transform
            snapshot.alpha = alpha
        }
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer){
        if editing {
            return
        }
        
        let location = recognizer.locationInView(collectionView)
        let indexPath = collectionView?.indexPathForItemAtPoint(location)
        
        switch recognizer.state {
        case .Began:
            if let indexPath = indexPath {
                sourceIndexPath = indexPath
                let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! PaperCell
                snapshot = cell.snapshot
                updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 1.0)
                collectionView?.addSubview(snapshot!)
                UIView.animateWithDuration(0.25, animations: { 
                    self.updateSnapshotView(cell.center, transform: CGAffineTransformMakeScale(1.05, 1.05), alpha: 0.95)
                })
                cell.moving = true
            }
        
        case .Changed:
            self.snapshot?.center = location
            if let indexPath = indexPath {
                if let sourceIP = sourceIndexPath {
                    self.papersDataSource.movePaperAtIndexPath(sourceIP, toIndexPath:indexPath)
                    collectionView?.moveItemAtIndexPath(sourceIP, toIndexPath: indexPath)
                    self.sourceIndexPath = indexPath
                }
            }
        
        default:
            if let sourceIP = sourceIndexPath {
                let cell = collectionView?.cellForItemAtIndexPath(sourceIP) as! PaperCell
                UIView.animateWithDuration(0.25, animations: { 
                    self.updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 1.0)
                    cell.moving = false
                    }, completion: { finished in
                        self.snapshot?.removeFromSuperview()
                        self.snapshot = nil
                })
            }
            
            
        }
    }
    
    
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return papersDataSource.numberOfSections
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return papersDataSource.numberOfPapersInSection(section)
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PaperCell", forIndexPath: indexPath) as! PaperCell
    if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
      cell.paper = paper
      cell.editing = editing
    }
    return cell
  }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! SectionheaderView
        
        if let title = papersDataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeaderView.title = title
        }
        
        return sectionHeaderView
    }
  
  // MARK: UICollectionViewDelegate
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    if !editing {
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("MasterToDetail", sender: paper)
        }
    }
    else {
        navigationController?.setToolbarHidden(false, animated: true)
    }
  }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            if collectionView.indexPathsForSelectedItems()?.count == 0 {
                navigationController?.setToolbarHidden(true, animated: true)
            }
        }
    }
  
}

