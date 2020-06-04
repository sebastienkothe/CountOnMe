//
//  CalculatorViewController.swift
//  CountOnMe
//
//  Created by Sébastien Kothé on 31/05/2020.
//  Copyright © 2020 sebastienkothe. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: Internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }
    
    // MARK: Private properties
    private let calculator = Calculator()
    
    @IBOutlet weak private var calculatorScreenTextView: UITextView!
    
    // MARK: Private methods
    @IBAction private func didTapOnDigitButton(_ sender: UIButton) {
        guard let numberAsString = sender.title(for: .normal) else { return }
        calculator.addDigit(numberAsString)
    }
    
    @IBAction private func didTapOnMathOperatorButton(sender: UIButton) {
        calculator.identifyTheOperatorFromThe(sender.tag) { (result) in
            guard let operatorRecovered = result else { return }
            do {
                try self.calculator.addMathOperator(operatorRecovered)
            } catch {
                guard let errorFound = error as? CalculatorError else { return }
                handleError(error: errorFound)
            }
        }
    }
    
    @IBAction private func didTapOnResetButton() {
        calculator.resetOperation()
    }
    
    @IBAction private func didTapOnEqualButton() {
        do {
            try calculator.handleTheExpressionToCalculate()
        } catch {
            guard let errorFound = error as? CalculatorError else { return }
            handleError(error: errorFound)
        }
    }
    
    private func handleError(error: CalculatorError) {
        let alertController = UIAlertController(title: "Error", message: error.title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Alright!", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension CalculatorViewController: CalculatorDelegate  {
    func textToComputeDidChange(textToCompute: String) {
        calculatorScreenTextView.text = textToCompute.isEmpty ? "0" : textToCompute
    }
}
