//
//  ViewController.swift
//  ObservationKit
//
//  Created by Yuusuke Hasegawa on 04/15/2019.
//  Copyright (c) 2019 Yuusuke Hasegawa. All rights reserved.
//

import UIKit
import ObservationKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AppUsecase.shared.counter.asAnyObservable().beObserved(by: self) { [weak self] _, value in
            self?.label.text = "Count : \(value)"
        }
        
    }
    
}

