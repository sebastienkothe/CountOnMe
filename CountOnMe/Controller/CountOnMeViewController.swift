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

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // View actions
    @IBAction func didTapOnNumberButton(_ sender: UIButton) {
        let expressionHasAResult = ExpressionChecker().expressionHasAResult(element: textView)

        guard let numberText = sender.title(for: .normal) else {
            return
        }

        if expressionHasAResult || textView.text == "ERROR" {
            textView.text = ""
        }

        textView.text.append(numberText)
    }

    @IBAction func didTapOnOperatorButton(_ sender: UIButton) {
        let expressionHasAResult = ExpressionChecker().expressionHasAResult(element: textView)

        guard !expressionHasAResult else {
            return
        }
        // To save the sender's tag and to use it most later
        Operator.operatorTag = sender.tag
        addAnOperator()
    }

    func addAnOperator() {
        let `operator` = Operator()
        let expressionIsCorrect = ExpressionChecker().checkIfTheExpressionIsCorrect(itemsToCheck: elements)

        guard expressionIsCorrect else {
            return
        }

        guard let operatorSelected = `operator`.operatorSignProvider else {
            return
        }

        textView.text.append(operatorSelected)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        let alertMessageHandler = AlertMessageHandler()

        let expressionHasAResult = ExpressionChecker().expressionHasAResult(element: textView)

        guard !expressionHasAResult else {
            return
        }

        let expresionIsCorrect = ExpressionChecker().checkIfTheExpressionIsCorrect(itemsToCheck: elements)

        guard expresionIsCorrect else {
            return
        }

        guard elements.count >= 3 else {
            alertMessageHandler.showAlertMessage(viewController: self, alertControllerIndex: 1)
            return
        }

        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let operand: String? = operationsToReduce[1]
            let operandLeft: String? = operationsToReduce[0]
            let operandRight: String? = operationsToReduce[2]

            let operationItems = [operand, operandLeft, operandRight]

            for item in operationItems where item == nil {
                return
            }

            guard let operandLeftConverted = Int(operandLeft!),
                  let operandRightConverted = Int(operandRight!) else {

                    textView.text = "ERROR"
                return
            }

            let calculation = Calculation()

            guard let result = calculation.performTheOperation(operatorRecovered: operand!, operandLeft: operandLeftConverted, operandRight: operandRightConverted) else {
                return
            }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }

        textView.text.append(" = \(operationsToReduce.first!)")
    }
}
