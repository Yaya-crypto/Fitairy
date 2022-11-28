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
    
    var entries = [FoodEntry.food]()
    var coreDataEntries = [DiaryEntry]()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<DiaryEntry> = {
        let fetchRequest = NSFetchRequest<DiaryEntry>()
        
        let entity = DiaryEntry.entity()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "nf_calories", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
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
        
        if !Core.shared.isNewUser() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen // users can swipe down onboarding without this
            present(vc, animated: true)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "diaryEntryDetail" {
            
            let controller = segue.destination as! EntryDetailViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let foodDetail = fetchedResultsController.object(at: indexPath)
                controller.diaryEntry = foodDetail

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
