//
//  AnyObservable.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/14.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

// Type-Erasure for Observable
// Reference: https://qiita.com/omochimetaru/items/5d26b95eb21e022106f0#type-erasure-継承-box-方式
private class AnyValueObservableBox<Value> {
    
    func runWithLatestValue(_ execution: (Value) -> Void) {
        fatalError()
    }
    
    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> AnyValueObservable<NewValue> {
        fatalError()
    }
    
    func beObserved<Observer>(by observer: Observer,
                              onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        fatalError()
    }
    
    func beObserved<Observer>(by observer: Observer,
                              _ queue: ExecutionQueue,
                              onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        fatalError()
    }
    
}

private class ValueObservableBox<V: ValueObservable>: AnyValueObservableBox<V.Value> {
    
    private let base: V
    
    init(_ base: V) {
        self.base = base
    }
    
    override func runWithLatestValue(_ execution: (V.Value) -> Void) {
        return base.runWithLatestValue(execution)
    }
    
    override func map<NewValue>(_ transform: @escaping (V.Value) -> NewValue) -> AnyValueObservable<NewValue> {
        return base.map(transform)
    }
    
    override func beObserved<Observer>(by observer: Observer,
                                       onChanged handler: @escaping (Observer, V.Value) -> Void) where Observer : AnyObject {
        return base.beObserved(by: observer, onChanged: handler)
    }
    
    override func beObserved<Observer>(by observer: Observer,
                                       _ queue: ExecutionQueue,
                                       onChanged handler: @escaping (Observer, V.Value) -> Void) where Observer : AnyObject {
        return base.beObserved(by: observer, queue, onChanged: handler)
    }
    
}

public struct AnyValueObservable<Value> {
    
    private let box: AnyValueObservableBox<Value>
    
    init <V: ValueObservable> (_ base: V) where V.Value == Value {
        box = ValueObservableBox<V>(base)
    }
    
}

extension AnyValueObservable: ValueObservable {
    
    public func runWithLatestValue(_ execution: (Value) -> Void) {
        return box.runWithLatestValue(execution)
    }
    
    public func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> AnyValueObservable<NewValue> {
        return box.map(transform)
    }
    
    public func beObserved<Observer>(by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, onChanged: handler)
    }
    
    public func beObserved<Observer>(by observer: Observer, _ queue: ExecutionQueue, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, queue, onChanged: handler)
    }
    
}
