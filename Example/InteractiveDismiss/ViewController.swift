//
//  ViewController.swift
//  InteractiveDismiss
//
//  Created by skyofdwarf on 11/27/2022.
//  Copyright (c) 2022 skyofdwarf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func presentScrollableModalButtonDidTap(_ sender: Any) {
        let tvc = TableViewController()
        
        tvc.modalPresentationStyle = .custom
        tvc.transitioningDelegate = tvc
        
        present(tvc, animated: true)
    }
    
    @IBAction func presentNonScrollableModalButtonDidTap(_ sender: Any) {
        let tvc = NonScrollableViewController()
        
        tvc.modalPresentationStyle = .custom
        tvc.transitioningDelegate = tvc
        
        present(tvc, animated: true)
    }
}
