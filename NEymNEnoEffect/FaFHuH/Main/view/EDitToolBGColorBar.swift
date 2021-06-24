//
//  EDitToolBGColorBar.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/21.
//

import UIKit
 
class EDitToolBGColorBar: UIView {

    
    var list: [NEymEditToolItem] = []
    var collection: UICollectionView!
    var closeBtnBlock: (()->Void)?
    var selectBorderItemBlock: ((NEymEditToolItem, Bool)->Void)?
    var currentSelectItem: NEymEditToolItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        loadData()
        setupView()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        let closeBtn = UIButton(type: .custom)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.right.equalTo(-12)
            $0.width.height.equalTo(30)
        }
        closeBtn.setImage(UIImage(named: "edit_ic_return"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(sender:)), for: .touchUpInside)
        //
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.right.left.equalToSuperview()
            $0.centerY.equalToSuperview().offset(10)
            $0.height.equalTo(90)
        }
        collection.register(cellWithClass: EDitBgColorCell.self)
    }
    
    func loadData() {
        list = NEEDataM.default.bgColorList
        
    }
    
    @objc func closeBtnClick(sender: UIButton) {
        closeBtnBlock?()
    }
}

extension EDitToolBGColorBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EDitBgColorCell.self, for: indexPath)
        let item = list[indexPath.item]
        
        
        if item.thumbName.contains("#") {
            cell.contentImgV.image = nil
            cell.contentImgV.backgroundColor = UIColor(hexString: item.thumbName)
        } else {
            cell.contentImgV.image = UIImage(named: item.thumbName)
        }
        if item.thumbName.contains("000000") {
            cell.contentImgV.layer.borderColor = UIColor(hexString: "FFFFFF")!.withAlphaComponent(0.4).cgColor
            cell.contentImgV.layer.borderWidth = 1
        } else {
            cell.contentImgV.layer.borderColor = UIColor(hexString: "FFFFFF")!.withAlphaComponent(0.4).cgColor
            cell.contentImgV.layer.borderWidth = 0
        }
        
//        if item.isPro {
//            cell.vipImgV.isHidden = false
//        } else {
//            cell.vipImgV.isHidden = true
//        }
        cell.selectStatusView.layer.borderWidth = 1.5
        cell.selectStatusView.layer.borderColor = UIColor(hexString: "#14EBDA")?.cgColor
        cell.selectStatusView.layer.cornerRadius = 9
        cell.selectStatusView.layer.shadowColor = UIColor(hexString: "#01FFFA")?.cgColor
        cell.selectStatusView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.selectStatusView.layer.shadowRadius = 3
        cell.selectStatusView.layer.shadowOpacity = 0.8
        
        
        if currentSelectItem?.thumbName == item.thumbName {
            cell.selectStatusView.isHidden = false
        } else {
            cell.selectStatusView.isHidden = true
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EDitToolBGColorBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

extension EDitToolBGColorBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        currentSelectItem = item
        selectBorderItemBlock?(item, false)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class EDitBgColorCell: UICollectionViewCell {
    
    let contentImgV = UIImageView()
    let vipImgV = UIImageView()
    let selectStatusView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        backgroundColor = .black
        contentView.addSubview(contentImgV)
        contentView.addSubview(selectStatusView)
        contentView.addSubview(vipImgV)
        vipImgV.image = UIImage(named: "edit_vip")
        contentImgV.contentMode = .scaleAspectFit
        vipImgV.contentMode = .center
        contentImgV.layer.cornerRadius = 6
        contentImgV.layer.masksToBounds = true
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        selectStatusView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(66)
            $0.height.equalTo(66)
        }
        vipImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-10)
            $0.right.equalToSuperview().offset(10)
            $0.width.height.equalTo(108/2)
        }
        vipImgV.isHidden = true
        
    }
    
    
    
}









