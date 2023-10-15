import UIKit
import NMapsMap
import CoreLocation
import Kingfisher

class mapCont: UIViewController, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var TabbarView: UIView!
    @IBOutlet weak var PaperIcon:  UIImageView!
    @IBOutlet weak var HomeIcon: UIImageView!
    
    @IBOutlet weak var paperView: UIView!
    
    
    @IBOutlet weak var homeView: UIView!
    
    
    @IBOutlet weak var PaperText: UILabel!
    @IBOutlet weak var HomeText: UILabel!
    
    let pageLock = NSLock()
    var tapNum: Int = 1
    
    var mapDivCode: String?
    var mapIdentiNum: IdentiNum?
    
    var locationManager = CLLocationManager()
    
    var currentLocation:CLLocationCoordinate2D!
    var findLocation:CLLocation!
    let geocoder = CLGeocoder()
    
    var longitude_HVC = 0.0
    var latitude_HVC = 0.0
    
    var isToggled = false
    
    // 노고산동 아이비타워 오피스텔
    @IBOutlet weak var houseName: UILabel!
    
    // 광고글
    @IBOutlet weak var advertiseString: UILabel!
    
    // 단지 이미지
    @IBOutlet weak var basicImage: UIImageView!
    
    // 종류 아이콘
    @IBOutlet weak var typeIcon: UIImageView!
    
    // 가격
    @IBOutlet weak var price: UILabel!
    
    // 매매, 전세, 월세 구분
    @IBOutlet weak var priceType: UILabel!
    
    // 상세정보 view
    @IBOutlet weak var detailView: UIView!
    
    // 종류 문자열
    @IBOutlet weak var typeText: UILabel!
    
    // 자세히 보기 버튼
    @IBOutlet weak var goDetail: UIButton!
    
    // 자세히 보기 클릭
    @IBAction func goDetailDidTap(_ sender: Any) {
        if let mapDetailCont = self.storyboard!.instantiateViewController(identifier: "mapDetailController") as? mapDetailCont {
            mapDetailCont.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            
            mapDetailCont.divCode = mapDivCode ?? "sale"
//            mapDetailCont.IdentiNum = mapIdentiNum

            self.present(mapDetailCont, animated: true)
        }
    }
    
    
    @IBOutlet weak var mapView: NMFMapView!
    
    @objc func handleHomeTap(_ sender: UITapGestureRecognizer) {
        print("부동산 클릭했을때")
        
        if tapNum == 1 {
            return
        }
        self.pageLock.lock()
        defer { self.pageLock.unlock() }
        PaperIcon.image = UIImage(named: "PaperIcon")
        HomeIcon.image = UIImage(named: "HomeSelect")
        PaperText.textColor = UIColor(named: "HousingGray")
        HomeText.textColor = UIColor(named: "HousingBlue")
        tapNum = 1
    }
    
    @objc func handlePaperTap(_ sender: UITapGestureRecognizer) {
        print("청약 클릭했을때")
        
        if tapNum == 0 {
            return
        }
        self.pageLock.lock()
        defer { self.pageLock.unlock() }
        PaperIcon.image = UIImage(named: "PaperSelect")
        HomeIcon.image = UIImage(named: "HomeIcon")
        PaperText.textColor = UIColor(named: "HousingBlue")
        HomeText.textColor = UIColor(named: "HousingGray")
        tapNum = 0
    }
    
    @IBAction func PaperButtonTap(_ sender: Any) {
        if tapNum == 0 {
            return
        }
        self.pageLock.lock()
        defer { self.pageLock.unlock() }
        PaperIcon.image = UIImage(named: "PaperSelect")
        HomeIcon.image = UIImage(named: "HomeIcon")
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
        PaperIcon.image = UIImage(named: "PaperIcon")
        HomeIcon.image = UIImage(named: "HomeSelect")
        PaperText.textColor = UIColor(named: "HousingGray")
        HomeText.textColor = UIColor(named: "HousingBlue")
        tapNum = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 부동산 버튼 클릭했을 때
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(handleHomeTap(_:)))

        // 부동산 클릭 func 추가
        homeView.addGestureRecognizer(tapGestureRecognizer2)
        
        // 청약 버튼 클릭했을 때
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(handlePaperTap(_:)))
        
        // 청약 클릭 func 추가
        paperView.addGestureRecognizer(tapGestureRecognizer3)
        
        TabbarView.layer.cornerRadius = 40
        TabbarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        TabbarView.layer.shadowOffset = CGSize(width: 0, height: 4)
        TabbarView.layer.shadowColor = UIColor.black.cgColor
        TabbarView.layer.shadowOpacity = 0.2
        TabbarView.layer.shadowRadius = 24 / UIScreen.main.scale
        
        detailView.isHidden = true
        
        detailView.layer.cornerRadius = 40
        detailView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        mapView.allowsZooming = true // 줌 가능
        mapView.allowsScrolling = true // 스크롤 가능
        
        // zoom level 지정
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 18.0
        
        // delegate 설정
        locationManager.delegate = self
        // 사용자에게 허용 받기 alert 띄우기
        self.locationManager.requestWhenInUseAuthorization()
        requestAuthorization()
        
        // 내 위치 가져오기
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // 위도, 경도 가져오기
        let latitude = locationManager.location?.coordinate.latitude ?? 0
        let longitude = locationManager.location?.coordinate.longitude ?? 0
        
        // 카메라 맞추기
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 12.0)
        mapView.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn
        
        // MapServerAPI 클래스를 인스턴스화하여 API 요청 수행
        _ = MapServerAPI { [weak self] (results) in
            
            guard let self = self else { return }
            
            // 숫자를 한국식 표기법인 "억"과 "천"으로 변환하는 함수
            func convertToKoreanPrice(_ price: Int) -> String {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                
                // 10,000으로 나누어 "억"과 "천"을 표기
                if price >= 10000 {
                    let units = price / 10000
                    let thousands = price % 10000
                    if thousands > 0 {
                        return "\(formatter.string(from: NSNumber(value: units)) ?? "")억 \(formatter.string(from: NSNumber(value: thousands)) ?? "")"
                    } else {
                        return "\(formatter.string(from: NSNumber(value: units)) ?? "")억"
                    }
                } else {
                    return "\(formatter.string(from: NSNumber(value: price)) ?? "")"
                }
            }
            
            DispatchQueue.main.async {
                for result in results {
                    // 결과 데이터를 사용하여 새로운 마커 추가
                    
                    let new_marker = NMFMarker()
                    new_marker.position = NMGLatLng(lat: result.yCoord, lng: result.xCoord)
                    
                    self.typeText.text = result.groupName
                    
                    if(result.groupName == "아파트") {
                        new_marker.iconImage = NMFOverlayImage(name: "apartmentMarkerIcon")
                        self.typeIcon.image = UIImage(named: "appartmentMiniIcon.png")
                    }
                    else if(result.groupName == "오피스텔") {
                        new_marker.iconImage = NMFOverlayImage(name: "OfficetelsMarkerIcon")
                        self.typeIcon.image = UIImage(named: "miniOffictels.png")
                    }
                    else {
                        new_marker.iconImage = NMFOverlayImage(name: "houseMarkerIcon")
                        self.typeIcon.image = UIImage(named: "homeMiniIcon.png")
                    }
                    
                    new_marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                        guard let self = self else { return false }
                        
                        print("마커 클릭 : \(result.divCode), \(result.identiNum)")
                        
                        // 토글 상태 변경
                        self.isToggled.toggle()
                        
                        mapDivCode = result.divCode
                        mapIdentiNum = result.identiNum
                        
                        // 토글 상태에 따라 변경
                        if self.isToggled {
                            self.detailView.isHidden = false
                            
                            // 버튼 클릭했을 때
                            let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))

                            // 버튼 클릭 func 추가
                            detailView.addGestureRecognizer(tapGestureRecognizer1)
                            
                            // market (부동산 단지)
                            if(result.divCode == "market") {
                                
                                houseName.text = result.saleName
                                advertiseString.isHidden = true // 광고 문구가 없음
                                
                                if let imageURL = URL(string: result.imageFile) {
                                    let placeholderImage = UIImage(named: "noImage")
                                    basicImage.kf.setImage(with: imageURL, placeholder: placeholderImage)
                                } else {
                                    // 잘못된 URL 처리
                                    basicImage.image = UIImage(named: "noImage")
                                }

                                if let junsaeMaxPrice = result.junsaeMaxAvgPrice {
                                    price.text = convertToKoreanPrice(junsaeMaxPrice)
                                } else {
                                    // 값이 존재하지 않는 경우에 대한 처리
                                    price.text = "값 없음"
                                }
                                priceType.text = "/ 전세최저가"
                                
                            }
                            // sale (매몰)
                            else {
                                houseName.text = result.saleName
                                
                                if(result.features == nil) {
                                    advertiseString.isHidden = true
                                }
                                advertiseString.text = result.features
                                
                                if let imageURL = URL(string: result.imageFile) {
                                    let placeholderImage = UIImage(named: "noImage")
                                    basicImage.kf.setImage(with: imageURL, placeholder: placeholderImage)
                                } else {
                                    // 잘못된 URL 처리
                                    basicImage.image = UIImage(named: "noImage")
                                }
                            

                                if let monthlyPrice = result.monthlyPrice, monthlyPrice > 0 {
                                    price.text = convertToKoreanPrice(monthlyPrice)
                                    priceType.text = "/ 월세가"
                                } else if let jeonsePrice = result.jeonsePrice, jeonsePrice > 0 {
                                    price.text = convertToKoreanPrice(jeonsePrice)
                                    priceType.text = "/ 전세가"
                                } else if let salePrice = result.salePrice, salePrice > 0 {
                                    price.text = convertToKoreanPrice(salePrice)
                                    priceType.text = "/ 매매가"
                                } else {
                                    // 모든 가격이 0 이하인 경우 또는 값이 없는 경우에 대한 처리
                                    price.text = "가격 정보 없음"
                                    priceType.text = ""
                                }
                            }
                            
                        } else {
                            self.detailView.isHidden = true
                        }
                        return true
                    }
                    
                    new_marker.mapView = self.mapView
                }
            }
        }
    }
    
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        print("view 클릭했을때")
        if let mapDetailCont = self.storyboard!.instantiateViewController(identifier: "mapDetailController") as? mapDetailCont {
            mapDetailCont.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            
            mapDetailCont.divCode = mapDivCode ?? "sale"
//            mapDetailCont.IdentiNum = mapIdentiNum

            self.present(mapDetailCont, animated: true)
        }
    }
    
    private func requestAuthorization() {
        
        //정확도 검사
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //앱 사용할때 권한요청
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            print("restricted n denied")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("권한있음")
            locationManagerDidChangeAuthorization(locationManager)
        default:
            locationManager.startUpdatingLocation()
            print("default")
        }
        
        locationManagerDidChangeAuthorization(locationManager)
        
        if(latitude_HVC == 0.0 || longitude_HVC == 0.0){
            print("위치를 가져올 수 없습니다.")
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            if let currentLocation = locationManager.location?.coordinate{
                print("coordinate")
                longitude_HVC = currentLocation.longitude
                latitude_HVC = currentLocation.latitude
            }
        }
        else{
            print("else")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude_HVC =  location.coordinate.latitude
            longitude_HVC = location.coordinate.longitude
        }
    }
}

class MapServerAPI {
    let apiUrlString = "https://2715928430.for-seoul.synctreengine.com/map"
    
    init(completion: @escaping ([mapResult]) -> Void) {
        if let apiUrl = URL(string: apiUrlString) {
            URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
                if let error = error {
                    print("API 요청 중 오류 발생: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let mapGet = try JSONDecoder().decode(MapGet.self, from: data)
                        let results = mapGet.result
                        
                        // 새로운 결과를 담을 배열 초기화
                        var newResults = [mapResult]()
                        for result in results {
                            newResults.append(result)
                        }

                        completion(newResults) // 새로운 결과 데이터를 전달
                    } catch {
                        print("JSON 파싱 중 오류 발생: \(error)")
                    }
                }
            }.resume()
        } else {
            print("잘못된 URL입니다.")
        }
    }
}
