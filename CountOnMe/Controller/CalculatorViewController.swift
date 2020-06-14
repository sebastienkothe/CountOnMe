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
        calculator.addMathOperatorFrom(tag: sender.tag)
    }
    
    @IBAction private func didTapOnResetButton() {
        calculator.cleanTextToCompute()
    }
    
    @IBAction private func didTapOnEqualButton() {
        calculator.handleTheExpressionToCalculate()
    }
    
    private func handleError(error: CalculatorError) {
        let alertController = UIAlertController(title: "Error", message: error.title, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Alright!", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

extension CalculatorViewController: CalculatorDelegate {
    func didProduceError(_ error: CalculatorError) {
        handleError(error: error)
    }
    
    func didChangeOperation(_ operation: String) {
        calculatorScreenTextView.text = operation.isEmpty ? "0" : operation
    }
}
