//
//  mapDetailCont.swift
//  Hows-ing
//
//  Created by 김민경 on 10/8/23.
//

import UIKit
import Foundation
import Charts
import DGCharts
import SwiftUI
import Kingfisher

class mapDetailCont: UIViewController {
    
    var divCode: String = ""
//    var IdentiNum: IdentiNum?
    
    var errorMsg: String = "출력 데이터가 없습니다."
    
    var selectedInt: Int?
    
    // 이름
    @IBOutlet weak var nameText: UILabel!
    
    // 주소
    @IBOutlet weak var addressText: UILabel!
    
    
    
    // 방수/ 화장실수 혹은 총동수 / 총 세대수
    @IBOutlet weak var countType: UILabel!
    
    // 종류
    @IBOutlet weak var typeText: UILabel!
    
    // 전용/공급면적
    @IBOutlet weak var areaText: UILabel!
    
    // 방 수/ 화장실 수
    @IBOutlet weak var roomCnt: UILabel!
    
    // 입주가능일
    @IBOutlet weak var goDate: UILabel!
    
    // 평면도 / 단지사진
    @IBOutlet weak var imageFile: UIImageView!
    
    // 중개업소 이름
    @IBOutlet weak var agencyName: UILabel!
    
    // 사무실 전화번호
    @IBOutlet weak var officeCall: UILabel!
    
    // 뒤로가기 버튼
    @IBOutlet weak var backBtn: UIButton!
    
    // 부동산 이름
    @IBOutlet weak var nameLabel: UILabel!
    
    // 뒤로가기 버튼 클릭했을 때
    @IBAction func backDidTap(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // 매매가 view
    @IBOutlet weak var thirdView: UIView!
    
    // 월세가 view
    @IBOutlet weak var allView: UIView!
    
    // 전세가 view
    @IBOutlet weak var JeonseView: UIView!
    
    // 전세가 버튼
    @IBOutlet weak var Jeonse: UIButton!
    
    // 매매가 버튼
    @IBOutlet weak var thirdBtn: UIButton!
    
    // 월세가 버튼
    @IBOutlet weak var allBtn: UIButton!
    
    // 차트 view
    @IBOutlet weak var chartView: BarChartView!
    
    let bottomBorder1 = CALayer()
    let bottomBorder2 = CALayer()
    let bottomBorder3 = CALayer()
    let borderWidth1: CGFloat = 1.2 // 테두리 두께 설정
    let borderWidth2: CGFloat = 1.0 // 테두리 두께 설정
    let borderWidth3: CGFloat = 1.0 // 테두리 두께 설정
    
    let api = MapDetailServerAPI()
    
    // 구분값
    var dayData: [String] = []
    // 데이터
    var priceData: [Double]! = []
    
    
    // 매매가 btn did tap
    @IBAction func btn1(_ sender: Any) {
        
        
        
        if(divCode == "sale") {
            // 서버에서 데이터 가져오기
            api.getMapDetail(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    // 차트 초기화
                    self.chartView.clear()
                    self.chartView.notifyDataSetChanged()
                    self.chartView.data = nil
                    
                    self.dayData = ["최소", "일반", "최대"]
                    self.priceData = [Double(mapDetail.result.saleMinPrice), Double(mapDetail.result.saleGenPrice), Double(mapDetail.result.saleMaxPrice)]
                    
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarData(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                }
            }
        }
        
        else {
            api.getMapDetailMarket(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                print(mapDetail)
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    // 차트 초기화
                    self.dayData = []
                    self.priceData = []
                    
                    self.chartView.clear()
                    self.chartView.notifyDataSetChanged()
                    self.chartView.data = nil

                    // mapDetail.result.data 배열의 요소 개수만큼 반복합니다.
                    for data in mapDetail.result.data {
                        // 각 data의 dediArea를 dayData에 추가합니다.
                        self.dayData.append(String(data.dediArea) + "m²")
                        
                        // 각 data의 saleGenPrice를 priceData에 추가합니다.
                        self.priceData.append(data.saleGenPrice)
                    }
               
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarDataMax(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                }
            }
        }
       
        
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder1)
        
        // 월세가 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder2)
        
        // 전세가 view
        // CALayer 생성 및 설정
        bottomBorder3.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder3.borderWidth = borderWidth3
        
        // 테두리 위치 설정 (하단)
        bottomBorder3.frame = CGRect(x: 0, y: JeonseView.frame.size.height - borderWidth3, width: JeonseView.frame.size.width, height: borderWidth3)
        
        // CALayer를 UIView의 레이어에 추가
        JeonseView.layer.addSublayer(bottomBorder3)
        
        thirdBtn.tintColor =  UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        allBtn.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
        Jeonse.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
    }
    
