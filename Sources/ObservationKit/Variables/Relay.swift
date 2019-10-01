//
//  Relay.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/14.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

public final class Relay<Value> {
    
    private var observations: Set<Observation<Value>> = []
    
    public init() {
        
    }
    public func asAnyObservable() -> AnyRelayObservable<Value> {
        return AnyRelayObservable(self)
    }

    public func onNext(_ value: Value) {
        runObservations(value: value)
    }
    
}

private extension Relay {
    
    func runObservations(value: Value) {
        
        
        for observation in observations {
            if observation.observerDeinited {
                observations.remove(observation)
                
            } else {
                observation.run(with: value)
            }
            
        }
        
    }
    
    func addObserver <Observer: AnyObject> (_ observer: Observer,
                                            queue: ExecutionQueue,
                                            handler: @escaping (Observer, Value) -> Void) {
        
        let observation = Observation(observer: observer, queue: queue, observingAction: handler)
        observations.insert(observation)
    }
    
}

extension Relay: RelayObservable {
    
    public func beObserved<Observer>(by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        addObserver(observer, queue: .asyncOnMain, handler: handler)

    }
    
    public func beObserved<Observer>(by observer: Observer, _ queue: ExecutionQueue, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        addObserver(observer, queue: queue, handler: handler)
    }
    
}
