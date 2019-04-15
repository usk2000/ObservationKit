//
//  Variable.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/14.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

public final class Variable<Value> {
    
    private var value: Value {
        didSet { runObservations() }
    }
    
    private var observations: Set<Observation<Value>> = []
    private var relatedVariables: [AnyObject] = []
    
    public init(_ value: Value) {
        self.value = value
    }
    
    public var currentValue: Value {
        return value
    }
    
    public func accept(_ newValue: Value) {
        value = newValue
    }
    
    public func accept(_ calculation: (Value) -> Value) {
        let newValue = calculation(currentValue)
        accept(newValue)
    }

    public func asAnyObservable() -> AnyValueObservable<Value> {
        return AnyValueObservable(self)
    }
    
}

private extension Variable {
    
    func runObservations() {
        
        let newValue = value
        
        for observation in observations {
            if observation.observerDeinited {
                observations.remove(observation)
                
            } else {
                observation.run(with: newValue)
            }
            
        }
        
    }
   
    func addObserver <Observer: AnyObject> (_ observer: Observer,
                                                    queue: ExecutionQueue,
                                                    handler: @escaping (Observer, Value) -> Void) {
        
        let observation = Observation(observer: observer, queue: queue, observingAction: handler)
        observations.insert(observation)
        
        let currentValue = value
        handler(observer, currentValue)
        
    }
    
}

extension Variable: ValueObservable {
    
    public func runWithLatestValue (_ execution: (Value) -> Void) {
        
        let value = currentValue
        execution(value)
        
    }
    
    public func map <NewValue> (_ transform: @escaping (Value) -> NewValue) -> AnyValueObservable<NewValue> {
        
        let transformedValue = transform(value)
        let transformedVariable = Variable<NewValue>(transformedValue)

        addObserver(transformedVariable, queue: .asyncOnMain, handler: { $0.accept(transform($1)) })
        relatedVariables.append(transformedVariable)
        
        let wrappedVariable = AnyValueObservable(transformedVariable)
        return wrappedVariable
        
    }
    
    public func beObserved <Observer: AnyObject> (by observer: Observer,
                                                  onChanged handler: @escaping (Observer, Value) -> Void) {
        
        addObserver(observer, queue: .asyncOnMain, handler: handler)
        
    }
    
    public func beObserved <Observer: AnyObject> (by observer: Observer,
                                                  _ queue: ExecutionQueue,
                                                  onChanged handler: @escaping (Observer, Value) -> Void) {
        
        addObserver(observer, queue: queue, handler: handler)
        
    }
    
}
