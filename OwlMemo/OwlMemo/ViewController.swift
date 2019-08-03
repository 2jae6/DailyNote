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
    
    
    //사이드메뉴 버튼 아울렛
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var testList = [Test]()
    @IBOutlet weak var tableViewTest: UITableView!
    @IBOutlet weak var mainToday: UILabel!
    var db: OpaquePointer?
    var deleteNum: Int?
 override func viewDidLoad() {
        super.viewDidLoad()
    //오늘 날짜 표시
    todayDate()
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TestDatabase.sqlite")
    
    if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
        print("DB 열기 실패")
        print(fileURL)
    }
        readValues()
        sideMenu()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        readValues()
        print("갱신 완료")
    }
    //커스텀 메소드
    func sideMenu(){
        if let revealVC = self.revealViewController() {
            // 버튼이 클릭될 때 메인 컨트롤러에 정의된  revealToggle(_:)을 호출
            self.menuButton.target = revealVC
            self.menuButton.action = #selector(revealVC.revealToggle(_:))
            
            // 제스쳐를 뷰에 추가
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
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
            let DN_date = String(cString: sqlite3_column_text(stmt, 3))
            //adding values to list
            testList.append(Test(id: Int(id), DN_title: String(describing: DN_title), DN_subline: String(describing: DN_subline), DN_date: String(describing: DN_date)))

        }
        self.tableViewTest.reloadData()
    }
    
    
    func deleteData(){
        //first empty the list of Test
        testList.removeAll()
        //this is our select query
        let queryString = "DELETE FROM Test WHERE id == \(deleteNum!)"
        //statement pointer
        var stmt:OpaquePointer?
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v2 \(errmsg)")
            return
        }
        
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let DN_title = String(cString: sqlite3_column_text(stmt, 1))
            let DN_subline = String(cString: sqlite3_column_text(stmt, 2))
            let DN_date = String(cString: sqlite3_column_text(stmt, 3))
            //adding values to list
            
            testList.append(Test(id: Int(id), DN_title: String(describing: DN_title), DN_subline: String(describing: DN_subline), DN_date: String(describing: DN_date)))
        }
        readValues()
        
    }
    func todayDate(){
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        guard let savevc = self.storyboard?.instantiateViewController(withIdentifier: "savevc") as? SaveViewController else{
            return
        }
        let Test: Test
        Test = testList[indexPath.row]
        savevc.idNum = Test.id
        self.navigationController?.pushViewController(savevc, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let Test: Test
        Test = testList[indexPath.row]
        deleteNum = Test.id
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            testList.remove(at: indexPath.row)
            tableViewTest.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            deleteData()
        }
    
    }
}

