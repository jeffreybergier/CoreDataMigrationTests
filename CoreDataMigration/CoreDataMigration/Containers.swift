//
//  Containers.swift
//  CoreDataMigration
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import CoreData
import CloudKit

public class PlainContainer: NSPersistentContainer {
    public static var storeURL: URL!
    public override class func defaultDirectoryURL() -> URL {
        return self.storeURL
    }
}

public class CloudContainer: NSPersistentCloudKitContainer {
    public static var storeURL: URL!
    public override class func defaultDirectoryURL() -> URL {
        return self.storeURL
    }
}
