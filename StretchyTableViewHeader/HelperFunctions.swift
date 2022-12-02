//
//  HelperFunctions.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/27/22.
//

import Foundation

let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
    

  return paths[0]
}()


 let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
//      formatter.dateStyle = .short
//      formatter.timeStyle = .none
    formatter.dateFormat = "MM/dd"
  return formatter
}()
