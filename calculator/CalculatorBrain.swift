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
    
    var result: Double {
        get {
            return accumulator;
        }
    }
    
    private var symbolTable: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation({sqrt($0)}),
        "±": Operation.UnaryOperation({-$0}),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    private func executePending() {
        if pending != nil {
            accumulator = pending!.binaryOperator(pending!.operand1, accumulator)
            pending = nil
        }
    }
    
    func setAccumulator(value: Double) {
        accumulator = value
    }
    
    func performOperation(symbol: String) {
        if let operation = symbolTable[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let op):
                accumulator = op(accumulator)
            case .BinaryOperation(let op):
                executePending()
                pending = PendingBinaryOperation(operand1: accumulator, binaryOperator: op)
            case .Equals:
                executePending()
            }
        }
    }
}