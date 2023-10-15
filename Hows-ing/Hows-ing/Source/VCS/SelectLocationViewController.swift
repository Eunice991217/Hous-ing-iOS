//
//  SelectLocationViewController.swift
//  Hows-ing
//
//  Created by 황재상 on 10/12/23.
//

import UIKit

class SelectLocationViewController: UIViewController {
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var XmarkImage: UIImageView!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var locationWidth: NSLayoutConstraint!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var B100: UIButton!
    @IBOutlet weak var B200: UIButton!
    @IBOutlet weak var B300: UIButton!
    @IBOutlet weak var B312: UIButton!
    @IBOutlet weak var B338: UIButton!
    @IBOutlet weak var B360: UIButton!
    @IBOutlet weak var B400: UIButton!
    @IBOutlet weak var B410: UIButton!
    @IBOutlet weak var B500: UIButton!
    @IBOutlet weak var B513: UIButton!
    @IBOutlet weak var B560: UIButton!
    @IBOutlet weak var B600: UIButton!
    @IBOutlet weak var B690: UIButton!
    @IBOutlet weak var B700: UIButton!
    @IBOutlet weak var B712: UIButton!
    var btnArray:[UIButton] = []
    var ind: Int = -1
    var infoVC: SubscriptionInfoViewController?
    
    @IBAction func selectButtonTap(_ sender: Any) {
        infoVC?.ind = ind
        self.navigationController?.popViewController(animated: true)
    }
    
    func resetUI(){
        XmarkImage.alpha = 0
        locationText.text = "선택"
        locationWidth.constant = 60
        locationViewWidth.constant = 72
        locationView.backgroundColor = UIColor(red: 0.821, green: 0.821, blue: 0.821, alpha: 1)
        selectButton.alpha = 0
        
        for i in 0...btnArray.count - 1{
            btnArray[i].alpha = 1
        }
    }
    
    func selectUI(){
        XmarkImage.alpha = 1
        locationWidth.constant = 48
        locationViewWidth.constant = 78
        locationView.backgroundColor = UIColor(red: 0.247, green: 0.51, blue: 0.969, alpha: 1)
        selectButton.alpha = 1
    }
    
    @IBAction func deleteButtonTap(_ sender: Any) {
        resetUI()
        ind = -1
    }
    
    @IBAction func selectLocationTap(_ sender: UIButton) {
        selectUI()
        for i in 0...btnArray.count - 1{
            if btnArray[i] == sender{
                ind = i
                btnArray[i].alpha = 0
                locationText.text = btnArray[i].titleLabel?.text
            }else{
                btnArray[i].alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnArray = [B100, B200, B300, B312, B338, B360, B400, B410, B500, B513, B560, B600, B690, B700, B712]
        resetUI()
    }
}
