//
//  RelayObservable.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/15.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

public protocol RelayObservable {
    
    associatedtype Value
        
    func beObserved <Observer: AnyObject> (by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void)
    func beObserved <Observer: AnyObject> (by observer: Observer, _ queue: ExecutionQueue, onChanged handler: @escaping (Observer, Value) -> Void)
    
}
