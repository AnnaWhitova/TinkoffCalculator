//
//  CalculationListViewCotroller.swift
//  TinkoffCalculator
//
//  Created by Анна Белова on 14.02.2024.
//

import UIKit

class CalculationListViewCotroller: UIViewController {
    
   // var result: String?
    var calculations: [(expression: [CalculationHistoryItem], result: Double)] = []
    
  

    @IBOutlet weak var calculationLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize () {
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.systemGray
        let tableHeaderView = UIView()
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30)
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView =  UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
     
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @IBAction func dismissVC(_ sender: Any) {
        //dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    private func expressionToString(_ expression: [CalculationHistoryItem]) -> String {
        var result = ""
        
        for operand in expression {
            switch operand {
            case let .number(value):
                result += String(value) + ""
            case let .operation(value):
                result += value.rawValue + ""
                
            }
        }
        return result
    }
    
}

extension CalculationListViewCotroller: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            
            return calculations.count
      
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = .white
        
        let label = UILabel()
        label.tintColor = .black
        label.frame = CGRect(x: 5, y: 25, width: tableView.bounds.width, height: 15)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
     
        let date = NSDate()
        
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        
        let currentDate = dateFormatter.string(from: date as Date)
        
        label.text = currentDate
        
        header.addSubview(label)
            
            return header
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//      
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.YYYY"
//        
//        let label = UILabel()
//        label.tintColor = .black
//        
//        let date = NSDate()
//        
//        dateFormatter.locale = Locale(identifier: "ru_Ru")
//        
//        let currentDate = dateFormatter.string(from: date as Date)
//        
//        label.text = currentDate
//        
//        return label.text
//    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let historyItem = calculations[indexPath.row]
        cell.configure(with: expressionToString(historyItem.expression), result: String(historyItem.result))
        return cell
    }
    
    
}
