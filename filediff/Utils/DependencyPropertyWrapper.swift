//
//  DependencyPropertyWrapper.swift
//  PR Diff Tool
//
//  Created by Michael Ferro, Jr.
//  Copyright © 2024 Michael Ferro. All rights reserved.
//

import Foundation

@propertyWrapper
struct Service<Service> {

    var service: Service

    init(_ type: ServiceType = .automatic) {
        guard let service = ServiceContainer.resolve(type, Service.self) else {
            let serviceName = String(describing: Service.self)
            fatalError("No service of type \(serviceName) registered!")
        }
        self.service = service
    }

    var wrappedValue: Service {
        get { self.service }
        mutating set { service = newValue }
    }
}
