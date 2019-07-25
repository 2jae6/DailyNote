//
//  Test.swift
//  DaliyNote
//
//  Created by 1 on 10/07/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
class Test{
    var id: Int
    var DN_title: String?
    var DN_subline: String?
    var DN_date: String?
    
    init(id: Int, DN_title: String?, DN_subline: String?, DN_date: String?){
        self.id = id
        self.DN_title = DN_title
        self.DN_subline = DN_subline
        self.DN_date = DN_date
    }
}
