//
//  WelcomeViewController.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    
    let scrollview = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /*
     Remove keyboard when user finished typing
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    /*
     Hide Nav and tab bar
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        self.hidesBottomBarWhenPushed = true
    }
    
    /*
     Bring back nav and tab bar for other views
     */
    override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     navigationController?.isNavigationBarHidden = false
        self.hidesBottomBarWhenPushed = false
    }
    
    /*
     Disable done button if user hasnt submitted any info
     */
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }
    
    /*
     Check user keystrokes to make sure input isnt null
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newTest = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newTest.isEmpty
        return true
    }

    /*
     So constraints for holderview r added
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureView()
    }
    
    func configureView() {
        label.font = UIFont(name: "Thonburi", size: 32)
        imageView.image = UIImage(named: "onboard")
        
        textField.keyboardType = .numberPad
        
        doneButton.layer.cornerRadius = 10 // rounded button
    }
    
    /*
     Creates and sets a UserDefault for the users caloric goal
     */
    @IBAction func finished() {
        UserDefaults.standard.integer(forKey: "CaloricGoal")
        UserDefaults.standard.set(textField.text!, forKey: "CaloricGoal")
        
        Core.shared.setIsNotNewUser()
        dismiss(animated: true)
    }

}


