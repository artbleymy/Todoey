//
//  item.swift
//  Todoey
//
//  Created by Stanislav on 24.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreate: Date = Date()
    @objc dynamic var colour: String = ""
//    для связи между объектами делаем таким способом
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
