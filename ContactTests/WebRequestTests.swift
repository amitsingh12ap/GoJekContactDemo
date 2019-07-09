//
//  WebRequestTests.swift
//  ContactTests
//
//  Created by Amit Singh on 08/07/19.
//  Copyright © 2019 Amit Singh. All rights reserved.
//

import XCTest
@testable import Contact
class WebRequestTests: XCTestCase {
    let webRequest = WebRequest()
    let contact = ConactInfo.init(contactId: 6936, firstName: "1234567890123456789012345678901234567890a", lastName: "12345678901234567890123456789012345678901234567890b", email: "ab@bachchan.com", phoneNumber: "+919980123412", profileImageUrl: "/images/missing.png", isFavorite: false, createdAt: "2019-07-06T05:59:17.008Z", updatedAt: "2019-07-09T05:59:16.069Z")
    
    let unitTestContact = ConactInfo.init(contactId: nil, firstName: "UnitTestAmitSingh", lastName: "UnitTestAmitSingh", email: "ab@bachchan.com", phoneNumber: "+919910298571", profileImageUrl: "/images/missing.png", isFavorite: false, createdAt: nil, updatedAt: nil)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchAllContactApi(){
        webRequest.fetchAllContactFromServer {(result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let err):
                XCTAssertNil(err)
            }
        }
    }
    
    func testFetchContactWithContactId(){
        let ContactId = 6936
        webRequest.fetchContactDetailFromServer(contactId: ContactId) {(result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let err):
                 XCTAssertNil(err)
            }
        }
    }

    func testFetchContactWithContactIdFailure(){
        let ContactId = 6
        webRequest.fetchContactDetailFromServer(contactId: ContactId) { (result) in
            switch result {
            case .success(let response):
                    XCTAssertNil(response)
            case .failure(let err):
                XCTAssertNotNil(err)
            }
            }
       
    }
    
    func testMarkFav(){
        
        webRequest.updateContactInfoToServer(body: contact) { (result) in
            switch result {
                case .success(let response):
                    XCTAssertNotNil(response)
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
    }

    func testCreateContact(){
        webRequest.createContactToServer(body: unitTestContact) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let err):
                XCTAssertNil(err)
            }
        }
    }
    
    func testDeleteContact() {
        var data = Data()
        var error: Int = 0
        webRequest.deleteContactFromServer(contactId: 6936) { (result) in
            switch result {
            case .success(let response):
                data = response
            case .failure(let err):
                error = err
            }
            XCTAssertNotNil(data)
            XCTAssert(error != 0)
        }
    }
    
    func testUpdateContact(){
        webRequest.updateContactInfoToServer(body: unitTestContact) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let err):
                XCTAssertNil(err)
            }
        }
    }
}
