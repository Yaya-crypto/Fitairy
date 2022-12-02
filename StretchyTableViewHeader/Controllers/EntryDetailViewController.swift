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
    
    func addItemViewController<T>(
        _ controller: EntryDetailViewController, didFinishAdding obj: T)
}


class EntryDetailViewController: UIViewController {
    @IBOutlet var servingSizeLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var fatLabel:  UILabel!
    @IBOutlet var carbsLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var  doneBarButton: UIBarButtonItem!
    
    // foodEntry passed from Search Results
    var foodEntryToAdd: FoodEntry.food!
    
    weak var delegate: EntryDetailViewControllerDelegate?
    // diaryEntry passed from DiaryController
    var diaryEntry: DiaryEntry!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // From SearchViewController
        if let food = foodEntryToAdd {
            title = food.food_name.capitalized // title of navigation controller
            caloriesLabel.text = "Serving size: \(food.serving_weight_grams) Calories: \(food.nf_calories) Fat: \(food.nf_total_fat) Carbs: \(food.nf_total_carbohydrate)"
            
        }
        
        // From DiaryEntryController
        if let food = diaryEntry {
            doneBarButton.isEnabled = false
            title = food.food_name.capitalized
            caloriesLabel.text = "Serving size: \(food.serving_weight_grams) Calories: \(food.nf_calories) Fat: \(food.nf_total_fat) Carbs: \(food.nf_total_carbohydrate)"
        }
        
    }
    
    /*
     TODO: Figure out how to go back from clicking on the diary screen and disable Done button
     */
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func logFood() {
        if let food = foodEntryToAdd {
            delegate?.addItemViewController(self, didFinishAdding: food)
        }
        if let food = diaryEntry {
            delegate?.addItemViewController(self, didFinishAdding: food)
        }
        
    }
}
