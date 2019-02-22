//
//  ToDoListItemModel.swift
//  Todoey
//
//  Created by Stanislav on 22.02.2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

class Item: /*Encodable, Decodable*/Codable {
    var title: String = ""
    var done: Bool = false
//    init() {
//        title = ""
//        done = false
//    }
}
