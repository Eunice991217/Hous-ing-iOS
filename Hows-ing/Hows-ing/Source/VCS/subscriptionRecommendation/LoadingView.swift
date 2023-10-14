//
//  LoadingView.swift
//  Hows-ing
//
//  Created by 윤지성 on 2023/10/14.
//

import UIKit

import UIKit

class LoadingView: UIView {
    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "AI 가"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "neurimboGothicRegular", size: 24)
        label.textColor = UIColor(named: "HousingBlue")
        
        return label
    }()
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "FIT한 청약\n찾는 중"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "neurimboGothicRegular", size: 24)
        label.textColor = UIColor(named: "HousingBlue")
        return label
    }()
    let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "•••"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Pretendard-Regular", size: 36)
        label.textColor = UIColor(named: "HousingBlue")
        return label
    }()
    let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "•••"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Pretendard-Regular", size: 36)
        label.textColor = UIColor(named: "HousingBlue")
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BlueLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // 일반적인 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        
        // Custom View의 배경색을 설정합니다.
        backgroundColor = UIColor.white
        
        // Custom View에 Label 및 ImageView를 추가합니다.
        addSubview(topLabel)
        addSubview(bottomLabel)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        addSubview(imageView)
        
        // Label 및 ImageView의 제약 조건을 설정합니다.
        topLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -21).isActive = true
        topLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        bottomLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
       // bottomLabel.widthAnchor.constraint(equalToConstant: 63).isActive = true
        
        leftLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        leftLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -30).isActive = true
        
        rightLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        rightLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 30).isActive = true
        
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: bounds.size.height * 0.93).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 63).isActive = true // 이미지 뷰의 너비 설정
        imageView.heightAnchor.constraint(equalToConstant: 65).isActive = true // 이미지 뷰의 높이 설정
    }
}

