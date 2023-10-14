//
//  SubscriptionResultViewController.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/09.
//

import UIKit
import SafariServices

class SubscriptionResultViewController: UIViewController {
    var hitProb: Int = 0
    var subscriptionInfo: SubscriptionCondition = SubscriptionCondition(adr_do: "", recruit_date: "", age: "", position: "", family: "", no_house_period: "", account_period: "", account_money: "", house_around: "")
    var url: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultView.layer.cornerRadius = 8
        resultView.layer.borderWidth = 0.5
        resultView.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        
        resultView.clipsToBounds = true
        
        highLabel.layer.borderWidth = 0.5
        highLabel.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        
        confirmBtn.layer.cornerRadius = 12

        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        // LoadingView의 제약 조건 설정
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        API.shared.getSubscriptionRecommend(subscriptionInfo) { result in
                    switch result {
                    case .success(let response):
                        // API 요청이 성공했을 때, response를 처리
                        print("성공: \(response)")
                        
                        self.nameLabel.text = response.result?.data[0].houseNm
                        let houseDtlSecdNm = response.result?.data[0].houseDtlSecdNm ?? ""
                        let houseSecdNm = response.result?.data[0].houseSecdNm ?? ""
                        let subscrptAreaCodeNm = response.result?.data[0].subscrptAreaCodeNm ?? ""
                       
                        self.infoLabel.text = houseDtlSecdNm + " / " + houseSecdNm + " / " + subscrptAreaCodeNm
                        self.locationLabel.text = response.result?.data[0].hssplyAdres
                        self.totalSupplyLabel.text = "분양세대: " + String(response.result?.data[0].totSuplyHshldco ?? 0) + " 세대"
                        self.url = response.result?.data[0].pblancURL ?? ""
                        self.showHitProb(prob: response.probability ?? "하")
                        
                        loadingView.fadeOut(duration: 0.5)
                    case .failure(let error):
                        // API 요청이 실패했을 때, error를 처리
                        print("실패: \(error)")
                        self.nameLabel.text = "청약 정보를 찾지 못했습니다"
                        loadingView.fadeOut(duration: 0.5)

                        // 에러를 사용하여 에러 처리 로직을 추가할 수 있습니다.
                    }
                }
        
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var totalSupplyLabel: UILabel!
    
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var veryHighLabel: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    
    @IBAction func nextBtnDidTap(_ sender: Any) {
        let infoURL = NSURL(string: url)
        let safariView: SFSafariViewController = SFSafariViewController(url: infoURL! as URL)
        self.present(safariView, animated: true)
        
    }
    
    
    func showHitProb(prob: String){
        normalLabel.clipsToBounds = true
        highLabel.clipsToBounds = true
        veryHighLabel.clipsToBounds = true
        
        switch prob {
        case "하":
            normalLabel.backgroundColor = UIColor(red: 0.975, green: 0.736, blue: 0.041, alpha: 1)
            normalLabel.textColor = .white
        case "중":
            highLabel.backgroundColor = UIColor(red: 0.975, green: 0.601, blue: 0.041, alpha: 1)
            highLabel.textColor = .white
        case "상":
            veryHighLabel.backgroundColor = UIColor(red: 0.975, green: 0.377, blue: 0.041, alpha: 1)
            veryHighLabel.textColor = .white
        default:
            normalLabel.backgroundColor = UIColor(red: 0.975, green: 0.377, blue: 0.041, alpha: 1)
            normalLabel.textColor = .white
        }
    }
    
    @IBAction func confirmBtnDidTap(_ sender: Any) {
        let newRootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "firstVC")
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        window.rootViewController = newRootViewController
        
        window.makeKeyAndVisible()
    }

}
