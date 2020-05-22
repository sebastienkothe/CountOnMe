//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Private properties
    @IBOutlet weak private var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!

    private var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }

    // MARK: Private methods
    @IBAction private func didTapOnNumberButton(_ sender: UIButton) {

        guard let numberText = sender.title(for: .normal) else {
            return
        }

        let errorsFound = ExpressionChecker().checkTheExpressionConformity(textView: textView, elements: elements)

        if errorsFound.contains(1) || errorsFound.contains(3) { textView.text = "" }

        textView.text.append(numberText)
    }

    @IBAction private func didTapOnOperatorButton(_ sender: UIButton) {

        let errorsFound = ExpressionChecker().checkTheExpressionConformity(textView: textView, elements: elements)

        for error in errorsFound {
            if error == 1 || error == 3 { showTheMessageAlertNumber(1); return }
            if error == 4 { showTheMessageAlertNumber(0); return }
        }

        let `operator` = Operator()
             `operator`.addAnOperator(senderTag: sender.tag, textView: textView)
        }

    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        let errorsFound = ExpressionChecker().checkTheExpressionConformity(textView: textView, elements: elements)
        if let errorFoundIsTrue = errorsFound.first {
            showTheMessageAlertNumber(errorFoundIsTrue)
            return
        }

        // Create local copy of operations
        var operationsToReduce = elements

        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {

            let operatorInElements: String? = operationsToReduce[1]
            let operandRightInElements: String? = operationsToReduce[0]
            let operandLeftInElements: String? = operationsToReduce[2]

            guard let `operator` = operatorInElements else { return }
            guard let operandRight = operandRightInElements else { return }
            guard let operandLeft = operandLeftInElements else { return }

            guard let operandLeftConverted = Int(operandLeft), let operandRightConverted = Int(operandRight) else {
                textView.text = "ERROR"
                return
            }

            let calculation = Calculation().performTheOperation(`operator`, operandLeftConverted, operandRightConverted)

            guard let result = calculation else { return }

            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }

        textView.text.append(" = \(operationsToReduce.first!)")
    }

    private func showTheMessageAlertNumber(_ number: Int) {
        AlertMessageHandler().showAlertMessage(viewController: self, alertControllerIndex: number)
    }
}
