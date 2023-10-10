//
//  mapDetailCont.swift
//  Hows-ing
//
//  Created by 김민경 on 10/8/23.
//

import UIKit
import Foundation


class mapDetailCont: UIViewController {
    
    
    // 뒤로가기 버튼
    @IBOutlet weak var backBtn: UIButton!
    
    // 부동산 이름
    @IBOutlet weak var nameLabel: UILabel!
    
    // 매매 view
    @IBOutlet weak var view1: UIView!
    
    // 매매 label
    @IBOutlet weak var viewName1: UILabel!
    
    // 전월세 view
    @IBOutlet weak var view2: UIView!
    
    // 전월세 label
    @IBOutlet weak var viewName2: UILabel!
    
    // 뒤로가기 버튼 클릭했을 때
    @IBAction func backDidTap(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 평수 view
    @IBOutlet weak var squareFeet: UIView!
    
    // 최근 실거래 기준 1개월 평균 view
    @IBOutlet weak var avgView: UIView!
    
    // 최근 3년 view
    @IBOutlet weak var thirdView: UIView!
    
    // 전체기간 view
    @IBOutlet weak var allView: UIView!
    
    // 최근 3년 버튼
    @IBOutlet weak var thirdBtn: UIButton!
    
    // 전체 기간 버튼
    @IBOutlet weak var allBtn: UIButton!
    
    let bottomBorder1 = CALayer()
    let bottomBorder2 = CALayer()
    let borderWidth1: CGFloat = 1.2 // 테두리 두께 설정
    let borderWidth2: CGFloat = 1.0 // 테두리 두께 설정
    
    // 최근 3년 btn did tap
    @IBAction func btn1(_ sender: Any) {
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder1)
        
        // 전체 기간 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder2)
        
        thirdBtn.tintColor =  UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        allBtn.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
    }
    
    // 전체 기간 btn did tap
    @IBAction func btn2(_ sender: Any) {
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder1)
        
        // 전체 기간 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder2)
        
        allBtn.tintColor =  UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        thirdBtn.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 최근 3년 view
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder1)
        
        // 전체 기간 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder2)
        
        
        // 매매 view layout
        view1.layer.cornerRadius = 5
        view1.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        // 전월세 버튼 클릭했을 때
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(didTapView1(_:)))

        // 전월세 버튼 클릭 func 추가
        view2.addGestureRecognizer(tapGestureRecognizer1)
        
        // 매매 버튼 클릭했을 때
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(didTapView2(_:)))

        // 매매 버튼 클릭 func 추가
        view1.addGestureRecognizer(tapGestureRecognizer2)
        
        // 평수 버튼 클릭했을 때
        // 매매 버튼 클릭했을 때
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(didTapView3(_:)))

        // 매매 버튼 클릭 func 추가
        squareFeet.addGestureRecognizer(tapGestureRecognizer3)
        
        // 전월세 view layout
        view2.layer.cornerRadius = 5
        view2.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner)
        view2.layer.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        view2.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        
        // 평수 view
        squareFeet.layer.cornerRadius = 5
        squareFeet.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner)
        
        // 평균 view
        avgView.layer.cornerRadius = 5
        avgView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner)
        avgView.layer.shadowOpacity = 1
        avgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        avgView.layer.shadowOffset = CGSize(width: 0, height: -4)
        avgView.layer.shadowRadius = 24
        avgView.layer.masksToBounds = false
        avgView.clipsToBounds = false
        avgView.layer.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        avgView.layer.borderWidth = 1
        
        
    }
    
    // 전월세 버튼 클릭했을 때
    @objc func didTapView1(_ sender: UITapGestureRecognizer) {
        
        view1.backgroundColor = UIColor.white
        view1.layer.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        view1.layer.borderWidth = 1
        viewName1.textColor = UIColor.gray
        
        view2.backgroundColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        viewName2.textColor = UIColor.white
        
    }
    
    // 매매 버튼 클릭했을 때
    @objc func didTapView2(_ sender: UITapGestureRecognizer) {
        
        view2.backgroundColor = UIColor.white
        view2.layer.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        view2.layer.borderWidth = 1
        viewName2.textColor = UIColor.gray
        
        view1.backgroundColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        viewName1.textColor = UIColor.white
        
    }
    
    // 매매 버튼 클릭했을 때
    @objc func didTapView3(_ sender: UITapGestureRecognizer) {
        print("평수 버튼 클릭")
    }
    
    
}
