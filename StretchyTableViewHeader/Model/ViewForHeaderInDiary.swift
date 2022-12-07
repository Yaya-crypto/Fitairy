//
//  ViewForHeaderInDiary.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 12/4/22.
//

import Foundation
import UIKit
class ViewForHeaderInDiary: UIView {
    
    lazy var caloricGoalLabel: UILabel = {
       let caloricGoalLabel = UILabel(frame: CGRect(x: 43, y: 5, width: 250, height: 40))
        caloricGoalLabel.text = UserDefaults.standard.integer(forKey: "CaloricGoal").description
        caloricGoalLabel.font = .boldSystemFont(ofSize: 20)
        return caloricGoalLabel
    }()
    
    lazy var caloriesConsumedLabel: UILabel = {
        let caloriesConsumedLabel = UILabel(frame: CGRect(x: 143, y: 5, width: 250, height: 40))
        caloriesConsumedLabel.text = "0"
        caloriesConsumedLabel.font = .boldSystemFont(ofSize: 20)
        return caloriesConsumedLabel
    }()
    
    
    lazy var caloriesLeftLabel: UILabel = {
        let caloriesLeftLabel = UILabel(frame: CGRect(x: 243, y: 5, width: 250, height: 40))
        caloriesLeftLabel.text = "0"
        caloriesLeftLabel.font = .boldSystemFont(ofSize: 20)
        return caloriesLeftLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func changeCaloricGoalLabel(newCaloricGoal: Int) {
        caloricGoalLabel.text = newCaloricGoal.description
    }
    
    
    func changeCaloriesLabel(caloriesConsumed: Int, caloriesLeft: Int, caloricGoal: Int) {

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
        addSubview(caloriesConsumedLabel)
        addSubview(caloriesLeftLabel)
    }
}
