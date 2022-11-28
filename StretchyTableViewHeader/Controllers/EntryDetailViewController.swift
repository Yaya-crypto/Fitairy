//
//  EntryDetailViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import UIKit
import CoreData

class EntryDetailViewController: UIViewController {
    @IBOutlet var servingSizeLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var fatLabel:  UILabel!
    @IBOutlet var carbsLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var  doneBarButton: UIBarButtonItem!
    
    // foodEntry passed from Search Results
    var foodEntryToAdd: FoodEntry.food!
    
    // diaryEntry passed from DiaryController
    var diaryEntry: DiaryEntry!

    
    override func viewDidLoad() {
  
        super.viewDidLoad()
        
        // From SearchViewController
        if let food = foodEntryToAdd {
            title = food.food_name // title of navigation controller

        }
        
        // From DiaryEntryController
        if let food = diaryEntry {
            title = food.food_name
        }

    }
    
    /*
     TODO: Figure out how to go back from clicking on the diary screen and disable Done button
     */
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
}
