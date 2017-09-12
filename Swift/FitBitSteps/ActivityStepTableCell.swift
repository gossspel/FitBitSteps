//
//  ActivityStepTableCell.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/9/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import UIKit

class ActivityStepTableCell: UITableViewCell {

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.applyDefaultSetting()
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        let label = UILabel()
        label.applyDefaultSetting()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(stepLabel)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let views = ["dateLabel": dateLabel, "stepLabel": stepLabel]
        var constraints: [NSLayoutConstraint] = []
        
        let subjectLabelHConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[dateLabel(>=100)][stepLabel(==dateLabel)]-|",
            options: [.alignAllCenterY],
            metrics: nil,
            views: views)
        constraints += subjectLabelHConstraints
        
        
        self.contentView.addConstraints(constraints)
    }
}
