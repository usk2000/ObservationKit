//
//  AppUsecase.swift
//  ObservationKit_Example
//
//  Created by Yusuke Hasegawa on 2019/04/15.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ObservationKit

class AppUsecase {
    
    static let shared = AppUsecase()
    private init() { setup() }
    
    let counter: Variable = .init(0)
    private let interactor: Relay<Void> = .init()
    
    func countUp() {
        interactor.onNext(())
    }
    
}

private extension AppUsecase {
    
    func setup() {
        
        interactor.asAnyObservable().beObserved(by: self, .asyncOnGlobal(qos: .userInitiated)) { [unowned self] _, _ in
            self.counter.accept { $0 + 1 }
        }
        
    }
    
}
