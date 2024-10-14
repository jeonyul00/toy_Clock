//
//  WorldClockViewController.swift
//  Clock
//
//  Created by 전율 on 10/10/24.
//

import UIKit
// MARK: - property
class WorldClockViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var list = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier: "Europe/Paris")!,
        TimeZone(identifier: "America/New_York")!,
        TimeZone(identifier: "Asia/Tehran")!,
        TimeZone(identifier: "Asia/Vladivostok")!,
    ]
    
    // MARK: - life cycle
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
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        
    }
}

// MARK: - tableView
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
    
    // 편집 기능: 셀을 왼쪽으로 스와이프하면 삭제 버튼 표시 && 탭하면 호출
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic) // 삭제 애니메이션 추가
        }
    }
    
    // 셀 순서 변경
    // sourceIndexPath: 시작 위치
    // destinationIndexPath: 이동한 위치
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let target = list.remove(at: sourceIndexPath.row)
        list.insert(target, at: destinationIndexPath.row)
    }
}
