//
//  ViewController.swift
//  InteractiveDismiss
//
//  Created by skyofdwarf on 11/27/2022.
//  Copyright (c) 2022 skyofdwarf. All rights reserved.
//

import UIKit
import InteractiveDismiss

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentButtonDidTap(_ sender: Any) {
//        guard let tvc = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? UITableViewController
//        else {
//            return
//        }
        
        let tvc = TableViewController()
        
        tvc.modalPresentationStyle = .custom
        tvc.transitioningDelegate = tvc
        
        present(tvc, animated: true)
    }
}



extension UITableViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        InteractiveDismissPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension UITableViewController: InteractiveDismissPresenting {
    public var nestedScrollView: UIScrollView? { tableView }
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

extension TableViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        InteractiveDismissPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension TableViewController: InteractiveDismissPresenting {
    public var nestedScrollView: UIScrollView? { tv }
}
