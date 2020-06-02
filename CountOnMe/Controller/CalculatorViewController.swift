//
//  CalculatorViewController.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    let calculator = Calculator()
    
    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }
    
    // MARK: Private properties
    @IBOutlet weak private var calculatorScreenTextView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    
    private var elements: [String] {
        return calculatorScreenTextView.text.split(separator: " ").map { "\($0)" }
    }
    
    // MARK: Private methods
    
    // @IBAction
    @IBAction private func didTapOnDigitButton(_ sender: UIButton) {
        guard let numberAsString = sender.title(for: .normal) else { return }
        calculator.addDigit(numberAsString)
    }
    
    @IBAction private func didTapOnMathOperatorButton(sender: UIButton) {
        calculator.identifyTheOperatorFromThe(sender.tag) { (result) in
            switch result {
            case .success(let operatorRecovered):
                do {
                    try self.calculator.addMathOperator(operatorRecovered)
                } catch {
                    guard error is CalculatorError else { return }
                    self.handleError(error: error as! CalculatorError)
                }
            case .failure(let errorRecovered):
                self.handleError(error: errorRecovered)
            }
        }
    }
    
    @IBAction private func didTapOnResetButton() {
        calculator.resetOperation()
    }
    
    func handleError(error: CalculatorError) {
        let alertController = UIAlertController(title: "Error", message: error.title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Alright!", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    //    @IBAction private func didTapOnOperatorButton(_ sender: UIButton) {
    //
    //        let errorsFound = ExpressionChecker().checkTheExpressionConformity(textView: calculatorScreenTextView, elements: elements)
    //
    //        for error in errorsFound {
    //            if error == 1 || error == 3 { showTheMessageAlertNumber(1); return }
    //            if error == 4 { showTheMessageAlertNumber(0); return }
    //        }
    //
    //        let `operator` = Operator()
    //             `operator`.addAnOperator(senderTag: sender.tag, textView: calculatorScreenTextView)
    //        }
    //
    //    @IBAction private func tappedEqualButton(_ sender: UIButton) {
    //        let errorsFound = ExpressionChecker().checkTheExpressionConformity(textView: calculatorScreenTextView, elements: elements)
    //        if let errorFoundIsTrue = errorsFound.first {
    //            showTheMessageAlertNumber(errorFoundIsTrue)
    //            return
    //        }
    //
    //        // Create local copy of operations
    //        var operationsToReduce = elements
    //
    //        // Iterate over operations while an operand still here
    //        while operationsToReduce.count > 1 {
    //
    //            let operatorInElements: String? = operationsToReduce[1]
    //            let operandRightInElements: String? = operationsToReduce[0]
    //            let operandLeftInElements: String? = operationsToReduce[2]
    //
    //            guard let `operator` = operatorInElements else { return }
    //            guard let operandRight = operandRightInElements else { return }
    //            guard let operandLeft = operandLeftInElements else { return }
    //
    //            guard let operandLeftConverted = Int(operandLeft), let operandRightConverted = Int(operandRight) else {
    //                calculatorScreenTextView.text = "ERROR"
    //                return
    //            }
    //
    //            let calculation = Calculator().performTheOperation(`operator`, operandLeftConverted, operandRightConverted)
    //
    //            guard let result = calculation else { return }
    //
    //            operationsToReduce = Array(operationsToReduce.dropFirst(3))
    //            operationsToReduce.insert("\(result)", at: 0)
    //        }
    //
    //        calculatorScreenTextView.text.append(" = \(operationsToReduce.first!)")
    //    }
    //
    //    // Private methods
    //    private func showTheMessageAlertNumber(_ number: Int) {
    //        AlertMessageHandler().showAlertMessage(viewController: self, alertControllerIndex: number)
    //    }
}

extension CalculatorViewController: CalculatorDelegate  {
    
    func textToComputeDidChange(textToCompute: String) {
        calculatorScreenTextView.text = textToCompute
    }
    
}
