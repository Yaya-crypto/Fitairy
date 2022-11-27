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
     //   tableView.reloadData()
        performFetch()
        
//        let fetchRequest = NSFetchRequest<DiaryEntry>()
//
//        let entity = DiaryEntry.entity()
//        fetchRequest.entity = entity
//
//        let sortDescriptor = NSSortDescriptor(
//        key: "nf_calories", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            coreDataEntries = try managedObjectContext.fetch(fetchRequest)
//        } catch {
//            fatalError("Error \(error)")
//        }

    }
    
    // MARK: Table View Delegates
    
    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "FoodEntry",
        for: indexPath)

      // let item = coreDataEntries[indexPath.row]
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
        
       // return coreDataEntries.count
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
      forRowAt indexPath: IndexPath
    ) {
      // 1
        
        //entries.remove(at: indexPath.row)
        // coreDataEntries.remove(at: indexPath.row)
        
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            managedObjectContext.delete(entry)
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error doing something idk \(error)")
            }
        }

      // 2
//      let indexPaths = [indexPath]
//      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
//      if let cell = tableView.cellForRow(at: indexPath) {
//        let item = coreDataEntries[indexPath.row]
//
//      }

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
             //   let foodDetail = coreDataEntries[indexPath.row]
                let foodDetail = fetchedResultsController.object(at: indexPath)
                controller.diaryEntry = foodDetail
                
             //  controller.managedObjectContext = managedObjectContext
            }
        }
        if segue.identifier == "searchFood" {
            let controller = segue.destination as! SearchViewController
            controller.managedObjectContext = managedObjectContext
        }
        
        guard let searchViewController = segue.destination as? SearchViewController else { return }
        searchViewController.delegate = self

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




/*
 SearchViewControllerDelegate protocol.
 */
extension DiaryTableViewController: SeachViewControllerDelegate {
    func save(_ foodEntry: DiaryEntry) {
        
//        let newRowIndex = coreDataEntries.count
//        coreDataEntries.append(foodEntry)
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}

extension DiaryTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .move:
            print("Nothing to move")
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")

        @unknown default:
            print("UNKOWN DEFAULT AHHHHHHHH")
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType) {
            
            switch type {
            case .insert:
                print("*** NSFetchedResultsChangeInsert (section)")
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
                
            case .delete:
                print("*** NSFetchedResultsChangeDelete (section)")
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
                
            case .update:
                print("*** NSFetchedResultsChangeUpdate (section)")
                
            case .move:
                print("*** NSFetchedResultsChangeMove (section)")
                
            @unknown default:
                print("*** NSFetchedResults unknown type")
            }
        }
    
    
    
}
