//
//  NEEffectStoreVC.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/18.
//

import UIKit
import NoticeObserveKit
import StoreKit
import Adjust
import SwiftyStoreKit

class NEEffectStoreVC: UIViewController {
    let backBtn = UIButton(type: .custom)
    private var pool = Notice.ObserverPool()
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        setupCollection()
        addNotificationObserver()
    }
    
   func addNotificationObserver() {
       
       NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
           guard let `self` = self else {return}
           DispatchQueue.main.async {
               self.topCoinLabel.text = "\(NEyCoinManag.default.coinCount)"
           }
       }
       .invalidated(by: pool)
       
       NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
           guard let `self` = self else {return}
           DispatchQueue.main.async {
               self.collection.reloadData()
           }
       }
       .invalidated(by: pool)
   }
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension NEEffectStoreVC {
    func setupView() {
        //
        view.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        backBtn.setImage(UIImage(named: "ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.left.equalTo(10)
            $0.width.height.equalTo(144/2)
        }
        //
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(NEyCoinManag.default.coinCount)"
        topCoinLabel.textColor = UIColor(hexString: "#FFE7A8")
        topCoinLabel.font = UIFont(name: "Avenir-Black", size: 18)
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(backBtn)
            $0.right.equalTo(-18)
            $0.height.greaterThanOrEqualTo(35)
            $0.width.greaterThanOrEqualTo(25)
        }
        
        let coinImageV = UIImageView()
        coinImageV.image = UIImage(named: "store_coin")
        coinImageV.contentMode = .scaleAspectFit
        view.addSubview(coinImageV)
        coinImageV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel)
            $0.right.equalTo(topCoinLabel.snp.left).offset(18)
            $0.width.height.equalTo(160/2)
        }
    }
    
    func setupCollection() {
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.layer.cornerRadius = 35
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom)
        }
        collection.register(cellWithClass: IHymStoreCell.self)
        
    }
    
    
    func selectCoinItem(item: StoreItem) {
        NEyCoinManag.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
    
    
    
}



extension NEEffectStoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IHymStoreCell.self, for: indexPath)
        let item = NEyCoinManag.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "\(item.coin) Coins"
        cell.priceLabel.text = item.price
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NEyCoinManag.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension NEEffectStoreVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 155)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = ((UIScreen.main.bounds.width - 340 - 1) / 2)
        return UIEdgeInsets(top: 0, left: left, bottom: 0, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return -20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension NEEffectStoreVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = NEyCoinManag.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class IHymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.black
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        //
        bgImageV.backgroundColor = .clear
        bgImageV.contentMode = .scaleAspectFit
        bgImageV.image = UIImage(named: "store_button")
//        bgImageV.layer.masksToBounds = true
//        bgImageV.layer.cornerRadius = 27
//        bgImageV.layer.borderColor = UIColor.black.cgColor
//        bgImageV.layer.borderWidth = 4
        bgView.addSubview(bgImageV)
        bgImageV.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        //
//        let iconImgV = UIImageView(image: UIImage(named: "store_ic_heart"))
//        iconImgV.contentMode = .scaleAspectFit
//        bgView.addSubview(iconImgV)
//        iconImgV.snp.makeConstraints {
//            $0.centerY.equalToSuperview()
//            $0.left.equalTo(35)
//            $0.width.height.equalTo(38)
//        }
        
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel.textColor = UIColor(hexString: "#FFE7A8")
        coinCountLabel.layer.shadowColor = UIColor(hexString: "#FFE7A8")?.cgColor
        coinCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        coinCountLabel.layer.shadowRadius = 3
        coinCountLabel.layer.shadowOpacity = 0.8
        
        coinCountLabel.numberOfLines = 1
        coinCountLabel.textAlignment = .center
        coinCountLabel.font = UIFont(name: "Avenir-Black", size: 22)
        coinCountLabel.adjustsFontSizeToFitWidth = true
        bgView.addSubview(coinCountLabel)
        coinCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-30)
            $0.centerX.equalTo(snp.right).offset(-107)
            $0.width.lessThanOrEqualTo(160)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
//        coverImageV.image = UIImage(named: "home_button")
//        coverImageV.contentMode = .center
//        bgView.addSubview(coverImageV)
//
        //
        priceLabel.textColor = UIColor(hexString: "#FF12D2")
        priceLabel.font = UIFont(name: "Avenir-Black", size: 22)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        priceLabel.layer.shadowColor = UIColor(hexString: "#FF12D2")?.cgColor
        priceLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        priceLabel.layer.shadowRadius = 3
        priceLabel.layer.shadowOpacity = 0.8
        
        
//        priceLabel.backgroundColor = UIColor(hexString: "#4AD0EF")
//        priceLabel.cornerRadius = 30
        priceLabel.adjustsFontSizeToFitWidth = true
//        priceLabel.layer.borderWidth = 2
//        priceLabel.layer.borderColor = UIColor.white.cgColor
        priceLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(1)
            $0.height.greaterThanOrEqualTo(30)
            $0.centerX.equalTo(coinCountLabel)
            $0.top.equalTo(snp.centerY)
        }
        
//        coverImageV.snp.makeConstraints {
//            $0.center.equalTo(priceLabel.snp.center)
//            $0.width.equalTo(135)
//            $0.height.equalTo(54)
//        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                
            } else {
                
            }
        }
    }
}




