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
    private var accumulatorDescription: String = "0.0"
    private var pendingDescription: String = ""
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    var description: String {
        get {
            if (isPartialResult) {
                return pendingDescription
            } else {
                return accumulatorDescription
            }
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
            accumulatorDescription = pendingDescription + " " + accumulatorDescription
            pendingDescription = ""
            accumulator = pending!.binaryOperator(pending!.operand1, accumulator)
            pending = nil
        }
    }
    
    func setAccumulator(value: Double) {
        accumulator = value
        accumulatorDescription = String(accumulator)
    }
    
    func clear() {
        accumulatorDescription = "0.0"
        pendingDescription = ""
        pending = nil
        accumulator = 0.0
    }
    
    func performOperation(symbol: String) {
        if let operation = symbolTable[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                accumulatorDescription = symbol
            case .UnaryOperation(let op):
                accumulatorDescription = symbol + "(" + accumulatorDescription + ")"
                accumulator = op(accumulator)
            case .BinaryOperation(let op):
                executePending()
                pending = PendingBinaryOperation(operand1: accumulator, binaryOperator: op)
                pendingDescription = accumulatorDescription + " " + symbol
            case .Equals:
                executePending()
            }
        }
    }
}