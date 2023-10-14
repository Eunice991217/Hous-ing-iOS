import UIKit
import NMapsMap
import CoreLocation

class mapCont: UIViewController, CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    
    var currentLocation:CLLocationCoordinate2D!
    var findLocation:CLLocation!
    let geocoder = CLGeocoder()
    
    var longitude_HVC = 0.0
    var latitude_HVC = 0.0
    
    var isToggled = false
    var infoView: UIView?

    @IBOutlet weak var mapView: NMFMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15.0)
        mapView.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn
        
        let new_marker = NMFMarker()
        
        let storyboard: UIStoryboard? = UIStoryboard(name: "realEstate", bundle: Bundle.main)
        guard let mapDetailCont = storyboard?.instantiateViewController(identifier: "mapDetailCont") else {
            return
        }
        mapDetailCont.modalPresentationStyle = .overFullScreen
        mapDetailCont.modalTransitionStyle = .crossDissolve
        
        // 마커 위치
        new_marker.position = NMGLatLng(lat: latitude, lng:longitude)
        new_marker.iconImage = NMFOverlayImage(name: "markerIcon")
        
        new_marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
            guard let self = self else { return false }
            
            // 토글 상태 변경
            self.isToggled.toggle()
            
            // 토글 상태에 따라 이미지 변경
            if self.isToggled {
                new_marker.iconImage = NMFOverlayImage(name: "markerDidTap")
                
                let viewWidth: CGFloat = 60
                let viewHeight: CGFloat = 50
                let markerPosition = self.mapView.projection.point(from: new_marker.position)
                
                // 이미지 뷰 생성
                let imageView = UIImageView(image: UIImage(named: "markerView"))
                imageView.frame = CGRect(x: markerPosition.x - (viewWidth / 2), y: markerPosition.y - viewHeight - 80, width: viewWidth, height: viewHeight)
                
                // StackView 생성 및 설정
                let stackView = UIStackView()
                stackView.axis = .vertical // 수직으로 배치
                stackView.alignment = .center // 중앙 정렬
                stackView.distribution = .fill // 두 레이블 사이에 공간을 균등하게 분배
                stackView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
                stackView.isLayoutMarginsRelativeArrangement = true
                
                // 첫 번째 레이블 (label1)
                let label1 = UILabel()
                label1.text = "13평"
                label1.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
                label1.textAlignment = .center
                label1.font = UIFont(name: "Pretendard-Bold", size: 12)
                stackView.addArrangedSubview(label1) // StackView에 추가

                // 두 번째 레이블 (label2)
                let label2 = UILabel()
                label2.text = "1.3억"
                label2.textColor = UIColor(red: 63/255, green: 130/255, blue: 247/255, alpha: 1)
                label2.textAlignment = .center
                label2.font = UIFont(name: "Pretendard-Bold", size: 15)
                stackView.addArrangedSubview(label2) // StackView에 추가

                // StackView의 크기 및 위치 설정
                stackView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
//                stackView.spacing = 5 // 레이블 사이의 간격 설정

                // 나머지 코드 (레이블 추가 등)
                self.infoView = imageView
                
                // 뷰에 StackView 추가
                imageView.addSubview(stackView)
                
                // 뷰를 지도에 추가
                self.mapView.addSubview(imageView)
                
                if let mapDetailCont = mapDetailCont as? mapDetailCont {
                    self.present(mapDetailCont, animated: true)
                }
                
            } else {
                new_marker.iconImage = NMFOverlayImage(name: "markerIcon")
                // 이미 뷰가 표시 중이면 숨김
                self.infoView?.removeFromSuperview()
            }
            
            return true
        }

        new_marker.mapView = mapView
        
        print(latitude)
        print(longitude)
        
        // Do any additional setup after loading the view.
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
