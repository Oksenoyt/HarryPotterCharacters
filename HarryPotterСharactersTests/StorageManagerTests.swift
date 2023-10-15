//
//  StorageManagerTests.swift
//  HarryPotterСharactersTests
//
//  Created by Oksenoyt on 13.10.2023.
//

import XCTest
@testable import HarryPotterСharacters

final private class StorageManagerTests: XCTestCase {
    var sut: StorageManager!
    var userDefaults: UserDefaults!
    let testKey = "favoritesSpells"

    enum TestsData: String {
        case one = "spellFirst"
        case two = "spellSecond"
    }
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        sut = StorageManager(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removeObject(forKey: testKey)
        userDefaults.removeSuite(named: #file)
        userDefaults = nil
        sut = nil
        super.tearDown()
    }

    func testSaveDataInTheArray() {
        sut.save(spell: TestsData.one.rawValue)
        let spells = sut.favoritesSpells
        XCTAssertEqual(spells.count, 1)
    }

    func testSaveCorrectValueInTheArray() {
        sut.save(spell: TestsData.one.rawValue)
        let data = sut.favoritesSpells
        XCTAssert(data == [TestsData.one.rawValue], "Data is saved incorrectly in the array")
    }

    func testSaveDataInTheUserDefaults() {
        sut.save(spell: TestsData.one.rawValue)
        sut.save(spell: TestsData.two.rawValue)
        let data = userDefaults.object(forKey: testKey) as? [String]
        XCTAssert(data == [TestsData.one.rawValue, TestsData.two.rawValue], "Data is saved incorrectly in the UserDefaults")
    }

    func testFetchDataFromTheUserDefaults() {
        sut.save(spell: TestsData.one.rawValue)
        let data = sut.fetch()
        XCTAssert(data == [TestsData.one.rawValue], "Data not received from the UserDefaults")
    }

    func testFetchDataShouldBeSavedInTheArray() {
        userDefaults.set([TestsData.one.rawValue], forKey: testKey)
        let data = sut.fetch()
        XCTAssert(data == [TestsData.one.rawValue])
    }

    func testFetchEmptyData() {
        let data = sut.fetch()
        XCTAssertEqual(sut.favoritesSpells.count, 0)
        XCTAssert(data == [])
    }

    func testRemoveDataFromTheUserDefaults() {
        userDefaults.set([TestsData.one.rawValue], forKey: testKey)
        sut.remove(spell: TestsData.one.rawValue)
        let data = userDefaults.object(forKey: testKey) as? [String]
        XCTAssert(data == [], "Data not remove from the UserDefaults")
    }
}
