//
//  WorldClockViewController.swift
//  Clock
//
//  Created by 전율 on 10/10/24.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var list = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier: "Europe/Paris")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}

extension WorldClockViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockTableViewCell", for: indexPath) as! WorldClockTableViewCell        
        return cell
    }
}
