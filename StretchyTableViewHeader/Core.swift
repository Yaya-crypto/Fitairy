//
//  Core.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import Foundation

/*
 Check if user is new or not
 */
class Core {
    
    static let shared = Core()
    
    // Default this returns false so we do inverse
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    // Show after welcome flow is dismissed
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
