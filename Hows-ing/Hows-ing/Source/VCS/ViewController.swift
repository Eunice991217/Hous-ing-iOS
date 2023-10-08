//
//  ViewController.swift
//  Hows-ing
//
//  Created by 황재상 on 10/7/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    @IBOutlet weak var Banner: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Init()
        Banner.delegate = self
        Banner.dataSource = self
    }
    
    func Init(){
        Banner.layer.cornerRadius = 10
    }



}

