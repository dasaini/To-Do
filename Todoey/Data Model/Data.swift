//
//  Data.swift
//  Todoey
//
//  Created by Dale Saini on 3/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
