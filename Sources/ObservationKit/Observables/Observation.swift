//
//  Observation.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/14.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

struct Observation<Value> {
    
    private(set) weak var observer: AnyObject?
    private let queue: ExecutionQueue
    private var action: (Value) -> Void
    
    private let hashObject: NSObject = .init()
    
    init <Observer: AnyObject> (observer: Observer, queue: ExecutionQueue, observingAction: @escaping (Observer, Value) -> Void) {
        
        let action: (Value) -> Void = { [weak observer] value in
            if let observer = observer {
                observingAction(observer, value)
            }
        }
        
        self.observer = observer
        self.queue = queue
        self.action = action
        
    }
    
}

extension Observation {
    
    var observerDeinited: Bool {
        return observer == nil
    }
    
    func run(with value: Value) {
        
        func execute() { action(value) }
        
        switch queue {
        case .directory:
            execute()
        case .asyncOnQueue(let queue):
            queue.async { execute() }
        }
        
    }
    
}

extension Observation: Equatable {
    
    static func == (lhs: Observation<Value>, rhs: Observation<Value>) -> Bool {
        return lhs.hashObject === rhs.hashObject
    }
    
}

extension Observation: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashObject)
    }
    
}
