/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import AEPServices
import Foundation

typealias NetworkResponse = (data: Data?, response: HTTPURLResponse?, error: Error?)
typealias RequestResolver = (NetworkRequest) -> NetworkResponse?

class TestableNetworkService: Networking {
    var requests: [NetworkRequest] = []
    var resolvers: [RequestResolver] = []

    init() {}

    func connectAsync(networkRequest: NetworkRequest, completionHandler: ((HttpConnection) -> Void)?) {
        requests.append(networkRequest)
        for resolver in resolvers {
            if let response = resolver(networkRequest) {
                let httpConnection = HttpConnection(data: response.data, response: response.response, error: response.error)
                completionHandler?(httpConnection)
                return
            }
        }

        completionHandler?(HttpConnection(data: nil, response: nil, error: nil))
    }

    func mock(resolver: @escaping RequestResolver) {
        resolvers += [resolver]
    }
}
