//
//  SelectingConditionViewController.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/08.
//

import UIKit
import DropDown

class SelectingConditionViewController: UIViewController {
    
    var age: String = ""
    var identity: String = ""
    var familyNumber: String = ""
    var havingNoHousePeriod: String = ""
    var joinAccountPeriod: String = ""
    var moneyAmmount: String = ""
    
    // DropDown 객체 생성
    let noHouseDropdown = DropDown()
    let joinAccountDropdown = DropDown()
    let moneyAmountDropdown = DropDown()


    // DropDown 아이템 리스트
    let noHouseItemList = ["유주택", "유주택, 30세 미만 미혼인 무주택", "만 1년 미만", "만 1년 이상~2년 미만", "만 2년 이상 ~ 3년 미만", "만 3년 이상~4년 미만","만 4년 이상~5년 미만", "만 5년 이상~6년 미만","만 6년 이상~7년 미만","만 7년 이상~8년 미만", "만 8년 이상~9년 미만", "만 9년 이상~10년 미만", "만 10년 이상~11년 미만", "만 11 이상~12년 미만", "만 12 이상~13년 미만","만 13년 이상~14년 미만", "만 14 이상~15년 미만", "만 15년 이상"]
    let joinAccountItemList = ["만 6개월 미만", "만 6개월 이상 ~ 1년 미만", "만 1년 이상 ~ 2년 미만", "만 2년 이상 ~ 3년 미만", "만 3년 이상 ~ 4년 미만", "만 4년 이상 ~ 5년 미만", "만 5년 이상 ~ 6년 미만", "만 6년 이상 ~ 7년 미만", "만 7년 이상 ~ 8년 미만", "만 8년 이상 ~ 9년 미만", "만 9년 이상 ~ 10년 미만", "만 10년 이상 ~ 11년 미만", "만 11년 이상 ~ 12년 미만", "만 12년 이상 ~ 13년 미만", "만 13년 이상 ~ 14년 미만", "만 14년 이상 ~ 15년 미만", "만 15년 이상"]
    let moneyAmountItemList = ["200만원 미만", "200만원 이상 - 250만원 미만", "250만원 이상 - 300만원 미만", "300만원 이상 - 400만원 미만", "400만원 이상 - 500만원 미만", "500만원 이상 - 600만원 미만", "600만원 이상 - 700만원 미만", "700만원 이상 - 1000만원 미만", "1000만원 이상 - 1500만원 미만", "1500만원 이상" ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        setDropdown()
        setSubmitBtn()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "AI 청약 추천"
        self.navigationController?.navigationItem.title = ""
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let backButtonAppearance = UIBarButtonItemAppearance()
           // backButton하단에 표출되는 text를 안보이게 설정
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0.0)]
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.backButtonAppearance = backButtonAppearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setAgeBtnDefault();setIdentityBtnDefault();setFamilyBtnDefault()
        
        ageBtn_10.tag = 10; ageBtn_20.tag = 20; ageBtn_30.tag = 30; ageBtn_40.tag = 40
        identityBtn_student.tag = 1; identityBtn_worker.tag = 2; identityBtn_newMarriage.tag = 3; identityBtn_marriage.tag = 4; identityBtn_basicLiving.tag = 5
        familyNumber_0.tag = 0; familyNumber_1.tag = 1; familyNumber_2.tag = 2; familyNumber_3.tag = 3
        ageBtn_10.addTarget(self, action: #selector(ageBtnClicked(_:)), for: .touchUpInside);ageBtn_20.addTarget(self, action: #selector(ageBtnClicked(_:)), for: .touchUpInside);ageBtn_30.addTarget(self, action: #selector(ageBtnClicked(_:)), for: .touchUpInside);ageBtn_40.addTarget(self, action: #selector(ageBtnClicked(_:)), for: .touchUpInside)
        
        identityBtn_student.addTarget(self, action: #selector(identityBtnClicked(_:)), for: .touchUpInside);identityBtn_worker.addTarget(self, action: #selector(identityBtnClicked(_:)), for: .touchUpInside);identityBtn_newMarriage.addTarget(self, action: #selector(identityBtnClicked(_:)), for: .touchUpInside);identityBtn_marriage.addTarget(self, action: #selector(identityBtnClicked(_:)), for: .touchUpInside);identityBtn_basicLiving.addTarget(self, action: #selector(identityBtnClicked(_:)), for: .touchUpInside)
        
        familyNumber_0.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside);familyNumber_1.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside);familyNumber_2.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside);familyNumber_3.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside);familyNumber_4.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside);familyNumber_5.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside);familyNumber_6.addTarget(self, action: #selector(familyNumberBtnClicked(_:)), for: .touchUpInside)
        
        submitBtn.layer.cornerRadius = 12
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.topItem?.title = "AI 청약 추천"
//
//    }
    
    @IBOutlet weak var ageBtn_10: UIButton!
    @IBOutlet weak var ageBtn_20: UIButton!
    @IBOutlet weak var ageBtn_30: UIButton!
    @IBOutlet weak var ageBtn_40: UIButton!
    
    @IBOutlet weak var identityBtn_student: UIButton!
    @IBOutlet weak var identityBtn_worker: UIButton!
    @IBOutlet weak var identityBtn_newMarriage: UIButton!
    @IBOutlet weak var identityBtn_marriage: UIButton!
    @IBOutlet weak var identityBtn_basicLiving: UIButton!
    
    @IBOutlet weak var familyNumber_0: UIButton!
    @IBOutlet weak var familyNumber_1: UIButton!
    @IBOutlet weak var familyNumber_2: UIButton!
    @IBOutlet weak var familyNumber_3: UIButton!
    @IBOutlet weak var familyNumber_4: UIButton!
    @IBOutlet weak var familyNumber_5: UIButton!
    @IBOutlet weak var familyNumber_6: UIButton!

    
    @IBOutlet weak var noHouseDropView: UIView!
    @IBOutlet weak var noHousePeriodLabel: UILabel!
    @IBOutlet weak var noHouseDropBtn: UIButton!
    
    
    @IBOutlet weak var joinAccountDropView: UIView!
    @IBOutlet weak var joinAccountPeriodLabel: UILabel!
    @IBOutlet weak var joinAccountDropBtn: UIButton!
    
    @IBOutlet weak var moneyAmountDropView: UIView!
    @IBOutlet weak var moneyAmountLabel: UILabel!
    @IBOutlet weak var moneyAmountDropBtn: UIButton!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    @objc func ageBtnClicked(_ sender: UIButton) {
        setAgeBtnDefault()
        setBtnSelected(sender)
        setSubmitBtn()

        switch sender.tag {
        case 10:
            age = "10대"
        case 20:
            age = "20대"
        case 30:
            age = "30대"
        case 40:
            age = "40대 이상"
        default:
            break
        }
    }
    @objc func identityBtnClicked(_ sender: UIButton) {
        setIdentityBtnDefault()
        setBtnSelected(sender)
        setSubmitBtn()

        switch sender.tag {
        case 1:
            identity = "학생"
        case 2:
            identity = "직장인"
        case 3:
            identity = "신혼부부"
        case 4:
            identity = "부부"
        case 5:
            identity = "기초생활수급자"
        default:
            identity = ""
            break
        }
    }
    @objc func familyNumberBtnClicked(_ sender: UIButton) {
        setFamilyBtnDefault()
        setBtnSelected(sender)
        setSubmitBtn()

        switch sender.tag {
        case 0:
            familyNumber = "0명"
        case 1:
            familyNumber = "1명"
        case 2:
            familyNumber = "2명"
        case 3:
            familyNumber = "3명"
        case 4:
            familyNumber = "4명"
        case 5:
            familyNumber = "5명"
        case 6:
            familyNumber = "6명 이상"
        default:
            familyNumber = "0명"
            break
        }
    }

    
    func setBtnSelected(_ button: UIButton){
        button.setTitleColor(.white, for: .normal)


        button.layer.backgroundColor = UIColor(red: 0.247, green: 0.51, blue: 0.969, alpha: 1).cgColor
        button.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 0).cgColor
    }
    
    func setAgeBtnDefault(){
        setBtnDefaultBorder(ageBtn_10)
        setBtnDefaultBorder(ageBtn_20)
        setBtnDefaultBorder(ageBtn_30)
        setBtnDefaultBorder(ageBtn_40)
    }
    func setIdentityBtnDefault(){
        setBtnDefaultBorder(identityBtn_student)
        setBtnDefaultBorder(identityBtn_worker)
        setBtnDefaultBorder(identityBtn_newMarriage)
        setBtnDefaultBorder(identityBtn_marriage)
        setBtnDefaultBorder(identityBtn_basicLiving)
    }
    func setFamilyBtnDefault(){
        setBtnDefaultBorder(familyNumber_0)
        setBtnDefaultBorder(familyNumber_1)
        setBtnDefaultBorder(familyNumber_2)
        setBtnDefaultBorder(familyNumber_3)
        setBtnDefaultBorder(familyNumber_4)
        setBtnDefaultBorder(familyNumber_5)
        setBtnDefaultBorder(familyNumber_6)
    }
    
    func setBtnDefaultBorder(_ button: UIButton){
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        button.setTitleColor(UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1), for: .normal)
    }
    // DropDown UI 커스텀
    func initUI() {
        // DropDown View의 배경
        noHouseDropView.layer.cornerRadius = 8
        noHouseDropView.layer.borderWidth = 1
        noHouseDropView.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        
        joinAccountDropView.layer.cornerRadius = 8
        joinAccountDropView.layer.borderWidth = 1
        joinAccountDropView.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        
        moneyAmountDropView.layer.cornerRadius = 8
        moneyAmountDropView.layer.borderWidth = 1
        moneyAmountDropView.layer.borderColor = UIColor(red: 0.837, green: 0.837, blue: 0.837, alpha: 1).cgColor
        
        DropDown.appearance().textColor = UIColor(named: "8Fgrey") ?? .gray // 아이템 텍스트 색상
        DropDown.appearance().textFont = UIFont(name: "Pretendard-Medium", size: 15)!
        DropDown.appearance().selectedTextColor = UIColor(named: "HousingBlue") ?? .blue // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.white // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        
        noHouseDropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        joinAccountDropdown.dismissMode = .automatic
        moneyAmountDropdown.dismissMode = .automatic
                    
    }
    
    func setDropdown() {
        noHouseDropdown.dataSource = noHouseItemList // dataSource로 ItemList를 연결
        noHouseDropdown.anchorView = self.noHouseDropView // anchorView를 통해 UI와 연결
        noHouseDropdown.bottomOffset = CGPoint(x: 0, y: noHouseDropView.bounds.height)// View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        
        
        joinAccountDropdown.dataSource = joinAccountItemList
        joinAccountDropdown.anchorView = self.noHouseDropView
        joinAccountDropdown.bottomOffset = CGPoint(x: 0, y: noHouseDropView.bounds.height)
        
        moneyAmountDropdown.dataSource = moneyAmountItemList
        moneyAmountDropdown.anchorView = self.noHouseDropView
        moneyAmountDropdown.bottomOffset = CGPoint(x: 0, y: noHouseDropView.bounds.height)

        
        noHouseDropdown.selectionAction = { [weak self] (index, item) in // Item 선택 시 처리
            self!.noHousePeriodLabel.text = item
            self!.havingNoHousePeriod = item
            self!.noHouseDropBtn.setImage(UIImage(named: "down"), for: .normal)
            self!.setSubmitBtn()


        }
        noHouseDropdown.cancelAction = { [weak self] in // 취소 시 처리
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self!.noHouseDropBtn.setImage(UIImage(named: "down"), for: .normal)
        }
        
        
        joinAccountDropdown.selectionAction = { [weak self] (index, item) in
            self!.joinAccountPeriodLabel.text = item
            self!.joinAccountPeriod = item
            self!.joinAccountDropBtn.setImage(UIImage(named: "down"), for: .normal)
            self!.setSubmitBtn()

        }
        joinAccountDropdown.cancelAction = { [weak self] in
            self!.joinAccountDropBtn.setImage(UIImage(named: "down"), for: .normal)
        }
        
        
        moneyAmountDropdown.selectionAction = { [weak self] (index, item) in // Item 선택 시 처리
            self!.moneyAmountLabel.text = item
            self!.moneyAmmount = item
            self!.moneyAmountDropBtn.setImage(UIImage(named: "down"), for: .normal)
            self!.setSubmitBtn()
        }
        moneyAmountDropdown.cancelAction = { [weak self] in // 취소 시 처리
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
            self!.moneyAmountDropBtn.setImage(UIImage(named: "down"), for: .normal)
        }
    }
    
    @IBAction func noHouseDropdownClicked(_ sender: Any) {
        noHouseDropdown.show()
        self.noHouseDropBtn.setImage(UIImage(named: "up"), for: .normal)
    }
    
    @IBAction func joinAccountDropdownClicked(_ sender: Any) {
        joinAccountDropdown.show()
        self.joinAccountDropBtn.setImage(UIImage(named: "up"), for: .normal)
    }
    
    
    @IBAction func moneyAmountDropdownClicked(_ sender: Any) {
        moneyAmountDropdown.show()
        self.moneyAmountDropBtn.setImage(UIImage(named: "up"), for: .normal)
    }
    
    func setSubmitBtn(){
        if(age != "" && identity != "" && familyNumber != "" && havingNoHousePeriod != "" && joinAccountPeriod != "" && moneyAmmount != ""){
            submitBtn.layer.backgroundColor = UIColor(red: 0.247, green: 0.51, blue: 0.969, alpha: 1).cgColor
            submitBtn.setTitleColor(.white, for: .normal)
            submitBtn.isEnabled = true
        }else{
            submitBtn.layer.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1).cgColor
            submitBtn.setTitleColor(UIColor(red: 0.613, green: 0.613, blue: 0.613, alpha: 1), for: .normal)
            submitBtn.isEnabled = false

        }
    }
    
    @IBAction func submitBtnDidTap(_ sender: Any) {
        let sb = UIStoryboard(name: "Subscription", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectingLocalConditionVC") as! SelectingLocalConditionVC
        vc.subscriptionInfo = SubscriptionCondition(adr_do: "", recruit_date: monthAgoDate(), age: age, position: identity, family: familyNumber, no_house_period: havingNoHousePeriod, account_period: joinAccountPeriod, account_money: moneyAmmount, house_around: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func monthAgoDate() -> String{
        // 현재 날짜 가져오기
        let currentDate = Date()

        // Calendar 인스턴스 생성
        let calendar = Calendar.current

        // 한 달 전의 DateComponents 생성
        var oneMonthAgoComponents = DateComponents()
        oneMonthAgoComponents.month = -1

        // 현재 날짜에서 한 달 전의 날짜 계산
        if let oneMonthAgoDate = calendar.date(byAdding: oneMonthAgoComponents, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 날짜 형식을 원하는 형식으로 변경
            let oneMonthAgoDateString = dateFormatter.string(from: oneMonthAgoDate)
            print("한 달 전 날짜: \(oneMonthAgoDateString)")
            return oneMonthAgoDateString

        } else {
            print("날짜 계산 실패")
            return ""
        }
    }
    
}
