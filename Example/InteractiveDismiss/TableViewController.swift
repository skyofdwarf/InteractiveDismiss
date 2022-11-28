//
//  TableViewController.swift
//  InteractiveDismiss_Example
//
//  Created by YEONGJUNG KIM on 2022/11/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import InteractiveDismiss

extension TableViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        InteractiveDismissPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension TableViewController: InteractiveDismissPresenting {
    public var nestedScrollView: UIScrollView? { tv }
}

class TableViewController: UIViewController {
    let tv = UITableView(frame: .zero, style: .plain)
    let topFixedLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv.dataSource = self
        tv.delegate = self
        
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        tv.sectionHeaderHeight = 100
        tv.rowHeight = 50
        
        topFixedLabel.backgroundColor = .systemRed
        topFixedLabel.text = "FIXED VIEW - draggable regardless of scroll position"
        topFixedLabel.textAlignment = .center
        topFixedLabel.numberOfLines = 0
        
        view.addSubview(tv)
        view.addSubview(topFixedLabel)
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        topFixedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topFixedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topFixedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topFixedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topFixedLabel.heightAnchor.constraint(equalToConstant: 50),
            tv.topAnchor.constraint(equalTo: topFixedLabel.bottomAnchor),
            tv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "ROW: \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView(reuseIdentifier: "header")
        
        header.textLabel?.text = "TableView Header - draggable at scroll top"
        header.textLabel?.textAlignment = .center
        
        return header
    }
}
