//
//  CitySelectionViewController.swift
//  Clock
//
//  Created by 전율 on 10/13/24.
//

import UIKit

struct Item {
    let title: String
    let timeZone: TimeZone
}

struct Section {
    let title: String
    let items: [Item]
}


class CitySelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var list = [Section]()
    
    func setupList() {
        var dict = [String: [TimeZone]]()
        
        for id in TimeZone.knownTimeZoneIdentifiers {
            guard let city = id.components(separatedBy: "/").last else { return }
            var timeZoneList = [TimeZone(identifier: id)!]
            let key = city.chosung ?? "Unknown"
            
            if let list = dict[key] {
                timeZoneList.append(contentsOf: list)
            }
            dict[key] = timeZoneList
        }
        
        for (key, value) in dict {
            let items = value.sorted {
                return $0.city < $1.city
            }.map {
                Item(title: $0.city, timeZone: $0)
            }
            let section = Section(title: key, items: items)
            list.append(section)
        }
        list.sort { $0.title < $1.title }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupList()
        tableView.reloadData()
    }
    
}

extension CitySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let target = list[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = target.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let chosungAndAlphabet: [String] = [
            "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ",
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        ]
        return chosungAndAlphabet
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return list.firstIndex {
            return $0.title.uppercased() == title.uppercased()
        } ?? 0
    }
}
