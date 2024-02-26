//
//  Storage .swift
//  TinkoffCalculator
//
//  Created by Анна Белова on 25.02.2024.
//

import Foundation

struct Calculation {
    let expression: [CalculationHistoryItem]
    let result: Double
    let date: Date
}


extension Calculation: Codable {
   
//    enum CodingKeys: String, CodingKey {
//        case expression
//        case result
//        case date
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(expression, forKey: .expression)
//        try container.encode(result, forKey: .result)
//        try container.encode(date, forKey: .date)
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container =  try decoder.container(keyedBy: CodingKeys.self)
//        expression = try container.decode([CalculationHistoryItem].self, forKey: .expression)
//        result = try container.decode(Double.self, forKey: .result)
//        date = try container.decode(Date.self, forKey: .date)
//    }
}

extension CalculationHistoryItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case number
        case operation
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .number(let value):
            try container.encode(value, forKey: CodingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    
    enum CalculationHistoryError: Error {
        case itemNotFound
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
            return
        }
        
        if let rawOperation = try container.decodeIfPresent(String.self, forKey: .operation),
           let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
        throw CalculationHistoryError.itemNotFound
    }
  
}

class CalculationHistoryStorage {
    
    static let CalculationHistoryKey = "CalculationHistoryKey"
    
    func  setHistory (calculation: [Calculation]) {
        if let encoded = try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoded, forKey: CalculationHistoryStorage.CalculationHistoryKey)
        }
    }
    
    //получение истории вычислений
    func loadHistory() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.CalculationHistoryKey) {
            return (try? JSONDecoder().decode([Calculation].self, from: data))  ?? []
        }
        
        return []
    }
}
