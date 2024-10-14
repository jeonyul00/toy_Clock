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
        TimeZone(identifier: "Europe/Paris")!,
        TimeZone(identifier: "America/New_York")!,
        TimeZone(identifier: "Asia/Tehran")!,
        TimeZone(identifier: "Asia/Vladivostok")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(forName: .timeZoneDidSelect, object: nil, queue: .main) { [weak self]  noti in
            guard let self = self, let timeZone = noti.userInfo?["timeZone"] as? TimeZone else { return }
            if !list.contains(timeZone) {
                self.list.append(timeZone)
                self.tableView.reloadData()
            }
        }
    }    
}

extension WorldClockViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockTableViewCell", for: indexPath) as! WorldClockTableViewCell
        
        let target = list[indexPath.row]
        cell.timeLabel.text = target.currentTime
        cell.timePeriodLabel.text = target.timePeriod
        cell.timeZoneLabel.text = target.city
        cell.timeOffCellLabel.text = target.timeOffset
        return cell
    }
}
