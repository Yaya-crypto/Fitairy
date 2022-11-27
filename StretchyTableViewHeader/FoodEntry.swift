//
//  FoodEntry.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/25/22.
//

import Foundation

/*
 Natural Language API. A user can search multiple foods at once. Array of foods
 */
struct FoodEntry : Codable {
    struct food : Codable{
        struct full_nutrients : Codable{
            let attr_id : Int
            let value : Double
        }
        struct photo : Codable{
            let thumb : String
            let highres : String
            let is_user_uploaded : Bool
        }
        
        let food_name : String
        let serving_qty : Int
        let serving_unit : String
        let serving_weight_grams : Int
        let nf_calories : Float
        let nf_total_fat : Float?
        let nf_total_carbohydrate : Float?
        let nf_sugars : Float?
        let nf_protein : Float?
        let nf_saturated_fat : Float?
        let nf_cholesterol : Float?
        let nf_sodium : Float?
        let nf_dietary_fiber : Float?
        let nf_potassium : Float?
        let nf_p : Float?
        let full_nutrients : [full_nutrients]
        let photo : photo
        }
    let foods : [food]
}





/*
 Full response request of the API is of this format
 
 struct foods : Codable {
     struct food : Codable{
         struct full_nutrients : Codable{
             let attr_id : Int
             let value : Double
         }
         struct photo : Codable{
             let thumb : String
             let highres : String
             let is_user_uploaded : Bool
         }
         let food_name : String
         let serving_qty : Int
         let serving_unit : String
         let serving_weight_grams : Int
         let nf_calories : Float
         let nf_total_fat : Float?
         //let nf_saturated_fat : Float?
         //let nf_cholesterol : Float?
         //let nf_sodium : Float?
         // let nf_dietary_fiber : Float?
         let nf_total_carbohydrate : Float?
         let nf_sugars : Float?
         let nf_protein : Float?
         let nf_potassium : Float?
         let nf_p : Float?
         let full_nutrients : [full_nutrients]
         let photo : photo
         }
     let foods : [food]
 }
 */
