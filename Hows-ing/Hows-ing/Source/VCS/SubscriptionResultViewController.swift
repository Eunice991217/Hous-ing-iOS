//
//  SubscriptionResultViewController.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/09.
//

import UIKit

class SubscriptionResultViewController: UIViewController {
    var hitProb: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultView.layer.cornerRadius = 8
        resultView.layer.borderWidth = 0.5
        resultView.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        
        showHitProb()
        resultView.clipsToBounds = true
        
        highLabel.layer.borderWidth = 0.5
        highLabel.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
    }
    
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var veryHighLabel: UILabel!
    
    
    @IBOutlet weak var resultView: UIView!
    
    func showHitProb(){
        normalLabel.clipsToBounds = true
        highLabel.clipsToBounds = true
        veryHighLabel.clipsToBounds = true
        
        switch hitProb {
        case 0:
            normalLabel.backgroundColor = UIColor(red: 0.975, green: 0.377, blue: 0.041, alpha: 1)
            normalLabel.textColor = .white
        case 1:
            highLabel.backgroundColor = UIColor(red: 0.975, green: 0.377, blue: 0.041, alpha: 1)
            highLabel.textColor = .white
        case 2:
            veryHighLabel.backgroundColor = UIColor(red: 0.975, green: 0.377, blue: 0.041, alpha: 1)
            veryHighLabel.textColor = .white
        default:
            normalLabel.backgroundColor = UIColor(red: 0.975, green: 0.377, blue: 0.041, alpha: 1)
            normalLabel.textColor = .white
        }
    }
    

}
