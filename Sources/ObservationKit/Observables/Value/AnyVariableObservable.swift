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
private class AnyVariableObservableBox<Value> {
    
    func runWithLatestValue(_ execution: (Value) -> Void) {
        fatalError()
    }
    
    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> AnyVariableObservable<NewValue> {
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

private class VariableObservableBox<V: ValueObservable>: AnyVariableObservableBox<V.Value> {
    
    private let base: V
    
    init(_ base: V) {
        self.base = base
    }
    
    override func runWithLatestValue(_ execution: (V.Value) -> Void) {
        return base.runWithLatestValue(execution)
    }
    
    override func map<NewValue>(_ transform: @escaping (V.Value) -> NewValue) -> AnyVariableObservable<NewValue> {
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

//compatibility for previous version
typealias AnyValueObservable = AnyVariableObservable

public struct AnyVariableObservable<Value> {
    
    private let box: AnyVariableObservableBox<Value>
    
    init <V: ValueObservable> (_ base: V) where V.Value == Value {
        box = VariableObservableBox<V>(base)
    }
    
}

extension AnyVariableObservable: ValueObservable {
    
    public func runWithLatestValue(_ execution: (Value) -> Void) {
        return box.runWithLatestValue(execution)
    }
    
    public func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> AnyVariableObservable<NewValue> {
        return box.map(transform)
    }
    
    public func beObserved<Observer>(by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, onChanged: handler)
    }
    
    public func beObserved<Observer>(by observer: Observer, _ queue: ExecutionQueue, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, queue, onChanged: handler)
    }
    
}
