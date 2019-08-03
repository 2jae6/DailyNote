//
//  MenuTableViewController.swift
//  OwlMemo
//
//  Created by 1 on 02/08/2019.
//  Copyright © 2019 wook. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    let menuList:[String?] = ["검색하기", "모아보기", "즐겨찾기"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.row]
        return cell
    }

}
