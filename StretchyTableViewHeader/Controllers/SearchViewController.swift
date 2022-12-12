//
//  SearchViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    var date = Date()

    struct TableView {
      struct CellIdentifiers {
        static let searchResultCell = "SearchResultCell"
          static let nothingFoundCell = "NothingFoundCell"
      }
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
   // var hasSearched = false
    //var foodResult = FoodEntry(foods: [])
  //  var dataTask: URLSessionDataTask?
    var managedObjectContext: NSManagedObjectContext!
    private let search = Search()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "AFDCEB")
        searchBar.barTintColor = UIColor().hexStringToUIColor(hex: "CAE9F5")
        //searchBar.searchTextField.backgroundColor = UIColor().hexStringToUIColor(hex: "F0F8FF")
        tableView.backgroundColor = UIColor().hexStringToUIColor(hex: "AFDCEB")
        
        // Sets the BookmarkIcon to a Barcode scanning icon
        searchBar.setImage(UIImage(systemName: "barcode.viewfinder"), for: .bookmark, state: .normal)
        
        // Register the NIB tablecell SearchResultCell
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)

        // register the nothing found cell
        cellNib = UINib(nibName:
        TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        // Space between results and searchBar
        tableView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)
        
        // Keyboard popup on launch
        searchBar.becomeFirstResponder()
        dismissKeyboard()
    }
    
    /*
     Hide Navigation Bar for Diary screen
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    /*
     Bring back Navigation Bar once screen changes
     */
    override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     navigationController?.isNavigationBarHidden = false
     
    }
    
    // MARK: - Helper Methods
    
    /*
     Delay in showing the animation and returning back to searchController
     */
    func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
      DispatchQueue.main.asyncAfter(
        deadline: .now() + seconds,
        execute: run)
    }
    
    /*
     Changes the API response FoodEntry to the CoreData model DiaryEntry
     */
    func convert(foodEntry food: FoodEntry.food, toDiary entry: DiaryEntry) -> DiaryEntry {
        entry.food_name = food.food_name
        entry.nf_calories = food.nf_calories
        entry.nf_protein = food.nf_protein.get(or: 0)
        entry.nf_total_carbohydrate = food.nf_total_carbohydrate.get(or: 0)
        entry.nf_sugars = food.nf_sugars.get(or: 0)
        entry.serving_qty = Int32(food.serving_qty)
        entry.serving_weight_grams = Int32(food.serving_weight_grams)
        entry.nf_total_fat = food.nf_total_fat.get(or: 0)
        entry.dateLogged = Date()
        return entry
    }
    
    /*
     If the user taps outside the search box the keyboard closes
     */
    func dismissKeyboard() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(dismissKeyboardTouchOutside))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
        }
        
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
        
    // MARK: - Navigation

    // "foodItem" is the segue from Search to Entry
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "foodItem" {
            if case .results(let list) = search.state {
                let controller = segue.destination as! EntryDetailViewController
                let indexPath = sender as! IndexPath
                let foodDetail = list.foods[indexPath.row]
                controller.foodEntryToAdd = foodDetail
                controller.delegate = self
            }

        }
    }
    

}


extension SearchViewController: UISearchBarDelegate {
    
    /*
     User performs a search for a food
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        search.performSearch(for: searchBar.text!) { success in
            if !success {
                print("Error")
                print("This?")
                print(self.search.state)
            }
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    /*
     If the user tapped the barcode icon.
     TODO: Implement barcode scanning with another API. This would open the camera and upon succes redirect to the EntryDetailPage
     */
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    }
    
    /*
     Leave searchbar on top
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
     return .topAttached
   }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    /*
     If The user hasnt search, Nothing should show
     Else if user searched and nothing was found. Result is null
     Else show results
     */
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int {
          switch search.state {
          case .notSearchedYet:
              return 0
          case .noResults:
              return 1
          case .results(let list):
              return list.foods.count
          }
    }
    
    /*
     Return nothing found cell if the food is not in the database
     Else returns the cell that was searched
     */
    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          switch search.state {
          case .notSearchedYet:
              fatalError("Nothing to do")
              
          case .noResults:
              return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
              
          case .results(let list):
              let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
              
              let searchResults = list.foods[indexPath.row]
              cell.foodname.text = searchResults.food_name.capitalized
              cell.foodMacros.text = "Calories: \(searchResults.nf_calories) Fat: \(searchResults.nf_total_fat.get(or: 0)) Protein: \(searchResults.nf_protein.get(or: 0))"
              return cell
          }
      }
    
    /*
     De-selects the row a user tapped. Makes it not grey
     Also performs the segue to EntryDetailViewController
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "foodItem", sender: indexPath)
    }
    
    /*
     I forgot what this does
     */
    func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath ) -> IndexPath? {
          switch search.state {
          case .notSearchedYet, .noResults:
              return nil
          case .results:
              return indexPath
          }
    }
}

/*
 Protocol for Delegate. DiaryTableViewController is the delegate used
 Save saves the entry to the diary list
 */

extension SearchViewController: EntryDetailViewControllerDelegate {
    func showEntryDetailsOnLoad<T>(_ controller: EntryDetailViewController, didFinishAdding obj: T) {
        if let foodEntry = controller.foodEntryToAdd {
            controller.title = "Log Food"
            controller.foodNameLabel.text = foodEntry.food_name.capitalized
            controller.caloriesLabel.text = foodEntry.nf_calories.description + "g"
            controller.fatLabel.text = foodEntry.nf_total_fat.get(or: 0).description + "g"
            controller.carbsLabel.text = foodEntry.nf_total_carbohydrate.get(or: 0).description + "g"
            controller.sugarsLabel.text = foodEntry.nf_sugars.get(or: 0).description + "g"
            controller.proteinLabel.text = foodEntry.nf_protein.get(or: 0).description + "g"
            controller.gramsLabel.text = foodEntry.serving_weight_grams.description
            controller.loggedTimeLabel.text = dateFormatter.string(from: date)
        }
    }
    
    /*
     Navigate to previous screen
     */
    func addItemViewControllerDidCancel(_ controller: EntryDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
     Adds an entry to Core Data
     */
    func addItemViewController<T>(_ controller: EntryDetailViewController, didFinishAdding obj: T) {
        guard let mainView = navigationController?.parent?.view else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        hudView.text = "Logged"
  
            let foodEntry = controller.foodEntryToAdd
            if let foodEntry = foodEntry {

                var entry = DiaryEntry(context: managedObjectContext)
                entry = convert(foodEntry: foodEntry, toDiary: entry)
                do {
                    try managedObjectContext.save()
                    afterDelay(0.6) {
                        hudView.hide()
                    }
                } catch {
                    fatalError("Error: \(error)")
                }
            }
        navigationController?.popViewController(animated: true)
    }
    
}
