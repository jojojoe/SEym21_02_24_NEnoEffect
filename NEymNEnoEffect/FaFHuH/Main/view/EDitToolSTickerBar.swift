//
//  EDitToolSTickerBar.swift
//  NEymNEnoEffect
//
//  Created by JOJO on 2021/6/21.
//

import UIKit

 
 
class EDitToolSTickerBar: UIView {

    
    var list: [NEymEditToolItem] = []
    var collection: UICollectionView!
    var closeBtnBlock: (()->Void)?
    var selectItemBlock: ((NEymEditToolItem, Bool)->Void)?
    var currentSelectItem: NEymEditToolItem?
    let stickerBtnWord = UIButton(type: .custom)
    let stickerBtnMark = UIButton(type: .custom)
    let stickerBtnAnim = UIButton(type: .custom)
    let stickerBtnPlant = UIButton(type: .custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupView()
        loadDefaultData()
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
            $0.centerY.equalToSuperview().offset(20)
            $0.height.equalTo(90)
        }
        collection.register(cellWithClass: EDitSTickerCell.self)
        //
        
        //
        stickerBtnWord.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        stickerBtnWord.setTitle("Word", for: .normal)
        stickerBtnWord.setTitleColor(.white, for: .normal)
        stickerBtnWord.setTitleColor(UIColor(hexString: "#01FFFA"), for: .selected)
        stickerBtnWord.addTarget(self, action: #selector(stickerBtnWordBtnClick(sender:)), for: .touchUpInside)
        //
        //
        stickerBtnMark.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        stickerBtnMark.setTitle("Mark", for: .normal)
        stickerBtnMark.setTitleColor(.white, for: .normal)
        stickerBtnMark.setTitleColor(UIColor(hexString: "#01FFFA"), for: .selected)
        stickerBtnMark.addTarget(self, action: #selector(stickerBtnMarkBtnClick(sender:)), for: .touchUpInside)
        //
        //
        stickerBtnAnim.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        stickerBtnAnim.setTitle("Animal", for: .normal)
        stickerBtnAnim.setTitleColor(.white, for: .normal)
        stickerBtnAnim.setTitleColor(UIColor(hexString: "#01FFFA"), for: .selected)
        stickerBtnAnim.addTarget(self, action: #selector(stickerBtnAnimBtnClick(sender:)), for: .touchUpInside)
        //
        //
        stickerBtnPlant.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        stickerBtnPlant.setTitle("Plant", for: .normal)
        stickerBtnPlant.setTitleColor(.white, for: .normal)
        stickerBtnPlant.setTitleColor(UIColor(hexString: "#01FFFA"), for: .selected)
        stickerBtnPlant.addTarget(self, action: #selector(stickerBtnPlantBtnClick(sender:)), for: .touchUpInside)
        //
        addSubview(stickerBtnMark)
        addSubview(stickerBtnAnim)
        addSubview(stickerBtnWord)
        addSubview(stickerBtnPlant)
        //
        stickerBtnMark.snp.makeConstraints {
            $0.centerY.equalTo(closeBtn.snp.bottom).offset(20)
            $0.right.equalTo(snp.centerX).offset(-10)
            $0.width.equalTo(66)
            $0.height.equalTo(26)
        }
        stickerBtnWord.snp.makeConstraints {
            $0.centerY.equalTo(stickerBtnMark)
            $0.right.equalTo(stickerBtnMark.snp.left).offset(-10)
            $0.width.equalTo(66)
            $0.height.equalTo(26)
        }
        stickerBtnAnim.snp.makeConstraints {
            $0.centerY.equalTo(stickerBtnMark)
            $0.left.equalTo(stickerBtnMark.snp.right).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(26)
        }
        stickerBtnPlant.snp.makeConstraints {
            $0.centerY.equalTo(stickerBtnMark)
            $0.left.equalTo(stickerBtnAnim.snp.right).offset(10)
            $0.width.equalTo(66)
            $0.height.equalTo(26)
        }
        
        
    }
    
    func loadDefaultData() {
        stickerBtnWordBtnClick(sender: stickerBtnMark)
        
    }
    
    @objc func closeBtnClick(sender: UIButton) {
        closeBtnBlock?()
    }
    @objc func stickerBtnWordBtnClick(sender: UIButton) {
        stickerBtnWord.isSelected = true
        stickerBtnMark.isSelected = false
        stickerBtnAnim.isSelected = false
        stickerBtnPlant.isSelected = false
        list = NEEDataM.default.stickerItemList_word
        collection.reloadData()
        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    @objc func stickerBtnMarkBtnClick(sender: UIButton) {
        stickerBtnWord.isSelected = false
        stickerBtnMark.isSelected = true
        stickerBtnAnim.isSelected = false
        stickerBtnPlant.isSelected = false
        list = NEEDataM.default.stickerItemList_mark
        collection.reloadData()
        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    @objc func stickerBtnAnimBtnClick(sender: UIButton) {
        stickerBtnWord.isSelected = false
        stickerBtnMark.isSelected = false
        stickerBtnAnim.isSelected = true
        stickerBtnPlant.isSelected = false
        list = NEEDataM.default.stickerItemList_animal
        collection.reloadData()
        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    @objc func stickerBtnPlantBtnClick(sender: UIButton) {
        stickerBtnWord.isSelected = false
        stickerBtnMark.isSelected = false
        stickerBtnAnim.isSelected = false
        stickerBtnPlant.isSelected = true
        list = NEEDataM.default.stickerItemList_plant
        collection.reloadData()
        collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
    }
    
    
    
}

extension EDitToolSTickerBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: EDitSTickerCell.self, for: indexPath)
        let item = list[indexPath.item]
        
        
        cell.contentImgV.image = UIImage(named: item.thumbName)
        
        
        if item.isPro {
            cell.vipImgV.isHidden = false
        } else {
            cell.vipImgV.isHidden = true
        }
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

extension EDitToolSTickerBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
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

extension EDitToolSTickerBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = list[indexPath.item]
        currentSelectItem = item
        selectItemBlock?(item, item.isPro)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

class EDitSTickerCell: UICollectionViewCell {
    
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
        
        
    }
    
    
    
}









