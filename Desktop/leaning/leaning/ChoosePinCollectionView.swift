//
//  ChooseColor.swift
//  leaning
//
//  Created by Tenna on 2/5/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import Foundation
import UIKit

class ChoosePin: UIView {
    
    private let indexPath = NSIndexPath(item: 112, section: 1)
    private let closeBtn = UIButton()
    private var pincolor = String()
    private var cellItem = -1, cellSec = -1
    private let headerTitle = [["ベーシック"], ["食べ物"], ["人物"], ["遊び"], ["その他"]]
    private let photo = [
        ["h1.png", "h2.png", "pair.png", "m.png", "w.png", "o.png", "redpin-1.png", "p.png", "y.png", "b.png", "bb.png", "bbb.png", "g.png", "pp.png", "up.png", "down.png", "houseB.png", "houseR.png", "walk.png", "car.png", "cycle.png", "style.png", "sc.png", "hsp.png", "love.png"],
        ["st.png", "mm.png", "tea.png", "curry.png", "old.png", "beer.png", "garlic.png", "onion.png", "fish.png", "rice.png", "icec.png", "paprica.png", "apple.png", "daikon.png", "shrimp.png", "meat.png", "ramen.png", "steak.png"],
        ["baby.png", "kid.png", "adult.png", "kids.png", "boy.png", "girl.png", "boy2.png", "girl2.png", "boy3.png", "girl3.png", "woman.png", "man.png", "boy1.png", "girl1.png", "ts.png", "piero.png", "pan.png"],
        ["jungle.png", "play.png", "play2.png", "badm.png", "bilard.png", "book.png", "paint.png", "music.png"],
        ["rabbit.png", "bear.png", "bed.png", "futon.png", "shirt.png", "money.png", "camera.png", "building.png", "paper.png", "phone.png", "tree.png", "nature.png", "flower.png", "umo.png", "fuel.png", "glasses.png", "study.png", "nail.png", "unko.png", "moon.png", "s.png", "chicken.png", "usb.png", "hotel.png", "onsen.png", "temp.png", "super.png", "gym.png", "ear.png", "eye.png", "foot.png", "lip.png", "nose.png", "hand.png", "fire.png", "water.png", "bottle.png", "watch.png", "bulb.png", "undie.png", "earth.png", "lip2.png", "sock.png", "other.png"]]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //コレクションビュー
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Screen.w-12, height: Screen.h-90), collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 14
        collectionView.layer.borderColor = UserSetting.color3?.cgColor
        collectionView.layer.borderWidth = 2
        collectionView.allowsMultipleSelection = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        
        //キャンセルボタン
        btnSetting()
        closeBtn.addTarget(self, action: #selector(self.hideView), for: .touchDown)
        closeBtn.addTarget(ViewController(), action: #selector(ViewController.changePin), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // キャンセルボタンの設定
    func btnSetting() {
        closeBtn.setTitle("キャンセル", for: UIControl.State())
        closeBtn.setTitleColor(UIColor.black, for: UIControl.State())
        closeBtn.frame = CGRect(x: Screen.w/2-70, y: Screen.h-85, width: 140, height: 30)
        closeBtn.layer.cornerRadius = 8
        closeBtn.backgroundColor = UIColor.white
        addSubview(closeBtn)
    }
    
    @objc func hideView(sender: UIButton) {
        sender.alpha = 0.4
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
                        self.frame = CGRect(x: 0, y: Screen.h, width: Screen.w, height: Screen.h)
                        sender.alpha = 1
                        }, completion: { (finished) in
                        self.removeFromSuperview()
        })
    }
}

extension ChoosePin: UICollectionViewDelegate {
    //セルが選ばれた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //セルの背景色を透明に
        for cell in collectionView.visibleCells {
            cell.backgroundColor = UIColor.clear
        }
        
        //選択されたセルの色を変更
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.backgroundColor = UIColor.white
        
        // UserSettingのpinColorを変更
        UserSetting.pinColor = photo[indexPath.section][indexPath.row]
        // キャンセルボタンを完了ボタンに
        closeBtn.setTitle("完了", for: UIControl.State())
        closeBtn.layer.borderColor = UIColor.red.cgColor
        closeBtn.layer.borderWidth = 3
    }
}

extension ChoosePin: UICollectionViewDataSource {
    // セルの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photo[section].count
    }
    
    // ヘッダーの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.headerTitle.count
    }
    
    // セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath as IndexPath) as! CollectionViewCell
        
        let cellImage = UIImage(named: photo[indexPath.section][indexPath.item])!
        
        cell.setUpContents(image: cellImage,textName: "")
        return cell
    }
    
    // ヘッダーの設定
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionViewHeader
        let headerText = headerTitle[indexPath.section][indexPath.item]
        collectionViewHeader.setUpContents(titleText: headerText)
        return collectionViewHeader
    }
}

extension ChoosePin:  UICollectionViewDelegateFlowLayout {
    // セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    // セルの余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    // ヘッダーのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: Screen.w, height: 35)
    }
}
