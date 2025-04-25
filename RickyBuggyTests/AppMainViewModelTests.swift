//
//  AppMainViewModelTests.swift
//  RickyBuggy
//
//  Created by Venkatachalam Perumal on 23/01/25.
//

import Combine
import XCTest

@testable import RickyBuggy

final class AppMainViewModelTests: XCTestCase {
    private var sut: AppMainViewModel!

    override func setUp() {
        super.setUp()
        sut = AppMainViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_againstMemoryLeak() {
        weak var weakSut = sut
        sut = nil
        XCTAssertNil(weakSut)
    }
}
