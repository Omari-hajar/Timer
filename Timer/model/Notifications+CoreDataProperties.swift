//
//  Notifications+CoreDataProperties.swift
//  Timer
//
//  Created by Hajar Alomari on 21/12/2021.
//
//

import Foundation
import CoreData


extension Notifications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notifications> {
        return NSFetchRequest<Notifications>(entityName: "Notifications")
    }

    @NSManaged public var time: Date?
    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var body: String?

}

extension Notifications : Identifiable {

}
