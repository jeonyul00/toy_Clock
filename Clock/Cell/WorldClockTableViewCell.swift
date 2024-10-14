//
//  WorldClockTableViewCell.swift
//  Clock
//
//  Created by 전율 on 10/10/24.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {

    @IBOutlet weak var timeOffCellLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var spacingContaint: NSLayoutConstraint!
    @IBOutlet weak var timeLabelTrailingConstaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // tableView에서 편집 상태가 바뀔 때 마다 호출
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // 스와이프인지 edit인지
        if (self.superview as? UITableView) == nil { return }
        
        UIView.animate(withDuration: 0.4, animations: {
            if self.timeLabel.isHidden && self.timePeriodLabel.isHidden  {
                self.timeLabel.isHidden = editing
                self.timePeriodLabel.isHidden = editing
            }
            self.spacingContaint.isActive = !editing
            self.timeLabelTrailingConstaint.constant = editing ? -40 : 0

            // 먼저 opacity 애니메이션을 적용
            self.timeLabel.layer.opacity = editing ? 0 : 1
            self.timePeriodLabel.layer.opacity = editing ? 0 : 1
            self.layoutIfNeeded()
        }, completion: { isCompletion in
            // 애니메이션이 끝난 뒤에 isHidden 적용
            if isCompletion {
                self.timeLabel.isHidden = editing
                self.timePeriodLabel.isHidden = editing
            }
        })
    }
    
}

