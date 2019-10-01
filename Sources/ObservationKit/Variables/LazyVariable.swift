//
//  LazyVariable.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/08/24.
//

import Foundation

public enum LazyVariable<Value> {
    case uninitialized
    case initialized(Value)
}

public extension LazyVariable {
    
    var value: Value? {
        
        switch self {
        case .uninitialized:
            return nil
            
        case .initialized(let value):
            return value
        }
        
    }
    
}
