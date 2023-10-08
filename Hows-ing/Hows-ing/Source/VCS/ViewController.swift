//
//  ViewController.swift
//  Hows-ing
//
//  Created by 황재상 on 10/7/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var Banner: UICollectionView!
    @IBOutlet weak var TabbarView: UIView!
    @IBOutlet weak var PaperIcon:  UIImageView!
    @IBOutlet weak var HomeIcon: UIImageView!
    @IBOutlet weak var PaperText: UILabel!
    @IBOutlet weak var HomeText: UILabel!
    @IBOutlet weak var Button1View: UIView!
    @IBOutlet weak var Button2View: UIView!
    @IBOutlet weak var Button1Title: UILabel!
    @IBOutlet weak var Button2Title: UILabel!
    let pageLock = NSLock()
    var bannerData:[BannerData] = []
    var tapNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIInit()
        makeDummyData()
        Banner.delegate = self
        Banner.dataSource = self
    }
    
    func UIInit(){
        Banner.layer.cornerRadius = 10
        
        TabbarView.layer.cornerRadius = 40
        TabbarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        TabbarView.layer.shadowOffset = CGSize(width: 0, height: 4)
        TabbarView.layer.shadowColor = UIColor.black.cgColor
        TabbarView.layer.shadowOpacity = 0.2
        TabbarView.layer.shadowRadius = 24 / UIScreen.main.scale
        
        Button1View.layer.cornerRadius = 20
        Button1View.layer.shadowOffset = CGSize(width: 0, height: 4)
        Button1View.layer.shadowColor = UIColor(named: "Shadow1")?.cgColor
        Button1View.layer.shadowOpacity = 0.25
        Button1View.layer.shadowRadius = 15 / UIScreen.main.scale
        
        Button2View.layer.cornerRadius = 20
        Button2View.layer.shadowOffset = CGSize(width: 0, height: 4)
        Button2View.layer.shadowColor = UIColor(named: "Shadow1")?.cgColor
        Button2View.layer.shadowOpacity = 0.25
        Button2View.layer.shadowRadius = 15 / UIScreen.main.scale
        
        Button1Title.text = "지역별\n청약 정보"
        
        Button2Title.text = "나에게 딱 맞는\n청약은?"
     
    }
    
    func makeDummyData(){
        bannerData.append(BannerData(title: "AI, 주택청약 당첨 확률 알려줘! 👀", bgColor: "BannerYellow"))
        bannerData.append(BannerData(title: "미래 집값, 예측할 수 있다고? 🏠", bgColor: "BannerOrange"))
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
        return bannerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.BGView.backgroundColor = UIColor(named: bannerData[indexPath.row].bgColor)
        cell.Title.text = bannerData[indexPath.row].title
        cell.Title.textColor = UIColor.white
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Banner.frame.width, height: Banner.frame.height)
    }
}

struct BannerData{
    let title, bgColor: String
}
