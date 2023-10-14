//
//  LoadingViewController.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/09.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
        
       
        let newViewController = self.storyboard!.instantiateViewController(identifier: "SubscriptionResultViewController")
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen

        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
          // 1초 후 실행될 부분
            self.present(newViewController, animated: false)
        }

       }

}
