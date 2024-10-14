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

// MARK: - property
class CitySelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var list = [Section]()
    var filteredList = [Section]()
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
        filteredList = list
    }
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색"
        searchBar.delegate = self
        
        let btn = UIButton(type: .custom)
        btn.setTitle("cancle", for: .normal)
        btn.setTitleColor(.systemOrange, for: .normal)
        btn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [searchBar, btn])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: view.bounds.width - 40).isActive = true
        navigationItem.titleView = stack
        
        setupList()
        tableView.reloadData()
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
        
    }
    
}

// MARK: - tableView
extension CitySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let target = filteredList[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = target.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredList[section].title
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let chosungAndAlphabet: [String] = [
            "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ",
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        ]
        return chosungAndAlphabet
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return filteredList.firstIndex {
            return $0.title.uppercased() == title.uppercased()
        } ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = filteredList[indexPath.section].items[indexPath.row] as Item
        NotificationCenter.default.post(name: .timeZoneDidSelect, object: nil, userInfo: ["timeZone": target.timeZone ])
        self.dismiss(animated: true)
    }
}

// MARK: - notification
extension Notification.Name {
    static let timeZoneDidSelect = Notification.Name(rawValue: "timeZoneDidSelect")
}

// MARK: - searchBar
extension CitySelectionViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            filteredList = list
            tableView.reloadData()
            tableView.isHidden = filteredList.isEmpty
            return
        }
        filteredList.removeAll()
        for section in list {
            let items = section.items.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
            if !items.isEmpty {
                filteredList.append(Section(title: section.title, items: items))
            }
        }
        tableView.reloadData()
        tableView.isHidden = filteredList.isEmpty
    }
            
}
