//
//  MockURLSession.swift
//  HarryPotterСharactersTests
//
//  Created by Oksenoyt on 16.10.2023.
//

import Foundation
@testable import HarryPotterСharacters

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockTask {
            completionHandler(self.data, nil, self.error)
        }
    }

    class MockTask: URLSessionDataTask {
        private let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        override func resume() {
            closure()
        }
    }
}
