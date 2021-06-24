//
//  EDitToolBorderBar.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/21.
//

import UIKit

class EDitToolBorderBar: UIView {

    let sizeType: SIZeSelectView.SIZeType
    var borderList: [NEymEditToolItem] = []
    var collection: UICollectionView!
    var closeBtnBlock: (()->Void)?
    var selectBorderItemBlock: ((NEymEditToolItem, Bool)->Void)?
    var currentSelectItem: NEymEditToolItem?
    
    init(frame: CGRect, sizeType: SIZeSelectView.SIZeType) {
        self.sizeType = sizeType
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
            $0.top.equalTo(closeBtn.snp.bottom)
            $0.centerY.equalToSuperview().offset(10)
        }
        collection.register(cellWithClass: EDitBorderCell.self)
    }
    
    func loadData() {
        if sizeType == .size_16_9 {
            borderList = NEEDataM.default.borderList_16_9
        } else {
            borderList = NEEDataM.default.borderList_1_1
        }
        
    }
    
    @objc func closeBtnClick(sender: UIButton) {
        closeBtnBlock?()
    }
}

extension EDitToolBorderBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EDitBorderCell.self, for: indexPath)
        let item = borderList[indexPath.item]
        
        cell.contentImgV.image = UIImage(named: item.thumbName)
        if item.isPro {
            cell.vipImgV.isHidden = false
        } else {
            cell.vipImgV.isHidden = true
        }
        cell.selectStatusView.layer.borderWidth = 1.5
        cell.selectStatusView.layer.borderColor = UIColor(hexString: "#14EBDA")?.cgColor
        cell.selectStatusView.layer.cornerRadius = 13
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
        return borderList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension EDitToolBorderBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension EDitToolBorderBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = borderList[indexPath.item]
        currentSelectItem = item
        selectBorderItemBlock?(item, item.isPro)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class EDitBorderCell: UICollectionViewCell {
    
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
        backgroundColor = .black
        addSubview(contentImgV)
        addSubview(selectStatusView)
        addSubview(vipImgV)
        vipImgV.image = UIImage(named: "edit_vip")
        contentImgV.contentMode = .scaleAspectFit
        vipImgV.contentMode = .center
        
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(64)
            $0.height.equalTo(112)
        }
        selectStatusView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(73)
            $0.height.equalTo(124)
        }
        vipImgV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(0)
            $0.width.height.equalTo(108/2)
        }
        
        
    }
    
    
    
}









