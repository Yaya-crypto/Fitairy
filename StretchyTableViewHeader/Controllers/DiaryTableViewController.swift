//
//  ViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var caloricGoal = UserDefaults.standard.integer(forKey: "CaloricGoal")
    var caloriesConsumed = 0
    var caloriesLeft = 0
    var headerView = ViewForHeaderInDiary()
    
    // Create the UIDatePicker
    var datePicker = UIDatePicker()
    
    // Create a variable to store the selected date
    var selectedDate: Date?
    
    
    @IBOutlet weak var searchFoodButton: UIBarButtonItem!
    
    lazy var fetchedResultsController: NSFetchedResultsController<DiaryEntry> = {
        let fetchRequest = NSFetchRequest<DiaryEntry>()

        // Get the current calendar with local time zone NSDATEformatter for locale timezone, store in UTC
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        
        
        let selectedDate2 = selectedDate.get(or: calendar.startOfDay(for: Date()))
        let dateTo =  calendar.date(byAdding: .day, value: 1, to: selectedDate2) // 2022-12-02 05:00:00 +0000 -5
        
        // Set predicate as date being today's date
        // If the date is greater than starting date or less than next date
        let datePredicate = NSPredicate(format: "dateLogged >= %@ AND dateLogged <= %@", selectedDate2 as NSDate, dateTo! as NSDate)
        fetchRequest.predicate = datePredicate
        
        let entity = DiaryEntry.entity()
        fetchRequest.entity = entity

        let sortDescriptor = NSSortDescriptor(key: "nf_calories", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        
        let fetchedResultsController = NSFetchedResultsController(
          fetchRequest: fetchRequest,
          managedObjectContext: self.managedObjectContext,
          sectionNameKeyPath: nil,
          cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "AFDCEB")
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!
        ]
        searchFoodButton.setTitleTextAttributes(attrs, for: .normal)
        
        performFetch()
        updateCaloricTotal()
        headerView.changeCaloriesLabel(caloriesConsumed: caloriesConsumed, caloriesLeft: caloriesLeft, caloricGoal: caloricGoal)
        datePickerOnNavbarTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: Table View Delegates
    
    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
      let cell = tableView.dequeueReusableCell(withIdentifier: "FoodEntry", for: indexPath)

          cell.backgroundColor = UIColor().hexStringToUIColor(hex: "ADD8E6")
      let item = fetchedResultsController.object(at: indexPath)
      configureText(for: cell, with: item)

      
      return cell
    }
    
    
    
    /*
     NSFetchedResultsSectionInfo describes each section of the table view
     number of rows are from the numberOfObjects
     */
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        
        let sections = fetchedResultsController.sections![section]
        return sections.numberOfObjects

    }
    
    /*
     Ask NSFetchedresultsController for a list of sections and get name/count
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    /*
     Delete an entry in the diary
     */
    override func tableView(
      _ tableView: UITableView,
      commit editingStyle: UITableViewCell.EditingStyle,
      forRowAt indexPath: IndexPath) {
          
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            managedObjectContext.delete(entry)
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error doing something idk \(error)")
            }
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /*
     Updates the caloryGoal for the UILabel
     Red if the User went over the goal
     Green if the User is within the limit
     */
    func updateCaloricTotal() {
        caloriesConsumed = 0
        caloriesLeft = 0
        
        fetchedResultsController.fetchedObjects?.forEach {entry in
            caloriesConsumed += Int(entry.nf_calories)
        }
        caloriesLeft = caloricGoal - caloriesConsumed

    }
    
    func datePickerOnNavbarTitle() {
        // Set the mode to the date picker
        datePicker.datePickerMode = .date

        // Set the navigation bar title to the date picker
        navigationItem.titleView = datePicker

        // Add a tap gesture recognizer to the navigation bar title
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapNavigationBarTitle))
        navigationItem.titleView?.addGestureRecognizer(tapGestureRecognizer)

        // Add a target-action for the date picker's value changed event
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        // Add a tap gesture recognizer to the view
       // let viewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        //view.addGestureRecognizer(viewTapGestureRecognizer)
    }
    
    @objc func didTapNavigationBarTitle() {
        // Open the date picker at the bottom of the screen
        datePicker.frame = CGRect(x: 0, y: view.frame.height - datePicker.frame.height, width: view.frame.width, height: datePicker.frame.height)
        view.addSubview(datePicker)
        
    }
    
    @objc func dateChanged() {
        // Save the selected date when it is changed
        selectedDate = datePicker.date
        performFetch()
        tableView.reloadData()
        
    }

    @objc func didTapView() {
        // Hide the date picker if it is open
        if datePicker.isDescendant(of: view) {
            datePicker.removeFromSuperview()
        }
    }

    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
          
    }

    
    /*
     Shows the welcome screen if it's a new User. First screen that pops up.
     Checks if new User. If new user. If new Present the Welcome Screen
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen // users can swipe down onboarding without this
            present(vc, animated: true)
        }
     
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "diaryEntryDetail" {
            
            let controller = segue.destination as! EntryDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let foodDetail = fetchedResultsController.object(at: indexPath)
                controller.diaryEntry = foodDetail
                controller.delegate = self

            }
        }
        if segue.identifier == "searchFood" {
            let controller = segue.destination as! SearchViewController
            controller.managedObjectContext = managedObjectContext
        }

    }
    

    
    // MARK: Helper Methods
    
    func configureText(
      for cell: UITableViewCell,
      with item: DiaryEntry) {
          
      let label = cell.viewWithTag(1000) as! UILabel
          label.text = "\(item.food_name.capitalized) \(item.serving_weight_grams)g"
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error \(error)")
        }
    }
    

}


extension DiaryTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            updateCaloricTotal()
            headerView.changeCaloriesLabel(caloriesConsumed: caloriesConsumed, caloriesLeft: caloriesLeft, caloricGoal: caloricGoal)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            updateCaloricTotal()
            headerView.changeCaloriesLabel(caloriesConsumed: caloriesConsumed, caloriesLeft: caloriesLeft, caloricGoal: caloricGoal)
        case .move:
            fallthrough
        case .update:
            fallthrough

        @unknown default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType) {
            
            switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
                
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                
            case .update:
                fallthrough
                
            case .move:
                fallthrough
                
            @unknown default:
                break
            }
        }
}

extension DiaryTableViewController: EntryDetailViewControllerDelegate {
    func showEntryDetailsOnLoad<T>(_ controller: EntryDetailViewController, didFinishAdding obj: T) {
        if let foodEntry = controller.diaryEntry {
            controller.title = "Entry"
            controller.foodNameLabel.text = foodEntry.food_name.capitalized
            controller.caloriesLabel.text = foodEntry.nf_calories.description + "g"
            controller.fatLabel.text = foodEntry.nf_total_fat.description + "g"
            controller.carbsLabel.text = foodEntry.nf_total_carbohydrate.description + "g"
            controller.sugarsLabel.text = foodEntry.nf_sugars.description + "g"
            controller.proteinLabel.text = foodEntry.nf_protein.description + "g"
            controller.gramsLabel.text = foodEntry.serving_weight_grams.description
            controller.loggedTimeLabel.text = dateFormatter.string(from: foodEntry.dateLogged)
        }
    }
    
    
    // Disable done button
    func addItemViewController<T>(_ controller: EntryDetailViewController, didFinishAdding obj: T) {
        print("")
    }
    
    
    func addItemViewControllerDidCancel(_ controller: EntryDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
