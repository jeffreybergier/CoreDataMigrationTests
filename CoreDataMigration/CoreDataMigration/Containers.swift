//
//  Containers.swift
//  CoreDataMigration
//
//  Created by Jeffrey Bergier on 2021/05/06.
//

import CoreData
import CloudKit

public protocol Storable {
    static var storeURL: URL! { get set }
}

public class PlainContainer: NSPersistentContainer, Storable {
    public static var storeURL: URL!
    public override class func defaultDirectoryURL() -> URL {
        return self.storeURL
    }
}

public class CloudContainer: NSPersistentCloudKitContainer, Storable {
    public static var storeURL: URL!
    public override class func defaultDirectoryURL() -> URL {
        return self.storeURL
    }
}
