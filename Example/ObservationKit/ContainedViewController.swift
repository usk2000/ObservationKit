//
//  ContainedViewController.swift
//  ObservationKit_Example
//
//  Created by Yusuke Hasegawa on 2019/04/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ContainedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func countUp() {
        AppUsecase.shared.countUp()
    }

}
