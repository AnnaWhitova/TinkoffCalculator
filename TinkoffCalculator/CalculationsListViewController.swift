//
//  CalculationsListViewController.swift
//  TinkoffCalculator
//
//  Created by Анна Белова on 14.02.2024.
//

import UIKit

class CalculationsListViewController: UIViewController {
  
    
    
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
}
