//
//  FitBitClientVC.swift
//  FitBitSteps
//
//  Created by Sunny Chan on 9/8/17.
//  Copyright © 2017 Mango. All rights reserved.
//

import UIKit

class FitBitClientVC: UIViewController {

    var VM: FitBitClientVM
    
    var activityStepTableView: UITableView
    
    // MARK: - UI
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.VM = FitBitClientVM()
        self.activityStepTableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.VM = FitBitClientVM()
        self.activityStepTableView = UITableView()
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        loadTableView()
    }
    
    fileprivate func loadTableView() {
        activityStepTableView.translatesAutoresizingMaskIntoConstraints = false
        activityStepTableView.estimatedRowHeight = 96
        activityStepTableView.rowHeight = UITableViewAutomaticDimension
        activityStepTableView.register(ActivityStepTableCell.self, forCellReuseIdentifier: VM.activityStepTableCellReuseID)
        activityStepTableView.dataSource = self
        activityStepTableView.delegate = self
        view.addSubview(activityStepTableView)
        let views = ["activityStepTableView": activityStepTableView]
        var constraints: [NSLayoutConstraint] = []
        
        let activityStepTableViewHConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[activityStepTableView]|",
            options: [],
            metrics: nil,
            views: views)
        constraints += activityStepTableViewHConstraints
        
        let activityStepTableViewVConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-64-[activityStepTableView]|",
            options: [],
            metrics: nil,
            views: views)
        constraints += activityStepTableViewVConstraints
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKVO()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    deinit {
        removeKVO()
    }
    
    // MARK: - KVO
    func addKVO() {
        for keyPath in VM.KVOKeyPaths {
            VM.addObserver(self, forKeyPath: keyPath, options: [.initial, .new], context: nil)
        }
    }
    
    func removeKVO() {
        for keyPath in VM.KVOKeyPaths {
            VM.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?)
    {
        let initialValue: Any? = change?[.notificationIsPriorKey]
        let newValue: Any? = change?[.newKey]
        let valueToBeUpdated: Any? = (initialValue != nil) ? initialValue : newValue
        
        guard let sureValueToBeUpdated = valueToBeUpdated, let sureKeyPath = keyPath else {
            return
        }
        
        switch sureKeyPath {
        case "activityStepTableCellVMsUpdated":
            activityStepTableView.reloadData()
        case "oldStepsAdded":
            guard let oldStepsAdded = sureValueToBeUpdated as? Int, oldStepsAdded > 0 else {
                return
            }
            
            activityStepTableView.beginUpdates()
            var indexPaths: [IndexPath] = []
            let start: Int = VM.activityStepTableCellVMs.count - oldStepsAdded
            
            for i in 0..<oldStepsAdded {
                indexPaths.append(IndexPath(row: i + start, section: 0))
            }
            
            activityStepTableView.insertRows(at: indexPaths, with: .automatic)
            activityStepTableView.endUpdates()
            activityStepTableView.reloadData()
            
            
        case "newStepsAdded":
            guard let newStepsAdded = sureValueToBeUpdated as? Int, newStepsAdded > 0 else {
                return
            }
            
            activityStepTableView.beginUpdates()
            var indexPaths: [IndexPath] = []
            
            for i in 0..<newStepsAdded {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            
            activityStepTableView.insertRows(at: indexPaths, with: .automatic)
            activityStepTableView.endUpdates()
            activityStepTableView.reloadData()
            
        case "hasAuthError":
            guard let hasAuthError = sureValueToBeUpdated as? Bool, let sureCompleteAuthURL = URL(string: completeAuthURL) else {
                return
            }
            
            if hasAuthError {
                UIApplication.shared.open(sureCompleteAuthURL)
            }
        default:
            break
        }
        
    }
}

// MARK: -
extension FitBitClientVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.activityStepTableCellVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: VM.activityStepTableCellReuseID, for: indexPath)
    }
}

// MARK: -
extension FitBitClientVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        VM.updateForInfiniteScrolling(indexPath.row)
        
        guard let sureCell = cell as? ActivityStepTableCell else {
            return
        }
        
        let cellVM: ActivityStepTableCellVM = VM.activityStepTableCellVMs[indexPath.row]
        sureCell.dateLabel.text = cellVM.dateLabelText
        sureCell.stepLabel.text = cellVM.stepLabelText
    }
}
