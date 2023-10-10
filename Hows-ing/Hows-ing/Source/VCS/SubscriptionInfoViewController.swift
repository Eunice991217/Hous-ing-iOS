//
//  SubscriptionInfoViewController.swift
//  Hows-ing
//
//  Created by 황재상 on 10/10/23.
//

import UIKit

class SubscriptionInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}
