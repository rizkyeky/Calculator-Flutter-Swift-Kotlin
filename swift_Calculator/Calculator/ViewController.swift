//
//  ViewController.swift
//  Tutorial
//
//  Created by Eky on 09/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    var mainDisplay: String = ""
    
    var mainNumbers: [Int?] = [nil]
    var mainOpers: [Character?] = [nil]
    
    var currIndex: Int = 0
    
    var tempNewDisplayNumber: String = ""
    var tempNewDisplayOper: String = ""
    
    @IBOutlet weak var mainLabelCal: UILabel!
    @IBOutlet weak var resultLabelCal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabelCal.text = ""
        mainLabelCal.text = "0"
    }
    
    @IBAction func calculate(_ sender: Any) {
        
        var result: Double = 0
        
        var tempMainNumbers = mainNumbers
        var tempMainOpers = mainOpers
        
        repeat {
            let num1 = tempMainNumbers.removeFirst()
            let oper = tempMainOpers.removeFirst()
            
            switch oper {
            case "+":
                if (!tempMainNumbers.isEmpty) {
                    let num2 = tempMainNumbers.removeFirst()
                    result += Double((num1 ?? 0) + (num2 ?? 0))
                } else {
                    result += Double(num1 ?? 0)
                }
            case "-":
                if (!tempMainNumbers.isEmpty) {
                    let num2 = tempMainNumbers.removeFirst()
                    if (result <= 0) {
                        result += Double((num1 ?? 0) - (num2 ?? 0))
                    } else {
                        result -= Double((num1 ?? 0) - (num2 ?? 0))
                    }
                } else {
                    result -= Double(num1 ?? 0)
                }
            case "x":
                if (result == 0) { result = 1 }
                if (!tempMainNumbers.isEmpty) {
                    let num2 = tempMainNumbers.removeFirst()
                    result *= Double((num1 ?? 1) * (num2 ?? 1))
                } else {
                    result *= Double(num1 ?? 1)
                }
            case "/":
                if (result == 0) { result = 1 }
                if (!tempMainNumbers.isEmpty) {
                    let num2 = tempMainNumbers.removeFirst()
                    if (mainNumbers.first == num1) {
                        result = Double((num1 ?? 1) / (num2 ?? 1))
                    } else {
                        result /= Double((num1 ?? 1) / (num2 ?? 1))
                    }
                } else {
                    result /= Double(num1 ?? 1)
                }
            default:
                result = Double(num1 ?? 0)
            }
            
            
        } while (!tempMainNumbers.isEmpty)
        
        resultLabelCal.text = result.formatted()
    }
    
    @IBAction func clearAllMainDisplay(_ sender: Any) {
        if (!mainDisplay.isEmpty) {
            
            mainDisplay.removeAll()
            
            mainNumbers.removeAll()
            mainOpers.removeAll()
            
            tempNewDisplayNumber.removeAll()
            tempNewDisplayOper.removeAll()
            
            mainNumbers.append(nil)
            mainOpers.append(nil)
            currIndex = 0
            
            resultLabelCal.text = ""
            mainLabelCal.text = mainDisplay.isEmpty ? "0" : mainDisplay
        }
    }

    @IBAction func delmainDisplay(_ sender: Any) {
        if (!mainDisplay.isEmpty) {
            
            let tempChar: Character = mainDisplay.removeLast()
            if (["+", "-", "x", "/"].contains(tempChar)) {
                mainOpers.removeLast()
            } else {
                
            }
            
            mainLabelCal.text = mainDisplay.isEmpty ? "0" : mainDisplay
        }
    }
    
    @IBAction func addOper(_ sender: UIButton) {
        let sym : String? = sender.titleLabel?.text
        
        tempNewDisplayNumber.removeAll()
        
        if (sym != nil) {
            
            tempNewDisplayOper = sym!
            
            if (!mainDisplay.isEmpty) {
                if (mainDisplay.last?.isNumber ?? false) {
                    mainDisplay.append(sym!)
                } else {
                    mainDisplay.removeLast()
                    mainDisplay.append(sym!)
                }
            }
        }
        
        if (mainNumbers[currIndex] != nil) {
            mainOpers[currIndex] = Character(tempNewDisplayOper)
            
            currIndex += 1
            mainNumbers.append(nil)
            mainOpers.append(nil)
        } else {
            let prevIndex = currIndex - 1
            if (prevIndex >= 0) {
                if (mainOpers[prevIndex] != nil) {
                    mainOpers[prevIndex] = Character(tempNewDisplayOper)
                } else {
                    mainOpers[currIndex] = Character(tempNewDisplayOper)
                }
            } else {
                mainOpers[currIndex] = Character(tempNewDisplayOper)
            }
        }
        
        print(currIndex)
        print(mainOpers)
        print(mainNumbers)
        
        mainLabelCal.text = mainDisplay
    }
    
    
    @IBAction func addNumber(_ sender: UIButton) {
        let num : String? = sender.titleLabel?.text
       
        tempNewDisplayOper.removeAll()
        tempNewDisplayNumber.append(num!)
        mainDisplay.append(num!)
        
        mainNumbers[currIndex] = Int(tempNewDisplayNumber)
        
        print(currIndex)
        print(mainOpers)
        print(mainNumbers)

        mainLabelCal.text = mainDisplay
    }
}

