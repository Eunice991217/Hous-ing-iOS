//
//  SubscriptionInfoViewController.swift
//  Hows-ing
//
//  Created by 황재상 on 10/10/23.
//

import UIKit
import SafariServices

class SubscriptionInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var SubscriptionInfoTableView: UITableView!
    @IBOutlet weak var selectedLocationView: UIView!
    @IBOutlet weak var locationText: UILabel!
    var selectedLocation:[String] = []
    var subscriptionData:[Datum] = []
    var isAvailable: Bool = false
    var page: Int = 1
    var ind: Int = -1
    var locationName: [String] = ["서울", "강원", "대전", "충남","세종", "충북", "인천","경기", "광주", "전남", "전북", "부산", "제주", "대구", "경북"]
    
    @IBAction func locationSelect(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocation") as? SelectLocationViewController else {
            return
        }
        
        vc.infoVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resetLocation(_ sender: Any) {
        ind = -1
        selectedLocationView.alpha = 0
        page = 1
        subscriptionData = []
        dataUpdate()
    }
    
    func locationSelected(){
        if ind == -1{
            return
        }
        
        locationText.text = locationName[ind]
        selectedLocationView.alpha = 1
        page = 1
        subscriptionData = []
        dataUpdate()
    }
    
    func dataUpdate(){
        var queryURL = "https://api.odcloud.kr/api/ApplyhomeInfoDetailSvc/v1/getAPTLttotPblancDetail?page=" + String(page) + "&perPage=10&returnType=JSON&serviceKey=" + GetKey(key: "locationKey")
        if ind != -1{
            queryURL += "&cond%5BSUBSCRPT_AREA_CODE_NM%3A%3AEQ%5D=" + locationName[ind].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        print(queryURL)
        let url = URL(string: queryURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if data == nil{
                print("Err")
                return
            }
            
            guard let output = try? JSONDecoder().decode(SI_rp.self, from: data!) else{
                return
            }
            
            output.data.forEach{
                self.subscriptionData.append($0)
            }
            
            DispatchQueue.main.sync{
                self.SubscriptionInfoTableView.reloadData()
                self.isAvailable = true
            }
        }.resume()
        
        return
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if SubscriptionInfoTableView.contentOffset.y > SubscriptionInfoTableView.contentSize.height - SubscriptionInfoTableView.bounds.size.height {
            if(isAvailable){
                isAvailable = false
                page += 1
                dataUpdate()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionInfo") as? SubscriptionInfoTableViewCell else{
            return UITableViewCell()
        }

        cell.TitleLabel.text = subscriptionData[indexPath.row].houseNm ?? ""
        cell.AddrLabel.text = subscriptionData[indexPath.row].hssplyAdres ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let infoURL = NSURL(string: subscriptionData[indexPath.row].pblancURL ?? "")
        let safariView: SFSafariViewController = SFSafariViewController(url: infoURL! as URL)
        self.present(safariView, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedLocationView.alpha = 0
        dataUpdate()
        SubscriptionInfoTableView.delegate = self
        SubscriptionInfoTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0.0)]
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.backButtonAppearance = backButtonAppearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        locationSelected()
    }
}

func GetKey(key: String)->String{
    guard let ret = Bundle.main.object(forInfoDictionaryKey: key) as? String else{
        return "MXaOLldc%2FcMikgWupHZWPyG4%2FECMwzEmocS7g7ueaD5WVp4OaLu1ez8o0KaB4jayNdPppHfoPFuPgt%2B8qUjIuA%3D%3D"
    }
    return ret
}

struct sspair{
    let title, addr:String
}
// MARK: - SI_rp
struct SI_rp: Codable {
    let currentCount: Int
    let data: [Datum]
    let matchCount, page, perPage, totalCount: Int
}

