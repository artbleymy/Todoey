//
//  Category.swift
//  Todoey
//
//  Created by Stanislav on 24.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
