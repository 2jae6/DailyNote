//
//  Rewrite.swift
//  DaliyNote
//
//  Created by 1 on 19/07/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
class Rewrite:UIViewController, UITextFieldDelegate, UITextViewDelegate{
    //필요한 변수들
    var testList = [Test]()
    var db: OpaquePointer?
    var idNum: Int?
    

    @IBOutlet weak var dateTF: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var sublineTF: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DB 열기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("TestDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("DB 열기 실패")
        }
        titleTF.delegate = self
        sublineTF.delegate = self
        //데이터 읽어오기
        readValues()
        let Test: Test
        Test = testList[0]
        dateTF?.text = Test.DN_date
        titleTF?.text = Test.DN_title
        sublineTF?.text = Test.DN_subline
    }
    
    
    @IBAction func rewriteButton(_ sender: Any) {
        let DN_title = titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let DN_subline = sublineTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let DN_date = dateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
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
        let queryString = "UPDATE Test SET DN_title = '\(DN_title!)', DN_subline = '\(DN_subline!)' WHERE id == \(idNum!)"
        
        // 쿼리 준비
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }

        //삽입 값 쿼리 실행
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("삽입하는데 실패했다: \(errmsg)")
            return
        }
        //displaying a success message
        print("Test saved successfully")
        
        //화면 이동
        self.navigationController?.popViewController(animated: false)
        
        
    }
    //textField return action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTF.resignFirstResponder()
        return true
    }
    //textview placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if sublineTF.text == ""{
            textViewSetupView()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            sublineTF.resignFirstResponder()
        }
        return true
    }
    //Custom Method
    func textViewSetupView(){
        if sublineTF.text == "Please enter a text"{
            sublineTF.text = ""
            sublineTF.textColor = UIColor.black
            
        }else if sublineTF.text == ""{
            sublineTF.text = "Please enter a text"
            sublineTF.textColor = UIColor.lightGray
        }
    }
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
