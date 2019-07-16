//
//  ViewController.swift
//  DaliyNote
//
//  Created by 1 on 10/07/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var testList = [Test]()
    @IBOutlet weak var tableViewTest: UITableView!
    
    @IBOutlet weak var mainToday: UILabel!
    var db: OpaquePointer?
    
 override func viewDidLoad() {
        super.viewDidLoad()
    //오늘 날짜 표시
    todayDate()
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TestDatabase.sqlite")
    
    if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
        print("DB 열기 실패")
    }
        readValues()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        readValues()
        print("갱신 완료")
    }
    
    func readValues(){
        //first empty the list of Test
        testList.removeAll()
        //this is our select query
        let queryString = "SELECT * FROM Test"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v1 \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let DN_title = String(cString: sqlite3_column_text(stmt, 1))
            let DN_subline = String(cString: sqlite3_column_text(stmt, 2))
            
            //adding values to list
            testList.append(Test(id: Int(id), DN_title: String(describing: DN_title), DN_subline: String(describing: DN_subline)))

        }
        self.tableViewTest.reloadData()
    }
    func todayDate(){
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = dateFormatter.string(from: today as Date)
        print(dateString) //"2019년 7월 15일"
        
        mainToday.text = dateString
        

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let Test: Test
        Test = testList[indexPath.row]
        cell.textLabel?.text = Test.DN_title
        return cell
    }
}

