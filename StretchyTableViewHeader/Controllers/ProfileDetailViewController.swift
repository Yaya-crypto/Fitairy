//
//  ProfileDetailViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import UIKit

class ProfileDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor().hexStringToUIColor(hex: "AFDCEB")
        navigationItem.largeTitleDisplayMode = .always
        dismissKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        textField.keyboardType = .numberPad
    }

    // MARK: - Text Field Delegates
    
    /*
     Remove keyboard when user finished typing
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    /*
     When a user finishes typing insert the new caloric goal
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        } else {
            UserDefaults.standard.set(textField.text, forKey: "CaloricGoal")
            tableView.footerView(forSection: 0)?.frame.size.width = tableView.frame.width - 20
            tableView.footerView(forSection: 0)?.textLabel?.text = "Current Goal: \(textField.text!)"
            textField.text = ""
            return true
        }
   
    }
    /*
     Dismisses the keyboard if the user taps outside the textfield
     */
    func dismissKeyboard() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(dismissKeyboardTouchOutside))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
        }
        
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return the header title for the specified section
        return "Change Caloric goal"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Current Goal: \(UserDefaults.standard.integer(forKey: "CaloricGoal"))"
    }
    
    

}
