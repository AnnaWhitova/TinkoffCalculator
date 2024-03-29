//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Анна Белова on 04.02.2024.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String  {
    case add = "+"
    case substract  =  "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1:Double, _ number2:Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    var calculationHistory: [CalculationHistoryItem] = []
    var calculations: [Calculation] = []
    
    let calculationHistoryStorage = CalculationHistoryStorage()
    

    @IBOutlet  var label: UILabel!
    
    @IBOutlet  var historyButton: UIButton!
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resetLabelText()
        historyButton.accessibilityIdentifier = "historyButton"
        calculations = calculationHistoryStorage.loadHistory()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {return}
        
        if buttonText == "," && label.text?.contains(",") ==  true {
            return
        }
        
        
        if label.text == "0" {
            label.text = buttonText
        } else  {
            label.text?.append(buttonText)
        }
        
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        
        else {return}
     
        
        guard let labelText  = label.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabelText()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
     
        calculationHistory.removeAll()
        
        resetLabelText()
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
     
        guard let labelText  = label.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let nsDate = NSDate()
        
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        
        let dateString = dateFormatter.string(from: nsDate as Date)
        
      guard  let date = dateFormatter.date(from: dateString)
        else {return}
        
        do {
            let result = try calculate()
            
            label.text = numberFormatter.string(from: NSNumber(value: result))
            let newCalculation = Calculation(expression: calculationHistory, result: result, date: date)
            calculations.append(newCalculation)
            calculationHistoryStorage.setHistory(calculation: calculations)
        } catch {
            label.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
    }
    
//    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
//        
//     
//        
//    }
// 
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "Calculations_List",
//              let calculationListVC = segue.destination as? CalculationListViewCotroller else {return}
//        calculationListVC.result = label.text
//    }
    

    
    
    @IBAction func showCalculationsList(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let calculationListVC = sb.instantiateViewController(withIdentifier: "CalculationListViewCotroller")
        
        if let vc = calculationListVC as? CalculationListViewCotroller{
            vc.calculations = calculations
        }
        
        navigationController?.pushViewController(calculationListVC, animated: true)
        
//        show(calculationListVC, sender: self)
    }
    
    
 
    
    func calculate () throws -> Double {
        guard case .number(let fisrtNumber) = calculationHistory[0] else {return 0}
        
        var currentResult = fisrtNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard case .operation(let operation) = calculationHistory[index],
                  case .number(let number) = calculationHistory[index+1]
            
            else {break}
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }

    func resetLabelText(){
        label.text = "0"
    }
    
    

}

