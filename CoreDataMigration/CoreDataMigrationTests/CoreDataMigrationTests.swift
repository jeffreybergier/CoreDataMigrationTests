//
//  CoreDataMigrationTests.swift
//  CoreDataMigrationTests
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import XCTest
import CoreData
import CoreDataMigration

let Example_v1_0_0: URL = Bundle(for: PlainCoreDataMigrationTests.self)
                                .url(forResource: "Example_v1.0.0", withExtension: ".sqlite")!

class PlainCoreDataMigrationTests: XCTestCase {
    
    let randomStoreURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                            .appendingPathComponent(UUID().uuidString, isDirectory: true)
    var containerType: NSPersistentContainer.Type! { PlainContainer.self }
    var exampleStoreDestination: URL { self.randomStoreURL.appendingPathComponent("Migration.sqlite") }
    
    override func setUpWithError() throws {
        PlainContainer.storeURL = self.randomStoreURL
        try FileManager.default.createDirectory(at: self.randomStoreURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }

    override func tearDownWithError() throws {
        PlainContainer.storeURL = nil
        try FileManager.default.removeItem(at: self.randomStoreURL)
    }

    func testMigraion_v1_0_0() throws {
        try FileManager.default.moveItem(at: Example_v1_0_0, to: self.exampleStoreDestination)
        let stack = try Stack(self.containerType)
        let results = try stack.fetchAll()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].value(forKey: "v1_0_0_name") as? String, "A Known Value")
    }

}

//class CloudCoreDataMigrationTests: PlainCoreDataMigrationTests {
//    override var containerType: NSPersistentContainer.Type { CloudContainer.self }
//    override func setUpWithError() throws {
//        CloudContainer.storeURL = self.randomStoreURL
//    }
//    override func tearDownWithError() throws {
//        CloudContainer.storeURL = nil
//        try FileManager.default.removeItem(at: self.randomStoreURL)
//    }
//}
