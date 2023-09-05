//
//  CustomPostRouteTests.swift
//  
//
//  Created by Meng, Joel on 4/9/2023.
//

import XCTest
import Shock

final class CustomPostRouteTests: ShockTestCase {

    func testCustomRoute() {
        let route: MockHTTPRoute = .customPost(method: .post, urlPath:"/custom", matching: { data in
            return true
        }, code: 200, filename: "testCustomRoute.txt")
            
        server.setup(route: route)
        
        let expectation = self.expectation(description: "Expect 200 response with response body")
        
        HTTPClient.post(url: "\(server.hostURL)/custom", body: Data()) { code, body, headers, error in
            XCTAssertEqual(code, 200)
            XCTAssertEqual(body, "testCustomRoute test fixture\n")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: timeout, handler: nil)
    }

    func test2SimilarCustomRoute() {
        
        let jsonEncoder = JSONEncoder()
        let encodedParams = try! jsonEncoder.encode(PostParam(field1: "x", field2: 299))
        
        let route1: MockHTTPRoute = .customPost(method: .post, urlPath:"/custom", matching: { data in
            let decoded = try! JSONDecoder().decode(PostParam.self, from: data)
            return decoded.field1 == "x" && decoded.field2 == 299
        }, code: 200, filename: "testCustomRoute.txt")
        
        let route2: MockHTTPRoute = .customPost(method: .post, urlPath:"/custom", matching: { data in
            let decoded = try! JSONDecoder().decode(PostParam.self, from: data)
            return decoded.field1 == "x" && decoded.field2 == 000
        }, code: 200, filename: "testCustomRoute2.txt")

        server.setup(route: route2)
        server.setup(route: route1)
        
        
        let expectation = self.expectation(description: "Expect 200 response with response body")
        
        HTTPClient.post(url: "\(server.hostURL)/custom", body: encodedParams) { code, body, headers, error in
            XCTAssertEqual(code, 200)
            XCTAssertEqual(body, "testCustomRoute test fixture\n")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: timeout, handler: nil)
    }

    
}


struct PostParam: Codable {
    let field1: String
    let field2: Int
}
