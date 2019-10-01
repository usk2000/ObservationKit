//
//  ExecutionQueue.swift
//  ObservationKit
//
//  Created by Yusuke Hasegawa on 2019/04/14.
//  Copyright © 2019 Yusuke Hasegawa. All rights reserved.
//

import Foundation

public enum ExecutionQueue {
    case directory
    case asyncOnQueue(DispatchQueue)
}

extension ExecutionQueue {
    
    public static var asyncOnMain: ExecutionQueue {
        return .asyncOnQueue(.main)
    }
    
    public static func asyncOnGlobal(qos: DispatchQoS.QoSClass = .default) -> ExecutionQueue {
        return .asyncOnQueue(.global(qos: qos))
    }
    
}