    // 월세가 btn did tap
    @IBAction func btn2(_ sender: Any) {
        
        if(divCode=="sale") {
            // 서버에서 데이터 가져오기
            api.getMapDetail(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    // 차트 초기화
                    self.chartView.clear()
                    self.chartView.notifyDataSetChanged()
                    self.chartView.data = nil
                    
                    self.dayData = ["총액", "보증금", "월세"]
                    self.priceData = [Double(mapDetail.result.monthlyTotalPrice), Double(mapDetail.result.monthlyDepositPrice), Double(mapDetail.result.monthlyPrice)]
                    
                    if(Double(mapDetail.result.monthlyTotalPrice) != 0 && Double(mapDetail.result.monthlyDepositPrice) != 0 && Double(mapDetail.result.monthlyPrice) != 0) {
                        // 차트 view
                        self.chartView.noDataText = self.errorMsg
                        self.chartView.noDataFont = .systemFont(ofSize: 20)
                        self.chartView.noDataTextColor = .lightGray
                        self.chartView.backgroundColor = .white
                        
                        // 구분값 보이기
                        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                        // 구분값 모두 보이기
                        self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                        // 생성한 함수 사용해서 데이터 적용
                        self.setBarData(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                        // 데이터 범례 삭제
                        self.chartView.legend.enabled = false
                        
                        self.chartView.notifyDataSetChanged()
                        self.chartView.invalidateIntrinsicContentSize()
                    }
                    
                }
            }
        }
        
        else {
            api.getMapDetailMarket(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                print(mapDetail)
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    self.dayData = []
                    self.priceData = []

                    
                    // 차트 초기화
                    self.chartView.clear()
                    self.chartView.notifyDataSetChanged()
                    self.chartView.data = nil

                    // mapDetail.result.data 배열의 요소 개수만큼 반복합니다.
                    
                    for data in mapDetail.result.data {
                        // 각 data의 dediArea를 dayData에 추가합니다.
                        self.dayData.append(String(data.dediArea) + "m²")
                        
                        if(data.monthlyPrice=="") {
                            return
                        }
                        
                        // 각 data의 saleGenPrice를 priceData에 추가합니다.
                        self.priceData.append(Double(data.monthlyPrice) ?? 0)
                    }
                    
               
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarDataMax(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                }
            }
        }
        
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder1)
        
        // 월세가 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder2)
        
        // 전세가 view
        // CALayer 생성 및 설정
        bottomBorder3.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder3.borderWidth = borderWidth3
        
        // 테두리 위치 설정 (하단)
        bottomBorder3.frame = CGRect(x: 0, y: JeonseView.frame.size.height - borderWidth3, width: JeonseView.frame.size.width, height: borderWidth3)
        
        // CALayer를 UIView의 레이어에 추가
        JeonseView.layer.addSublayer(bottomBorder3)
        
