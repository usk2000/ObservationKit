//
//  Observable.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/14.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

public protocol ValueObservable {
    
    associatedtype Value
    
    func runWithLatestValue (_ execution: (Value) -> Void)
    
    func map <NewValue> (_ transform: @escaping (Value) -> NewValue) -> AnyVariableObservable<NewValue>

    func beObserved <Observer: AnyObject> (by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void)
    func beObserved <Observer: AnyObject> (by observer: Observer, _ queue: ExecutionQueue, onChanged handler: @escaping (Observer, Value) -> Void)
    
}
