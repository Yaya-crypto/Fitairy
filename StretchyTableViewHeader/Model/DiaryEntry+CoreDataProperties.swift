//
//  DiaryEntry+CoreDataProperties.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/27/22.
//
//

import Foundation
import CoreData


extension DiaryEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntry> {
        return NSFetchRequest<DiaryEntry>(entityName: "DiaryEntry")
    }

    @NSManaged public var nf_calories: Float
    @NSManaged public var food_name: String
    @NSManaged public var serving_qty: Int16
    @NSManaged public var serving_weight_grams: Int16
    @NSManaged public var nf_total_fat: Float
    @NSManaged public var nf_total_carbohydrate: Float
    @NSManaged public var nf_sugars: Float
    @NSManaged public var nf_protein: Float

}

extension DiaryEntry : Identifiable {

}
