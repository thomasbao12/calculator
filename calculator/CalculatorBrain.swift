//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Thomas Bao on 6/19/16.
//  Copyright © 2016 Thomas Bao. All rights reserved.
//

import Foundation

class CalculatorBrain {
    struct PendingBinaryOperation {
        var operand1: Double
        var binaryOperator: (Double, Double) -> Double
    }
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private var accumulator = 0.0
    private var pending: PendingBinaryOperation?
    private var description: String = ""
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    var result: Double {
        get {
            return accumulator;
        }
    }
    
    var descriptionSoFar: String {
        get {
            return description
        }
    }
    
    private var symbolTable: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation({sqrt($0)}),
        "∛": Operation.UnaryOperation({ pow($0, 1.0/3.0) }),
        "eˣ": Operation.UnaryOperation({ exp($0) }),
        "10ˣ": Operation.UnaryOperation({ pow(10, $0) }),
        "ln": Operation.UnaryOperation({ log($0) }),
        "log₁₀": Operation.UnaryOperation({ log10($0) }),
        "sin": Operation.UnaryOperation({ sin($0) }),
        "cos": Operation.UnaryOperation({ cos($0) }),
        "tan": Operation.UnaryOperation({ tan($0) }),
        "±": Operation.UnaryOperation({ -$0 }),
        "%": Operation.UnaryOperation({ $0/100.0 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    private func executePending() {
        if pending != nil {
            let last = description.characters.last
            if (last != "." && last != ")" && (last < "0" || last > "9")) {
                description = description + " " + String(accumulator)
            }
            accumulator = pending!.binaryOperator(pending!.operand1, accumulator)
            pending = nil
        }
    }
    
    func setAccumulator(value: Double) {
        accumulator = value
        if (!isPartialResult) {
            description = String(accumulator)
        }
    }
    
    func clear() {
        description = ""
        pending = nil
        accumulator = 0
    }
    
    func performOperation(symbol: String) {
        if (description == "") {
            description = String(accumulator)
        }
        if let operation = symbolTable[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                if (isPartialResult) {
                    description = description + " " + symbol
                } else {
                    description = symbol
                }
            case .UnaryOperation(let op):
                if (isPartialResult) {
                    description = description + " " + symbol + "(" + String(accumulator) + ")"
                } else {
                    description = symbol + "(" + description + ")"
                }
                accumulator = op(accumulator)
                
            case .BinaryOperation(let op):
                executePending()
                pending = PendingBinaryOperation(operand1: accumulator, binaryOperator: op)
                description = description + " " + symbol
            case .Equals:
                executePending()
            }
        }
    }
}