// MARK: - Datum
struct Datum: Codable {
    let bsnsMbyNm, cnstrctEntrpsNm, cntrctCnclsBgnde, cntrctCnclsEndde: String?
    let gnrlRnk1CrspareaRceptPD, gnrlRnk1EtcAreaRcptdePD, gnrlRnk1EtcGgRcptdePD: String?
    let gnrlRnk2CrspareaRceptPD, gnrlRnk2EtcAreaRcptdePD, gnrlRnk2EtcGgRcptdePD: String?
    let hmpgAdres, houseDtlSecd, houseDtlSecdNm: String?
    let houseManageNo: Int?
    let houseNm, houseSecd, houseSecdNm, hssplyAdres: String?
    let hssplyZip, imprmnBsnsAt, lrsclBldlndAt, mdatTrgetAreaSecd: String?
    let mdhsTelno, mvnPrearngeYm, nplnPrvoprPublicHouseAt, parcprcUlsAt: String?
    let pblancNo: Int?
    let pblancURL: String?
    let przwnerPresnatnDe, publicHouseEarthAt, rceptBgnde, rceptEndde: String?
    let rcritPblancDe, rentSecd, rentSecdNm, specltRdnEarthAt: String?
    let spsplyRceptBgnde, spsplyRceptEndde, subscrptAreaCode, subscrptAreaCodeNm: String?
    let totSuplyHshldco: Int?

    enum CodingKeys: String, CodingKey {
        case bsnsMbyNm = "BSNS_MBY_NM"
        case cnstrctEntrpsNm = "CNSTRCT_ENTRPS_NM"
        case cntrctCnclsBgnde = "CNTRCT_CNCLS_BGNDE"
        case cntrctCnclsEndde = "CNTRCT_CNCLS_ENDDE"
        case gnrlRnk1CrspareaRceptPD = "GNRL_RNK1_CRSPAREA_RCEPT_PD"
        case gnrlRnk1EtcAreaRcptdePD = "GNRL_RNK1_ETC_AREA_RCPTDE_PD"
        case gnrlRnk1EtcGgRcptdePD = "GNRL_RNK1_ETC_GG_RCPTDE_PD"
        case gnrlRnk2CrspareaRceptPD = "GNRL_RNK2_CRSPAREA_RCEPT_PD"
        case gnrlRnk2EtcAreaRcptdePD = "GNRL_RNK2_ETC_AREA_RCPTDE_PD"
        case gnrlRnk2EtcGgRcptdePD = "GNRL_RNK2_ETC_GG_RCPTDE_PD"
        case hmpgAdres = "HMPG_ADRES"
        case houseDtlSecd = "HOUSE_DTL_SECD"
        case houseDtlSecdNm = "HOUSE_DTL_SECD_NM"
        case houseManageNo = "HOUSE_MANAGE_NO"
        case houseNm = "HOUSE_NM"
        case houseSecd = "HOUSE_SECD"
        case houseSecdNm = "HOUSE_SECD_NM"
        case hssplyAdres = "HSSPLY_ADRES"
        case hssplyZip = "HSSPLY_ZIP"
        case imprmnBsnsAt = "IMPRMN_BSNS_AT"
        case lrsclBldlndAt = "LRSCL_BLDLND_AT"
        case mdatTrgetAreaSecd = "MDAT_TRGET_AREA_SECD"
        case mdhsTelno = "MDHS_TELNO"
        case mvnPrearngeYm = "MVN_PREARNGE_YM"
        case nplnPrvoprPublicHouseAt = "NPLN_PRVOPR_PUBLIC_HOUSE_AT"
        case parcprcUlsAt = "PARCPRC_ULS_AT"
        case pblancNo = "PBLANC_NO"
        case pblancURL = "PBLANC_URL"
        case przwnerPresnatnDe = "PRZWNER_PRESNATN_DE"
        case publicHouseEarthAt = "PUBLIC_HOUSE_EARTH_AT"
        case rceptBgnde = "RCEPT_BGNDE"
        case rceptEndde = "RCEPT_ENDDE"
        case rcritPblancDe = "RCRIT_PBLANC_DE"
        case rentSecd = "RENT_SECD"
        case rentSecdNm = "RENT_SECD_NM"
        case specltRdnEarthAt = "SPECLT_RDN_EARTH_AT"
        case spsplyRceptBgnde = "SPSPLY_RCEPT_BGNDE"
        case spsplyRceptEndde = "SPSPLY_RCEPT_ENDDE"
        case subscrptAreaCode = "SUBSCRPT_AREA_CODE"
        case subscrptAreaCodeNm = "SUBSCRPT_AREA_CODE_NM"
        case totSuplyHshldco = "TOT_SUPLY_HSHLDCO"
    }
}