        allBtn.tintColor =  UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        thirdBtn.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
        Jeonse.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
    }
    
    // 전세가 btn did tap
    @IBAction func btn3(_ sender: Any) {
        
        if(divCode=="sale") {
            // 서버에서 데이터 가져오기
            api.getMapDetail(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    // 차트 초기화
                    self.chartView.clear()
                    self.chartView.notifyDataSetChanged()
                    self.chartView.data = nil
                    
                    self.dayData = ["최소", "일반", "최대"]
                    self.priceData = [Double(mapDetail.result.junsaeMinPrice), Double(mapDetail.result.junsaeGenPrice), Double(mapDetail.result.junsaeMaxPrice)]
                    
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarData(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                    
                }
            }
        }
        else {
            api.getMapDetailMarket(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                print(mapDetail)
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    self.dayData = []
                    self.priceData = []

                    
                    // 차트 초기화
                    self.chartView.clear()
                    self.chartView.notifyDataSetChanged()
                    self.chartView.data = nil

                    // mapDetail.result.data 배열의 요소 개수만큼 반복합니다.
                    for data in mapDetail.result.data {
                        // 각 data의 dediArea를 dayData에 추가합니다.
                        self.dayData.append(String(data.dediArea) + "m²")
                        
                        if(data.junsaeGenPrice==0) {
                            return
                        }
                        
                        // 각 data의 saleGenPrice를 priceData에 추가합니다.
                        self.priceData.append(data.junsaeGenPrice)
                    }
               
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarDataMax(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                }
            }
        }
        
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder1)
        
        // 월세가 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder2)
        
        // 전세가 view
        // CALayer 생성 및 설정
        bottomBorder3.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder3.borderWidth = borderWidth3
        
        // 테두리 위치 설정 (하단)
        bottomBorder3.frame = CGRect(x: 0, y: JeonseView.frame.size.height - borderWidth3, width: JeonseView.frame.size.width, height: borderWidth3)
        
        // CALayer를 UIView의 레이어에 추가
        JeonseView.layer.addSublayer(bottomBorder3)
        
        Jeonse.tintColor =  UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        thirdBtn.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
        allBtn.tintColor =  UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
    }
    
    // URL에서 이미지를 로드하여 이미지 뷰에 설정
    private func loadImage(from url: URL, to imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                // 이미지 로드 실패 시 기본 이미지 설정
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "noImage")
                }
            }
        }.resume()
    }
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        print(divCode)
//        print(IdentiNum!)
        
        if(divCode=="sale") {
            // 서버에서 데이터 가져오기
            api.getMapDetail(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                print(mapDetail)
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    self.dayData = ["최소", "일반", "최대"]
                    self.priceData = [Double(mapDetail.result.saleMinPrice), Double(mapDetail.result.saleGenPrice), Double(mapDetail.result.saleMaxPrice)]
               
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarData(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                    
                    self.nameText.text = mapDetail.result.name
                    self.addressText.text = mapDetail.result.address
                    self.typeText.text = mapDetail.result.groupName
                    let areaText = "\(mapDetail.result.dediArea)m² / \(mapDetail.result.supplyArea)m²"
                    self.areaText.text = areaText
                    let roomCountText = "\(mapDetail.result.roomCount)개 / \(mapDetail.result.toiletCount)개"
                    self.roomCnt.text = roomCountText
                    self.goDate.text = mapDetail.result.moveAvailDate
                    if(mapDetail.result.moveAvailDate.isEmpty) {
                        self.goDate.text = "-"
                    }
                    
                    if let imageURL = URL(string: mapDetail.result.image) {
                        let placeholderImage = UIImage(named: "noImage")
                        self.imageFile.kf.setImage(with: imageURL, placeholder: placeholderImage)
                    } else {
                        // 잘못된 URL 처리
                        self.imageFile.image = UIImage(named: "noImage")
                    }
                    
                    self.agencyName.text = mapDetail.result.agencyName
                    if(mapDetail.result.agencyName.isEmpty) {
                        self.agencyName.text = "-"
                    }
                    self.officeCall.text = mapDetail.result.agencyTel
                    if(mapDetail.result.agencyTel.isEmpty) {
                        self.officeCall.text = "-"
                    }
                }
            }
        }
        
        
        // 서버에서 데이터 가져오기
        if(divCode=="market") {
            api.getMapDetailMarket(divCode: divCode) { [weak self] mapDetail in
                guard let self = self, let mapDetail = mapDetail else {
                    return
                }
                
                print(mapDetail)
                
                // divCode가 sale일때
                DispatchQueue.main.async {
                    self.dayData = []
                    self.priceData = []

                    // mapDetail.result.data 배열의 요소 개수만큼 반복합니다.
                    for data in mapDetail.result.data {
                        // 각 data의 dediArea를 dayData에 추가합니다.
                        self.dayData.append(String(data.dediArea) + "m²")
                        
                        // 각 data의 saleGenPrice를 priceData에 추가합니다.
                        self.priceData.append(data.saleGenPrice)
                    }
               
                    // 차트 view
                    self.chartView.noDataText = self.errorMsg
                    self.chartView.noDataFont = .systemFont(ofSize: 20)
                    self.chartView.noDataTextColor = .lightGray
                    self.chartView.backgroundColor = .white
                    
                    // 구분값 보이기
                    self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayData)
                    // 구분값 모두 보이기
                    self.chartView.xAxis.setLabelCount(self.priceData.count, force: false)
                    // 생성한 함수 사용해서 데이터 적용
                    self.setBarDataMax(barChartView: self.chartView, barChartDataEntries: self.entryData(values: self.priceData))
                    // 데이터 범례 삭제
                    self.chartView.legend.enabled = false
                    
                    self.chartView.notifyDataSetChanged()
                    self.chartView.invalidateIntrinsicContentSize()
                    
                    // 이름
                    self.nameText.text = mapDetail.result.name
                    // 주소
                    self.addressText.text = mapDetail.result.address
                    // 종류
                    self.typeText.text = mapDetail.result.groupName
                    // 전용 / 공급면적
                    self.countType.text = "총동수 / 총세대수"
                    
                    let areaText = "\(mapDetail.result.data[0].dediArea)m² / -"
                    
                    self.areaText.text = areaText
                    // 총동수 / 총세대수
                    let roomCountText = "\(mapDetail.result.totalDongSu)개 / \(mapDetail.result.totalSaedaesu)개"
                    self.roomCnt.text = roomCountText
                    // 입주 가능일
                    self.goDate.text = "-"
                    
                    if let imageURL = URL(string: mapDetail.result.image) {
                        let placeholderImage = UIImage(named: "noImage")
                        self.imageFile.kf.setImage(with: imageURL, placeholder: placeholderImage)
                    } else {
                        // 잘못된 URL 처리
                        self.imageFile.image = UIImage(named: "noImage")
                    }
                    
                    // 부동산
                    self.agencyName.text = "-"
                    // 사무실 번호
                    self.officeCall.text = "-"
                    
                }
            }
        }
        
        // 매매가 view
        // CALayer 생성 및 설정
        bottomBorder1.borderColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1).cgColor
        bottomBorder1.borderWidth = borderWidth1
        
        // 테두리 위치 설정 (하단)
        bottomBorder1.frame = CGRect(x: 0, y: thirdView.frame.size.height - borderWidth1, width: thirdView.frame.size.width, height: borderWidth1)
        
        // CALayer를 UIView의 레이어에 추가
        thirdView.layer.addSublayer(bottomBorder1)
        
        // 월세가 view
        // CALayer 생성 및 설정
        bottomBorder2.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder2.borderWidth = borderWidth2
        
        // 테두리 위치 설정 (하단)
        bottomBorder2.frame = CGRect(x: 0, y: allView.frame.size.height - borderWidth2, width: allView.frame.size.width, height: borderWidth2)
        
        // CALayer를 UIView의 레이어에 추가
        allView.layer.addSublayer(bottomBorder2)
        
        // 전세가 view
        // CALayer 생성 및 설정
        bottomBorder3.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1).cgColor
        bottomBorder3.borderWidth = borderWidth3
        
        // 테두리 위치 설정 (하단)
        bottomBorder3.frame = CGRect(x: 0, y: JeonseView.frame.size.height - borderWidth3, width: JeonseView.frame.size.width, height: borderWidth3)
        
        // CALayer를 UIView의 레이어에 추가
        JeonseView.layer.addSublayer(bottomBorder3)
        
    }
    
    // 데이터셋 만들고 차트에 적용하기
    func setBarData(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        // 글씨 색상
        let customColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        let customFont = UIFont(name: "Pretendard-Bold", size: 14)
        
        // 색상 배열
        let colors: [UIColor] = [
            UIColor(red: 166/255, green: 198/255, blue: 253/255, alpha: 1),
            UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        ]

        // X 축 설정
        let xAxis = barChartView.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.labelFont = UIFont(name: "Pretendard-Bold", size: 16)!
        xAxis.labelTextColor = customColor

        // Y 축 설정
        let leftAxis = barChartView.leftAxis
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false

        let rightAxis = barChartView.rightAxis
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false

        // 데이터 셋 만들기
        var barDataSets: [BarChartDataSet] = []

        for (index, dataEntry) in barChartDataEntries.enumerated() {
            let dataSet = BarChartDataSet(entries: [dataEntry], label: "")
            dataSet.colors = [colors[index % colors.count]] // 색상 번갈아가며 설정
            dataSet.valueFont = UIFont(name: "Pretendard-Bold", size: 16)!
            dataSet.valueTextColor = NSUIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
            barDataSets.append(dataSet)
        }

        // 차트 데이터 만들기
        let barChartData = BarChartData(dataSets: barDataSets)

        // x-축 레이블 위치를 아래로 설정
        barChartView.xAxis.labelPosition = .bottom

        // 데이터 차트에 적용
        barChartView.data = barChartData
        
    }
    
    // 데이터셋 만들고 차트에 적용하기
    func setBarDataMax(barChartView: BarChartView, barChartDataEntries: [BarChartDataEntry]) {
        // 글씨 색상
        let customColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        let customFont = UIFont(name: "Pretendard-Bold", size: 10)
        
        // 색상 배열
        let colors: [UIColor] = [
            UIColor(red: 166/255, green: 198/255, blue: 253/255, alpha: 1),
            UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
        ]

        // X 축 설정
        let xAxis = barChartView.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.labelFont = customFont!
        xAxis.labelTextColor = customColor

        // Y 축 설정
        let leftAxis = barChartView.leftAxis
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false

        let rightAxis = barChartView.rightAxis
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false

        // 데이터 셋 만들기
        var barDataSets: [BarChartDataSet] = []

        for (index, dataEntry) in barChartDataEntries.enumerated() {
            let dataSet = BarChartDataSet(entries: [dataEntry], label: "")
            dataSet.colors = [colors[index % colors.count]] // 색상 번갈아가며 설정
            dataSet.valueFont = customFont!
            dataSet.valueTextColor = NSUIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
            barDataSets.append(dataSet)
        }

        // 차트 데이터 만들기
        let barChartData = BarChartData(dataSets: barDataSets)

        // x-축 레이블 위치를 아래로 설정
        barChartView.xAxis.labelPosition = .bottom

        // 데이터 차트에 적용
        barChartView.data = barChartData
        
    }
    
    // entry 만들기
    func entryData(values: [Double]) -> [BarChartDataEntry] {
        // 엔트리들 만들기
        var barDataEntries: [BarChartDataEntry] = []
        // 데이터 값 만큼 엔트리 생성
        for i in 0 ..< values.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            barDataEntries.append(barDataEntry)
        }
        // 엔트리들 반환
        return barDataEntries
    }
    
}



class MapDetailServerAPI {
    let apiUrlString = "https://2715928430.for-seoul.synctreengine.com/map-detail"
    
    func getMapDetail(divCode: String, completion: @escaping (MapGetDetail?) -> Void) {
        guard let url = URL(string: apiUrlString) else {
            completion(nil)
            return
        }
        
        // 요청 데이터 준비
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "div_code": divCode,
//            "identi_num": identiNum
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request: \(error)")
            completion(nil)
            return
        }
        
        // API 호출
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let mapGetDetail = try JSONDecoder().decode(MapGetDetail.self, from: data)
                completion(mapGetDetail)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func getMapDetailMarket(divCode: String, completion: @escaping (MapGetDetailMarket?) -> Void) {
        guard let url = URL(string: apiUrlString) else {
            completion(nil)
            return
        }
        
        // 요청 데이터 준비
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "div_code": divCode,
//            "identi_num": identiNum
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request: \(error)")
            completion(nil)
            return
        }
        
        // API 호출
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let mapGetDetailMarket = try JSONDecoder().decode(MapGetDetailMarket.self, from: data)
                completion(mapGetDetailMarket)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }.resume()
    }
}


