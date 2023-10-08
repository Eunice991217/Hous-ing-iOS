//
//  ViewController.swift
//  Hows-ing
//
//  Created by 황재상 on 10/7/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var Banner: UICollectionView!
    @IBOutlet weak var TabbarView: UIView!
    @IBOutlet weak var PaperIcon:  UIImageView!
    @IBOutlet weak var HomeIcon: UIImageView!
    @IBOutlet weak var PaperText: UILabel!
    @IBOutlet weak var HomeText: UILabel!
    let pageLock = NSLock()
    var tapNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Init()
        Banner.delegate = self
        Banner.dataSource = self
    }
    
    func Init(){
        Banner.layer.cornerRadius = 10
        TabbarView.layer.cornerRadius = 40
        TabbarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        TabbarView.layer.shadowOffset = CGSize(width: 0, height: 4)
        TabbarView.layer.shadowColor = UIColor.black.cgColor
        TabbarView.layer.shadowOpacity = 0.2
        TabbarView.layer.shadowRadius = 24 / UIScreen.main.scale
        
    }
    
    @IBAction func PaperButtonTap(_ sender: Any) {
        if tapNum == 0 {
            return
        }
        self.pageLock.lock()
        defer { self.pageLock.unlock() }
        PaperIcon.image = UIImage(named: "PaperSelect")
        HomeIcon.image = UIImage(named: "Home")
        PaperText.textColor = UIColor(named: "HousingBlue")
        HomeText.textColor = UIColor(named: "HousingGray")
        tapNum = 0
    }
    
    @IBAction func HomeButtonTap(_ sender: Any) {
        if tapNum == 1 {
            return
        }
        self.pageLock.lock()
        defer { self.pageLock.unlock() }
        PaperIcon.image = UIImage(named: "Paper")
        HomeIcon.image = UIImage(named: "HomeSelect")
        PaperText.textColor = UIColor(named: "HousingGray")
        HomeText.textColor = UIColor(named: "HousingBlue")
        tapNum = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

