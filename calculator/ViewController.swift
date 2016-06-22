//
//  ViewController.swift
//  calculator
//
//  Created by Thomas Bao on 6/19/16.
//  Copyright © 2016 Thomas Bao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var displayValue: UILabel!
    @IBOutlet private weak var descriptionValue: UILabel!
    private var model = CalculatorBrain()
    private var isInMiddleOfTyping = false
    
    private var currentValue: Double {
        get {
            return Double(displayValue.text!)!
        }
        set(newValue) {
            displayValue.text = String(newValue)
        }
    }
    
    private var hasDecimal: Bool {
        get {
            if let text = displayValue.text {
                return text.characters.contains(".")
            }
            return false
        }
    }
    
    override func viewDidLoad() {
        displayValue.text = "0"
        descriptionValue.text = " "
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(sender: UIButton) {
        displayValue.text = "0"
        isInMiddleOfTyping = false
        model.clear()
        model.variableValues.removeAll()
        descriptionValue.text = " "
    }
    @IBAction func pressDecimal(sender: UIButton) {
        if (hasDecimal) {
            return
        } else {
            displayValue.text = displayValue.text! + "."
            isInMiddleOfTyping = true
        }
    }
    @IBAction func pressDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if isInMiddleOfTyping {
            displayValue.text = displayValue.text! + digit
        } else {
            displayValue.text = digit
            isInMiddleOfTyping = true
        }
    }
    
    @IBAction func pressOperation(sender: UIButton) {
        if isInMiddleOfTyping {
            model.setAccumulator(currentValue)
        }
        let symbol = (sender.currentTitle)!
        isInMiddleOfTyping = false
        model.performOperation(symbol)
        currentValue = model.result
        if model.isPartialResult {
            descriptionValue.text = model.description + " ..."
        } else {
            descriptionValue.text = model.description + " ="
        }
    }
    
    @IBAction func setVariableValue(sender: UIButton) {
        model.variableValues["M"] = currentValue
        model.program = model.program
        currentValue = model.result
        isInMiddleOfTyping = false
    }
    
    @IBAction func pressUndo(sender: UIButton) {
        if isInMiddleOfTyping && displayValue.text != nil {
            displayValue.text! = String(displayValue.text!.characters.dropLast())
        } else {
            var program = model.program
            program.removeLast()
            model.program = program
            if model.isPartialResult {
                descriptionValue.text = model.description + " ..."
            } else {
                descriptionValue.text = model.description + " ="
            }
            currentValue = model.result
            isInMiddleOfTyping = false
        }
        if displayValue.text == "" || displayValue.text == nil {
            displayValue.text = "0"
            isInMiddleOfTyping = false
        }
    }
}

