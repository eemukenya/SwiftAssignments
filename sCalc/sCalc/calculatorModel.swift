//
//  calculatorModel.swift
//  sCalc
//  Created by  Edwin Eddy Mukenya
//  Reg No.     091795
//  Created by ilabadmin on 2/16/17.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import Foundation

func percentage(op1:Double)->Double
{
    return op1/100
}

class calculatorModel {
    
    private var accumulator=0.0
    private var currentPrecedence = Int.max
    
    private var valueDigit:Int
    
    init(valueDigit:Int){
        self.valueDigit=valueDigit
    }
    
    
    private var valueHistory="0"{
        didSet {
            if pending == nil {
                
                currentPrecedence = Int.max
                
            }
        }
    }
    
    var sHistory: String {
        get {
            if pending == nil {
                return valueHistory
                
            } else {
                return pending!.historyFunc(pending!.historyOperand,
                                            pending!.historyOperand != valueHistory ? valueHistory : "")
                
            }
            
            
        }
        
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    
    private enum Operation{
        case Constants(Double)
        case UnaryOperations((Double)->Double,(String)->String)
        case BinaryOperations((Double,Double)->Double,(String,String)->String,Int)
        case Result
        case Clear
    }
    
    private struct PendingBinaryOp{
        var binaryFunc:(Double,Double)->Double
        var firstOperand:Double
        var historyFunc: (String, String)-> String
        var historyOperand:String
        
    }
    
    private var pending:PendingBinaryOp?
    
    func getOperands(operand:Double){
        
        accumulator=operand
        let decimalpoints = NSNumberFormatter()
            decimalpoints.numberStyle = .DecimalStyle
            decimalpoints.maximumFractionDigits = valueDigit
            valueHistory = decimalpoints.stringFromNumber(operand)!
        
    }
    

    func executeOp(){
        
        if pending != nil{
            accumulator=pending!.binaryFunc(pending!.firstOperand,accumulator)
            valueHistory=pending!.historyFunc(pending!.historyOperand,valueHistory)
            pending=nil
        }
    }
    
    private var operations:Dictionary<String,Operation>=[
        "∏" : Operation.Constants(M_PI), //M_PI,
        "√" : Operation.UnaryOperations(sqrt,{"√("+$0+")"}),
        "÷" : Operation.BinaryOperations(/,{$0+"/"+$1},1),
        "×" :Operation.BinaryOperations(*,{$0+"*"+$1},1),//closure
        // "+" : Operation.BinaryOperations(Addition),
        "+" : Operation.BinaryOperations(+,{$0+"+"+$1},0),
        "-" : Operation.BinaryOperations(-,{$0+"-"+$1},0),
        "Sin" : Operation.UnaryOperations(sin,{"sin("+$0+")"}),
        "Cos" : Operation.UnaryOperations(cos,{"cos("+$0+")"}),
        "Tan" : Operation.UnaryOperations(tan,{"tan("+$0+")"}),
        "℮" : Operation.Constants(M_E),
        "%" : Operation.UnaryOperations(percentage,{"("+$0+")%"}),
        "±" : Operation.UnaryOperations({-$0},{"-("+$0+")"}),
        "=" : Operation.Result,
        "AC": Operation.Clear
    ]
    
    private func clear(){
        accumulator=0
        pending=nil
        valueHistory=""
        
    }
    func performOperation(symbol:String){
        
        if let opertion = operations[symbol]{
            
            switch opertion {
            case .Constants(let value):
                accumulator = value
                valueHistory=symbol
            case .UnaryOperations(let function,let histFunction):
                accumulator=function(accumulator)
                valueHistory=histFunction(valueHistory)
            case .BinaryOperations(let function,let histFunction,let pec):
                executeOp()
                if currentPrecedence < pec {
                    valueHistory="("+valueHistory+")"
                    
                }
                pending=PendingBinaryOp(binaryFunc: function, firstOperand: accumulator,historyFunc: histFunction,historyOperand: valueHistory)
                
                
                
            case .Result:
                executeOp()
                
            case .Clear:
                clear()
                // default:
                //     break
            }
        }
        
        
    }
    
    var result:Double{
        get{
            
            return accumulator
        }
    }
    
}
