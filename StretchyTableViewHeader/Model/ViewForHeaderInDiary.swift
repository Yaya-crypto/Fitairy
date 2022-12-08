//
//  ViewForHeaderInDiary.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 12/4/22.
//
/*
 TODO: Figure out how to stack these labels nicely and more programmatically.
 I struggled trying to get the labels fitting nicely and ended up hardcoding x y width & height. Which is bad design
 TODO: Is there any other way to generate this content text without all this typing?
 Im thinking registering a xib file of type UIView and customizong it's own storyboard
 */
import Foundation
import UIKit
class ViewForHeaderInDiary: UIView {
    
    lazy var caloricGoalLabel: UILabel = {
       let caloricGoalLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 250, height: 30))
        caloricGoalLabel.text = UserDefaults.standard.integer(forKey: "CaloricGoal").description
        caloricGoalLabel.font = .boldSystemFont(ofSize: 20)
        return caloricGoalLabel
    }()
    
    lazy var caloricGoalTextLabel: UILabel = {
        let caloricGoalLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 250, height: 70))
         caloricGoalLabel.text = "Goal"
         caloricGoalLabel.font = .boldSystemFont(ofSize: 10)
         return caloricGoalLabel
    }()
    
    lazy var minusSymbolLabel: UILabel = {
        let minusSymbolLabel = UILabel(frame: CGRect(x: 100, y: 5, width: 250, height: 30))
        minusSymbolLabel.text = "-"
        minusSymbolLabel.font = .boldSystemFont(ofSize: 20)
        return minusSymbolLabel
    }()
    
    lazy var caloriesConsumedLabel: UILabel = {
        let caloriesConsumedLabel = UILabel(frame: CGRect(x: 140, y: 5, width: 250, height: 30))
        caloriesConsumedLabel.text = "0"
        caloriesConsumedLabel.font = .boldSystemFont(ofSize: 20)
        return caloriesConsumedLabel
    }()
    
    lazy var calorisConsumedTextLabel: UILabel = {
       let calorisConsumedTextLabel = UILabel(frame: CGRect(x:140, y: 5, width: 250, height: 70))
        calorisConsumedTextLabel.text = "Food"
        calorisConsumedTextLabel.font = .boldSystemFont(ofSize: 10)

        return calorisConsumedTextLabel
    }()
    
    lazy var equalsSignLabel: UILabel = {
        let equalsSignLabel = UILabel(frame: CGRect(x: 220, y: 5, width: 250, height: 30))
        equalsSignLabel.text = "="
        equalsSignLabel.font = .boldSystemFont(ofSize: 20)

        return equalsSignLabel
    }()
    
    lazy var caloriesLeftLabel: UILabel = {
        let caloriesLeftLabel = UILabel(frame: CGRect(x: 260, y: 5, width: 250, height: 30))
        caloriesLeftLabel.text = "0"
        caloriesLeftLabel.font = .boldSystemFont(ofSize: 20)
        return caloriesLeftLabel
    }()
    
    lazy var caloriesLeftTextLabel: UILabel = {
        let caloriesLeftLabel = UILabel(frame: CGRect(x: 260, y: 5, width: 250, height: 70))
        caloriesLeftLabel.text = "Remaining"
        caloriesLeftLabel.font = .boldSystemFont(ofSize: 10)
        return caloriesLeftLabel
    }()
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func changeCaloricGoalLabel(newCaloricGoal: Int) {
        caloricGoalLabel.text = newCaloricGoal.description
    }
    
    
    func changeCaloriesLabel(caloriesConsumed: Int, caloriesLeft: Int, caloricGoal: Int) {
        caloricGoalLabel.text = caloricGoal.description
        
        if caloriesConsumed > caloricGoal {
            caloriesLeftLabel.textColor = .red
        } else {
            caloriesLeftLabel.textColor = .green
        }
        
        caloriesConsumedLabel.text = caloriesConsumed.description
        caloriesLeftLabel.text = caloriesLeft.description
    }
    
    private func setupView() {
        backgroundColor = .systemTeal
        addSubview(caloricGoalLabel)
        addSubview(caloricGoalTextLabel)
        
        addSubview(minusSymbolLabel)
        addSubview(caloriesLeftLabel)
        addSubview(caloriesLeftTextLabel)
        
        addSubview(equalsSignLabel)
        
        
        addSubview(caloriesConsumedLabel)
        addSubview(calorisConsumedTextLabel)
    }

}
