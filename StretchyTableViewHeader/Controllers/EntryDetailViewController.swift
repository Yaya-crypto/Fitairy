//
//  EntryDetailViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import UIKit
import CoreData

protocol EntryDetailViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(
      _ controller: EntryDetailViewController)
    
    func addItemViewController<T> (
        _ controller: EntryDetailViewController, didFinishAdding obj: T)
    
    func showEntryDetailsOnLoad<T> (
        _ controller: EntryDetailViewController, didFinishAdding obj: T)
}

class EntryDetailViewController: UIViewController {
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var fatLabel:  UILabel!
    @IBOutlet var carbsLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var gramsLabel: UILabel!
    @IBOutlet var sugarsLabel: UILabel!
    @IBOutlet var loggedTimeLabel: UILabel!
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    // foodEntry passed from Search Results
    var foodEntryToAdd: FoodEntry.food!
    
    // diaryEntry passed from DiaryController
    var diaryEntry: DiaryEntry!
    
    weak var delegate: EntryDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "AFDCEB")
        
        // From SearchViewController
        if let food = foodEntryToAdd {
            delegate?.showEntryDetailsOnLoad(self, didFinishAdding: food)
        }
    
        // From DiaryEntryController
        if let food = diaryEntry {
            doneBarButton.isEnabled = false
            delegate?.showEntryDetailsOnLoad(self, didFinishAdding: food)
        }

    }
    
    /*
     From Diary and Search controller. Cancel will return to previous screen
     */
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    /*
     If the entry was from Search controller 'foodEntryToAdd' then log
     Else Do nothing
     */
    @IBAction func logFood() {
        if let food = foodEntryToAdd {
            delegate?.addItemViewController(self, didFinishAdding: food)
        }
        if let food = diaryEntry {
            delegate?.addItemViewController(self, didFinishAdding: food)
        }
        
    }
}
