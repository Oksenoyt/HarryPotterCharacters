//
//  StorageManagerTests.swift
//  HarryPotterСharactersTests
//
//  Created by Oksenoyt on 13.10.2023.
//

import XCTest
@testable import HarryPotterСharacters

final class StorageManagerTests: XCTestCase {
    private var sut: StorageManager!
    private var userDefaults: UserDefaults!

    private enum TestsData: String {
        case one = "spellFirst"
        case two = "spellSecond"
    }

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        sut = StorageManager(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removeSuite(named: #file)
        userDefaults = nil
        sut = nil
        super.tearDown()
    }

    func testSaveShouldBeSaveDataInTheArray() {
        sut.save(spell: TestsData.one.rawValue)
        let spells = sut.favoritesSpells
        XCTAssertEqual(spells.count, 1)
    }

    func testSaveShouldBeSaveCorrectInTheArray() {
        sut.save(spell: TestsData.one.rawValue)
        let data = sut.favoritesSpells
        XCTAssert(data == [TestsData.one.rawValue], "Data is saved incorrectly in the array")
    }

    func testSaveShouldBeSaveInTheUserDefaults() {
        sut.save(spell: TestsData.one.rawValue)
        sut.save(spell: TestsData.two.rawValue)
        let data = userDefaults.object(forKey: "favoritesSpells") as? [String]
        XCTAssert(data == [TestsData.one.rawValue, TestsData.two.rawValue], "Data is saved incorrectly in the UserDefaults")
    }

    func testFetchShouldBeGetDataFromTheUserDefaults() {
        sut.save(spell: TestsData.one.rawValue)
        let data = sut.fetch()
        XCTAssert(data == [TestsData.one.rawValue], "Data not received from the UserDefaults")
    }

    func testFetchDataShouldBeSavedInTheArray() {
        sut.save(spell: TestsData.one.rawValue)
        sut.fetch()
        XCTAssertEqual(sut.favoritesSpells.count, 1)
    }

    func testRemoveDataShouldBeDeleteFromTheUserDefaults() {
        sut.save(spell: TestsData.one.rawValue)
        sut.remove(spell: TestsData.one.rawValue)
        let data = userDefaults.object(forKey: "favoritesSpells") as? [String]
        XCTAssert(data == [], "Data not remove from the UserDefaults")
    }
}
