//
//  SecondViewController.swift
//  DaliyNote
//
//  Created by 1 on 10/07/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController{
    
    //Outlet 변수 및 변수 선언
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var sublineTF: UITextField!
    @IBOutlet weak var todayDateTF: UILabel!
    var db: OpaquePointer?
    var testList = [Test]()

    @IBAction func addButton(_ sender: Any) {
        //텍스트 필드의 값 가져오기
        let DN_title = titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let DN_subline = sublineTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //텍스트 필드의 값이 빈 경우의 처리
        if(DN_title?.isEmpty)!{
            titleTF.layer.borderColor = UIColor.red.cgColor
            return
        }
        if(DN_subline?.isEmpty)!{
            sublineTF.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        // 명령 객체 만들기
        var stmt: OpaquePointer?
        
        // 쿼리 집어넣기
        let queryString = "INSERT INTO Test (DN_title, DN_subline) Values (?,?)"
        
        // 쿼리 준비
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        // 파라미터 바인딩
     //   let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        if sqlite3_bind_text(stmt, 1, DN_title, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 2, DN_subline, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        //삽입 값 쿼리 실행
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("삽입하는데 실패했다: \(errmsg)")
            return
        }
        //emptying the textfields
        titleTF.text=""
        sublineTF.text=""
        
        //displaying a success message
        print("Test saved successfully")
        
        //화면 이동
        guard let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "vc1") as? ViewController else{
            return
        }
        self.present(vc1, animated: true)
        

    }

    func opendb(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TestDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패222")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Test (id INTEGER PRIMARY KEY AUTOINCREMENT, DN_title TEXT, DN_subline TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        opendb()
        todayDate2()
    }
    
    //Custom Method
    //오늘의 날짜 출력 함수
    func todayDate2(){
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = dateFormatter.string(from: today as Date)
        print(dateString) //"2019년 7월 15일"
        
       todayDateTF?.text = dateString
    }
    
}
