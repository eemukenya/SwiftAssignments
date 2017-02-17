//
//  ViewController.swift
//  sCalc
//  Created by  Edwin Eddy Mukenya
//  Reg No.     091795
//  Created at ilabadmin on 1/30/17.
//  Copyright © 2017 Strathmore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lblDisplay: UILabel!
    
    
    @IBOutlet weak var lblHistory: UILabel!
  
    
    var isUserTyping :Bool=false
    
    
    var displayValue:Double{
        get{
            return Double(lblDisplay.text!)!
        }
        set{
            lblDisplay.text=String(newValue)
        }
    
    }
    var model:calculatorModel=calculatorModel(valueDigit: 3)

    
    @IBAction func digitTouched(sender: UIButton) {

  
        let digit = sender.currentTitle!
        
        if (isUserTyping==true){
        let dotAuthenticate=lblDisplay.text!
            
            lblDisplay.text = (digit == "." && dotAuthenticate.rangeOfString(".") != nil) ? dotAuthenticate : dotAuthenticate + digit
        
         } else {
    
            lblDisplay.text = (digit == ".") ? "0." : digit
         }
    
          isUserTyping=true
    }
    
   
    
    
    @IBAction func performedOperation(sender: AnyObject) {
    
    
    if isUserTyping {
        model.getOperands(displayValue)
    
       isUserTyping=false
     }
    
        if let matsymbol=sender.currentTitle! {
            model.performOperation(matsymbol)
        }
        
        displayValue=model.result
  
        if (sender.currentTitle!! == "="){
            lblHistory.text=model.sHistory + sender.currentTitle!!
        } else{
            lblHistory.text=model.sHistory
        }
      
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }


}

