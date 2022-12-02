//
//  ViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import UIKit
import CoreData

class DiaryTableViewController: UITableViewController, EntryDetailViewControllerDelegate {
    
    // Disable done button
    func addItemViewController<T>(_ controller: EntryDetailViewController, didFinishAdding obj: T) {
        print("")
    }
    
    
    func addItemViewControllerDidCancel(_ controller: EntryDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    var managedObjectContext: NSManagedObjectContext!
    var caloriesConsumed = Float()
    
    lazy var fetchedResultsController: NSFetchedResultsController<DiaryEntry> = { // 12/01 ==
        let fetchRequest = NSFetchRequest<DiaryEntry>()

        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var userLocale = calendar.locale // NSDATEformatter for locale timezone, store in UTC
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())                     // 2022-12-01 05:00:00 +0000 -5
        let dateTo =  calendar.date(byAdding: .day, value: 1, to: dateFrom) // 2022-12-02 05:00:00 +0000 -5

        // Set predicate as date being today's date
        // If the date is greater than starting date or less than next date
         let datePredicate = NSPredicate(format: "dateLogged >= %@ AND dateLogged <= %@", dateFrom as NSDate, dateTo! as NSDate)

        
        print("------- DATE FROM") // 2022-12-01 05:00:00 +0000
        print(dateFrom)
        print("------- DATE TO")   // 2022-12-02 05:00:00 +0000
        print(dateTo!)
                                  // 2022-12-01 17:30:53 +0000 orange

        let entity = DiaryEntry.entity()
        fetchRequest.entity = entity
       
        let sortDescriptor = NSSortDescriptor(key: "nf_calories", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchRequest.predicate = datePredicate
        
        let fetchedResultsController = NSFetchedResultsController(
          fetchRequest: fetchRequest,
          managedObjectContext: self.managedObjectContext,
          sectionNameKeyPath: nil,
          cacheName: "DiaryEntry")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
    }
    
    
    // MARK: Table View Delegates
    
    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
      let cell = tableView.dequeueReusableCell(withIdentifier: "FoodEntry", for: indexPath)

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
    
//    override func tableView(
//        _ tableView: UITableView,
//        viewForHeaderInSection section: Int
//    ) -> UIView? {
//
//        let sectionHeaderBackgroundColor = UIColor(hue: 0.021, saturation: 0.34, brightness: 0.94, alpha: 0.4)
//        let vw = UIView()
//        vw.frame = CGRect(x: 3, y: 10, width: 30, height: 30)
//        vw.backgroundColor = sectionHeaderBackgroundColor
//
//        let calorieLabel = UILabel()
//        calorieLabel.text = "\(UserDefaults.standard.integer(forKey: "CaloricGoal"))"
//        calorieLabel.frame = CGRect(x: 43, y: 5, width: 250, height: 40)
//
//        let caloriesConsumedlabel = UILabel()
//        calorieLabel.text = "\(caloriesConsumed)"
//        calorieLabel.frame = CGRect(x: 63, y: 5, width: 250, height: 40)
//
//        vw.addSubview(calorieLabel)
//       // vw.backgroundColor = UIColor.red
//
//        return vw
//    }
    
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
      label.text = "\(item.food_name) Calories: \(item.nf_calories)"
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
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
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
