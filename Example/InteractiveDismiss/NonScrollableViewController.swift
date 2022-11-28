//
//  NonScrollableViewController.swift
//  InteractiveDismiss_Example
//
//  Created by YEONGJUNG KIM on 2022/11/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import InteractiveDismiss

extension NonScrollableViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        InteractiveDismissPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class NonScrollableViewController: UIViewController {
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray
            label.textColor = .label
        } else {
            view.backgroundColor = .gray
            label.textColor = .black
        }
        
        label.text = "JUST A LABEL"
        label.textAlignment = .center
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
