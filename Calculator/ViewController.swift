//
//  ViewController.swift
//  Calculator
//
//  Created by Danut Popa on 03.06.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    var displayNumber: Double {
        let text = displayLabel.text!
        let number = Double(text)!
        return number
    }
    @IBOutlet var roundButtons: [UIButton]!
    
    @IBOutlet weak var multiplyButton: OperatorButton!
    @IBOutlet weak var divideButton: OperatorButton!
    @IBOutlet weak var minusButton: OperatorButton!
    @IBOutlet weak var plusButton: OperatorButton!
    lazy var operationButtons: [OperatorButton] = [divideButton, multiplyButton, minusButton, plusButton]
    
    enum Operation {
        case divide
        case multiply
        case subtract
        case add
        case none
    }
    
    var operation: Operation = .none
    var operationIsSelected: Bool {
        for button in operationButtons {
            if button.isSelection {
                return true
            }
        }
        return false
    }
    
    var previousNumber: Double?
    var equalsButtonTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    func setupButtons() {
        operationButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
        roundButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    @IBAction func didTapOperationButton(_ sender: OperatorButton) {
        if let _ = previousNumber, !equalsButtonTapped, !operationIsSelected {
            performOperation()
            previousNumber = nil
        }
        
        let title = sender.currentTitle
        switch title {
        case "÷":
            operation = .divide
        case "X":
            operation = .multiply
        case "-":
            operation = .subtract
        case "+":
            operation = .add
        default:
            break
        }
        highlightButton(sender)
        equalsButtonTapped = false
        
        previousNumber = displayNumber
    }
    
    func deselectButtons() {
        operationButtons.forEach { button in
            button.backgroundColor = .systemOrange
            button.setTitleColor(.white, for: .normal)
            button.isSelection = false
        }
    }
    
    func highlightButton(_ button: OperatorButton) {
        deselectButtons()
        button.backgroundColor = .white
        button.setTitleColor(.systemOrange, for: .normal)
        button.isSelection = true
    }
    
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        let number = sender.tag
        
        if operationIsSelected {
            deselectButtons()
            displayLabel.text = "\(number)"
        } else {
            if displayNumber == 0 {
                displayLabel.text = "\(number)"
            } else {
                displayLabel.text! += "\(number)"
            }
        }
    }
    
    func performOperation() {
        guard let previousNumber else { return }
        
        var result = 0.0
        switch operation {
        case .divide:
            result = previousNumber / displayNumber
        case .multiply:
            result = previousNumber * displayNumber
        case .subtract:
            result = previousNumber - displayNumber
        case .add:
            result = previousNumber + displayNumber
        case .none:
            return
        }
        if result.truncatingRemainder(dividingBy: 1) == 0 {
            let int = Int(result)
            displayLabel.text = "\(int)"
        } else {
            displayLabel.text = "\(result)"
        }
        self.previousNumber = result
    }
    
    @IBAction func didTapDecimalButton() {
        let text = displayLabel.text!
        if text.last == "." {
            displayLabel.text?.removeLast()
        } else if !text.contains(".") {
            displayLabel.text! += "."
        }
    }
    
    @IBAction func didTapEqualsButton() {
        guard operation != .none else { return }
        performOperation()
        equalsButtonTapped = true
    }
    
    
    @IBAction func didTapPercentButton() {
        guard var number = Double(displayLabel.text!) else { return }
        number /= 100
        displayLabel.text = "\(number)"
    }
    
    @IBAction func didTapPlusMinusButton() {
        guard var number = Double(displayLabel.text!) else { return }
        number *= -1
        displayLabel.text = "\(number)"
    }

    @IBAction func didTapClearButton() {
        previousNumber = nil
        displayLabel.text = "0"
        operation = .none
        deselectButtons()
    }
}

