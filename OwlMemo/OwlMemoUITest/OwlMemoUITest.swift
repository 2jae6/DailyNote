//
//  OwlMemoUITest.swift
//  OwlMemoUITest
//
//  Created by 1 on 27/07/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import XCTest

class OwlMemoUITest: XCTestCase {

    override func setUp() {
        super.setUp()
        
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    func testSnapshot(){
        let app = XCUIApplication()
        snapshot("0Launch")
        
        app.navigationBars["Today`s History"].buttons["Compose"].tap()
        
        snapshot("2Launch")
        app.navigationBars["OwlMemo.SecondView"].buttons["Back"].tap()
        

    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
