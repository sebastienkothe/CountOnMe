//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        let `operator` = Operator()
        let alertMessageHandler = AlertMessageHandler()
        
        for operatorSign in `operator`.operatorSign where elements.last != operatorSign /*.trimmingCharacters(in: .whitespaces)*/ {
            return true
        }
        
        alertMessageHandler.showAlertMessage(viewController: self, alertControllerIndex: 0)
        return false
    }
    
    var expressionHaveEnoughElement: Bool {
        let alertMessageHandler = AlertMessageHandler()
        
        if elements.count >= 3 {
            return true
        }
        
        alertMessageHandler.showAlertMessage(viewController: self, alertControllerIndex: 0)
        return false
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if expressionHaveResult {
            textView.text = ""
        }
        
        textView.text.append(numberText)
    }
    
    @IBAction func didTapOnOperatorButton(_ sender: UIButton) {
        Operator.operatorTag = sender.tag
        addAnOperator()
    }
    
    func addAnOperator() {
        let `operator` = Operator()
        
        guard expressionIsCorrect else {
            return
        }
    
        textView.text.append(`operator`.operatorSignProvider)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        
        guard expressionIsCorrect else {
            return
        }
        
        guard expressionHaveEnoughElement else {
            return
        }
        
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "*": result = left * right
            case "/": result = left / right
                
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        
        textView.text.append(" = \(operationsToReduce.first!)")
    }
    
}
