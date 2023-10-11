//
//  SelectingLocalConditionVC.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/09.
//

import UIKit
import DropDown

class SelectingLocalConditionVC: UIViewController {
    
    var city: String = "서울특별시"
    var squareFeet:String = "~85제곱미터"
    
    var selectedCity: Int = 0
    // DropDown 객체 생성
    let cityDropdown = DropDown()
    let squareFeetDropdown = DropDown()
    
    let cityList = ["서울", "강원", "대전", "충남", "세종", "충북", "인천", "경기", "광주", "전남", "전북", "부산", "경남", "울산", "제주", "경북", "대구"]

    let squareFeetList = ["~85제곱미터", "85제곱미터 ~ 100제곱미터", "100제곱미터 ~ 135제곱미터", "모든 면적"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackBtn()
        
        initUI()
        setDropdown()
    }
    
    @IBOutlet weak var cityDropView: UIView!
    @IBOutlet weak var squareFeetDropView: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var squareFeetLabel: UILabel!
    
        
    @IBOutlet weak var cityDropBtn: UIButton!
    @IBOutlet weak var squareFeetDropBtn: UIButton!
    
    @IBAction func submitBtnDidTap(_ sender: Any) {

        let newViewController = self.storyboard!.instantiateViewController(identifier: "LoadingViewController")
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(newViewController, animated: false)
    }
    
    func initUI() {
        // DropDown View의 배경
        cityDropView.layer.cornerRadius = 8
        cityDropView.layer.borderWidth = 1
        cityDropView.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        
        squareFeetDropView.layer.cornerRadius = 8
        squareFeetDropView.layer.borderWidth = 1
        squareFeetDropView.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        
        DropDown.appearance().textColor = UIColor(named: "8Fgrey") ?? .gray // 아이템 텍스트 색상
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 15)!
        DropDown.appearance().selectedTextColor = UIColor(named: "Blue") ?? .blue // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.white // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        
        cityDropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        squareFeetDropdown.dismissMode = .automatic
                    
    }

    
    func setDropdown() {
        cityDropdown.dataSource = cityList // dataSource로 ItemList를 연결
        cityDropdown.anchorView = self.cityDropView // anchorView를 통해 UI와 연결
        cityDropdown.bottomOffset = CGPoint(x: 0, y: cityDropView.bounds.height)// View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
          
        squareFeetDropdown.dataSource = squareFeetList
        squareFeetDropdown.anchorView = self.squareFeetDropView
        squareFeetDropdown.bottomOffset = CGPoint(x: 0, y: squareFeetDropView.bounds.height)

        
        cityDropdown.selectionAction = { [weak self] (index, item) in // Item 선택 시 처리
            self!.cityLabel.text = item
            self!.city = item
            self!.cityDropBtn.setImage(UIImage(named: "down"), for: .normal)
            self?.selectedCity = index

            self!.setDropdown()
        }
        cityDropdown.cancelAction = { [weak self] in // 취소 시 처리
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self!.cityDropBtn.setImage(UIImage(named: "down"), for: .normal)
        }
        
        squareFeetDropdown.selectionAction = { [weak self] (index, item) in // Item 선택 시 처리
            self!.squareFeetLabel.text = item
            self!.squareFeet = item
            self!.squareFeetDropBtn.setImage(UIImage(named: "down"), for: .normal)

        }
        squareFeetDropdown.cancelAction = { [weak self] in // 취소 시 처리
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self!.squareFeetDropBtn.setImage(UIImage(named: "down"), for: .normal)
        }
    }
    
    
    @IBAction func cityBtnDidTap(_ sender: UIButton) {
        cityDropdown.show()
        sender.setImage(UIImage(named: "up"), for: .normal)
    }
    
    @IBAction func squareFeetBtnDidTap(_ sender: UIButton) {
        squareFeetDropdown.show()
        sender.setImage(UIImage(named: "up"), for: .normal)
    }
    

}
extension UIViewController {
    func setBackBtn(){
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
}
