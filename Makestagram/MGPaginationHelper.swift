//
//  MGPaginationHelper.swift
//  Makestagram
//
//  Created by Cameron Long on 8/10/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation

protocol MGKeyed {
    var key: String? { get set }
}

class MGPaginationHelper<T: MGKeyed> {
    enum MGPaginationState {
        case initial //no data has been loaded yet
        case ready //ready and waiting for next request to paginate and load next page
        case loading //currently paginating and waiting for data from firebase
        case end //all data has been paginated
    }
    
    // MARK: - Properties
    
    let pageSize: UInt
    let serviceMethod: (UInt, String?, @escaping (([T]) -> Void)) -> Void
    var state: MGPaginationState = .initial
    var lastObjectKey: String?
    
    // MARK: - Init
    
    init(pageSize: UInt = 3, serviceMethod: @escaping (UInt, String?, @escaping (([T]) -> Void)) -> Void) {
        self.pageSize = pageSize
        self.serviceMethod = serviceMethod
    }
    
    func paginate(completion: @escaping ([T]) -> Void) {
        // determine which state
        switch state {
        // lastObjectKey to nil and fallthrough keyword causes .ready to be executed
        case .initial:
            lastObjectKey = nil
            fallthrough
            
        // change state to loading
        case .ready:
            state = .loading
            serviceMethod(pageSize, lastObjectKey) { [unowned self] (objects: [T]) in
                // executes whenever closure finishes
                defer {
                    // if last returned object has a key, it is set as lastObjectKey
                    if let lastObjectKey = objects.last?.key {
                        self.lastObjectKey = lastObjectKey
                    }
                    
                    // state becomes 
                    self.state = objects.count < Int(self.pageSize) ? .end : .ready
                }
                
                // 8
                guard let _ = self.lastObjectKey else {
                    return completion(objects)
                }
                
                // 9
                let newObjects = Array(objects.dropFirst())
                completion(newObjects)
            }
            
        // 10
        case .loading, .end:
            return
        }
    }
    
    func reloadData(completion: @escaping ([T]) -> Void) {
        state = .initial
        
        paginate(completion: completion)
    }
}
