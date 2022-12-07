//
//  HelperFunctions.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/27/22.
//

import Foundation
import UIKit

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
    

  return paths[0]
}()


 let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
  return formatter
}()


/*
 https://forums.swift.org/t/adding-defaultvalue-method-to-optional/34048/9
 */
extension Optional {
  func get(or defaultValue: @autoclosure () -> Wrapped) -> Wrapped {
    self ?? defaultValue()
  }
}

let attrs = [
    NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!
]

// https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values
extension UIColor {
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
