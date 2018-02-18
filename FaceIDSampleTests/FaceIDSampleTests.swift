//
//  FaceIDSampleTests.swift
//  FaceIDSampleTests
//
//  Created by 都筑一希 on 2018/02/18.
//  Copyright © 2018年 kazuki229. All rights reserved.
//

import XCTest
import LocalAuthentication

@testable import FaceIDSample

class FaceIDSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetBiometryTypeText() {
        if #available(iOS 11.2, *) {
            testGetBiometryTypeText(expected: "None", biometryType: .none)
        } else {
            testGetBiometryTypeText(expected: "None", biometryType: .LABiometryNone)
        }
        testGetBiometryTypeText(expected: "Face ID", biometryType: .faceID)
        testGetBiometryTypeText(expected: "Touch ID", biometryType: .touchID)
    }
    
    func testGetLAErrorText() {
        testGetLAErrorText(expected: "authenticationFailed", code: .authenticationFailed)
        testGetLAErrorText(expected: "appCancel",            code: .appCancel)
        testGetLAErrorText(expected: "invalidContext",       code: .invalidContext)
        testGetLAErrorText(expected: "notInteractive",       code: .notInteractive)
        testGetLAErrorText(expected: "passcodeNotSet",       code: .passcodeNotSet)
        testGetLAErrorText(expected: "systemCancel",         code: .systemCancel)
        testGetLAErrorText(expected: "userCancel",           code: .userCancel)
        testGetLAErrorText(expected: "userFallback",         code: .userFallback)
        if #available(iOS 11.0.0, *) {
            testGetLAErrorText(expected: "biometryLockout",      code: .biometryLockout)
            testGetLAErrorText(expected: "biometryNotEnrolled",  code: .biometryNotEnrolled)
            testGetLAErrorText(expected: "biometryNotAvailable", code: .biometryNotAvailable)
        } else {
            testGetLAErrorText(expected: "touchIDLockout",      code: .touchIDLockout)
            testGetLAErrorText(expected: "touchIDNotEnrolled",  code: .touchIDNotEnrolled)
            testGetLAErrorText(expected: "touchIDNotAvailable", code: .touchIDNotAvailable)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetBiometryTypeText(expected: String, biometryType: LABiometryType) {
        let vc = ViewController()
        XCTAssertEqual(expected, vc.getBiometryTypeText(biometryType: biometryType))
    }
    
    func testGetLAErrorText(expected: String, code: LAError.Code) {
        let vc = ViewController()
        XCTAssertEqual(expected, vc.getLAErrorText(code: code))
    }
}
