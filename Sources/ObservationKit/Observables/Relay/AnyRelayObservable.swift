//
//  AnyRelayObservable.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/15.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

// Type-Erasure for Observable
// Reference: https://qiita.com/omochimetaru/items/5d26b95eb21e022106f0#type-erasure-継承-box-方式
private class AnyRelayObservableBox<Value> {
    
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

private final class RelayObservableBox<V: RelayObservable>: AnyRelayObservableBox<V.Value> {
    
    private let base: V
    
    init(_ base: V) {
        self.base = base
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

public struct AnyRelayObservable<Value> {
    
    private let box: AnyRelayObservableBox<Value>
    
    init <V: RelayObservable> (_ base: V) where V.Value == Value {
        box = RelayObservableBox<V>(base)
    }
    
}

extension AnyRelayObservable: RelayObservable {
    
    public func beObserved<Observer>(by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, onChanged: handler)
    }
    
    public func beObserved<Observer>(by observer: Observer, _ queue: ExecutionQueue, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, queue, onChanged: handler)
    }
    
}
