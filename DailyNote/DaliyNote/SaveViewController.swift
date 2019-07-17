//
//  SaveViewController.swift
//  DaliyNote
//
//  Created by 1 on 17/07/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import UIKit
import SQLite3
import Foundation
class SaveViewController: UIViewController{
    
    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var titleTF: UILabel!
    @IBOutlet weak var sublineTF: UILabel!
    var testList = [Test]()
    var db: OpaquePointer?
    var idNum: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TestDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패")
        }
        readValues()
        let Test: Test
        Test = testList[0]
        dateTF?.text = Test.DN_date
        titleTF?.text = Test.DN_title
        sublineTF?.text = Test.DN_subline
    }
    

    //Custom Method
    func readValues(){
        //first empty the list of Test
        testList.removeAll()
        //this is our select query
        let queryString = "SELECT * FROM Test WHERE id == \(idNum!)"
        //statement pointer
        var stmt:OpaquePointer?
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v2 \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let DN_title = String(cString: sqlite3_column_text(stmt, 1))
            let DN_subline = String(cString: sqlite3_column_text(stmt, 2))
            let DN_date = String(cString: sqlite3_column_text(stmt, 3))
            //adding values to list
            
            testList.append(Test(id: Int(id), DN_title: String(describing: DN_title), DN_subline: String(describing: DN_subline), DN_date: String(describing: DN_date)))
            
        }
    }
    
    
}
