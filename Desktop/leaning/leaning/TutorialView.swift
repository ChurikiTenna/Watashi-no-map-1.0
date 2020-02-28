//
//  TutorialView.swift
//  leaning
//
//  Created by Tenna on 2/12/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import UIKit
import Foundation

class TutorialPage1: ViewController {
    
    private var label = UITextView()
    private var mapImageView = UIImageView()
    private let bar = UILabel()
    private let posBtn = UIButton()
    private var pinView = UIImageView()
    private var dPinView = UIImageView()
    private var calloutView = UIImageView()
    private let textLabel = UILabel()
    private var animationTimer: Timer?
    
    override func viewDidLoad() {
        print("TUTORIAL1")
        
        // map
        let map = UIImage(named: "map.png")
        mapImageView = UIImageView(image: map)
        mapImageView.frame = CGRect(x: 100, y: 100, width: 526, height: 838)
        view.addSubview(mapImageView)
        
        // iPhone
        let image = UIImage(named: "iphone.png")
        let w = image!.size.width, h = image!.size.height
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        
        let cropCGImageRef = image!.cgImage!.cropping(to: CGRect(x: w/2-Screen.w/2, y: h/2-Screen.h/2, width: Screen.w, height: Screen.h))!
        let cropImage = UIImage(cgImage: cropCGImageRef)
        let cropImageView = UIImageView(image: cropImage)
        cropImageView.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        view.addSubview(cropImageView)
        
        // タイトル
        let title = UILabel(frame: CGRect(x: Screen.w/2-120, y: 60, width: 240, height: Screen.h/32))
        title.text = "ピンを追加する"
        title.backgroundColor = UIColor(white: 1, alpha: 0.8)
        title.textAlignment = .center
        title.layer.cornerRadius = 10
        title.clipsToBounds = true
        view.addSubview(title)
        
        // searchBar
        bar.frame = CGRect(x: Screen.w/2-100, y: Screen.h/2-200, width: 200, height: 30)
        bar.clipsToBounds = true
        bar.layer.cornerRadius = 10
        bar.backgroundColor = UIColor.white
        bar.layer.borderColor = Color.color3.cgColor
        bar.layer.borderWidth = 3
        let barText = UIImage(named: "searchbarText.png")
        let barTextView = UIImageView(image: barText)
        barTextView.frame = CGRect(x: 20, y: 8, width: 90, height: 15)
        view.addSubview(bar)
        bar.addSubview(barTextView)
        // 枠線の色を点滅させる
        animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
        
        // 現在地ボタン
        posBtn.frame = CGRect(x: Screen.w/2-100, y: Screen.h/2-165, width: 60, height: 22.5)
        posBtn.layer.cornerRadius = 7
        posBtn.setTitle("現在地", for: UIControl.State())
        posBtn.setTitleColor(UIColor.black, for: UIControl.State())
        posBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        posBtn.backgroundColor = UIColor.white
        posBtn.layer.borderColor = Color.color2.cgColor
        posBtn.layer.borderWidth = 3
        view.addSubview(posBtn)
        
        // 現在地ピン
        let userLoc = UIImage(named: "hitoB.png")
        pinView = UIImageView(image: userLoc)
        pinView.frame = CGRect(x: 380, y: 580, width: 30, height: 40)
        mapImageView.addSubview(pinView)
        
        // デフォルトピン
        let defaultPin = UIImage(named: "redpin-1.png")
        dPinView = UIImageView(image: defaultPin)
        
        // 説明ラベル
        let btn = UIButton()
        labelSetting(text: "ピンを追加したい\n場所をマップで検索", btn: btn)
        btn.addTarget(self, action: #selector(self.changeLabel1), for: .touchDown)
        
    }
    
    // デフォルト説明ラベル
    func labelSetting(text: String, btn: UIButton) {
        label.frame = CGRect(x: Screen.w/2-130, y: Screen.h/2+80, width: 260, height: 60)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.isEditable = false
        label.backgroundColor = UIColor.white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        
        btn.frame = CGRect(x: 205, y: 15, width: 30, height: 30)
        btn.setTitle("OK", for: UIControl.State())
        btn.backgroundColor = UIColor(white: 0, alpha: 0.3)
        btn.layer.cornerRadius = 15
        label.addSubview(btn)
        view.addSubview(label)
    }
    
    // searchBarの枠線点滅
    @objc func animate() {
        UIView.animate(withDuration: 2) {
            if self.bar.layer.borderColor == Color.color3.cgColor {
                self.bar.layer.borderColor = UIColor.red.cgColor
            } else {
                self.bar.layer.borderColor = Color.color3.cgColor
            }
        }
    }
    
    // ”現在地ボタンで今いる場所に移動”のアニメーション
    @objc func changeLabel1(sender: UIButton) {
        sender.removeFromSuperview()
        animationTimer?.invalidate()
        bar.layer.borderColor = Color.color3.cgColor
        
        let btn = UIButton()
        labelSetting(text: "現在地ボタンで\n今いる場所に移動", btn: btn)
        btn.addTarget(self, action: #selector(self.changeLabel2), for: .touchDown)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            
            self.posBtn.layer.borderColor = UIColor.red.cgColor
            // ボタンをクリックするアニメーション
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.posBtn.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        mapImageView.frame = CGRect(x: 100, y: 100, width: 526, height: 838)
        // 地図を移動
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            UIView.animate(withDuration: 1) {
                self.mapImageView.frame = CGRect(x: Screen.w/2-400, y: Screen.h/2-600, width: 526, height: 838)
            }
        }
    }
    
    // "長押しでピンを追加"のアニメーション
    @objc func changeLabel2(sender: UIButton) {
        sender.removeFromSuperview()
        pinView.removeFromSuperview()
        
        let btn = UIButton()
        labelSetting(text: "マップを長押し\nしてピンを表示", btn: btn)
        btn.addTarget(self, action: #selector(self.detailPanel), for: .touchDown)

        // 波紋
        let w2 = 80, h2 = 80
        let scaleTransform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        let size = CGSize(width: w2, height: h2)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        let ovalRect = CGRect(x: 0, y: 0, width: w2, height: h2)
        let ovalPath = UIBezierPath(ovalIn: ovalRect)
        context?.setFillColor(red: 83/255, green: 193/255, blue: 212/255, alpha: 1)
        ovalPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let HamonnView = UIImageView(image: image)
        HamonnView.transform = scaleTransform
        HamonnView.center = CGPoint(x: Screen.w/2, y: Screen.h/2)
        view.addSubview(HamonnView)
        
        UIView.animate(withDuration: 2, delay: 0, options: [ .curveEaseInOut], animations: { HamonnView.alpha = 0
        HamonnView.transform = .identity }, completion: nil)

        // ピン表示
        view.addSubview(dPinView)
        dPinView.frame = CGRect(x: Screen.w/2, y: Screen.h/2, width: 0, height: 0)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            UIView.animate(withDuration: 0.5) {
                self.dPinView.frame = CGRect(x: Screen.w/2-15, y: Screen.h/2-40, width: 30, height: 40)
            }
        }
    }
    
    // callOut表示
    @objc func detailPanel(sender: UIButton) {
        sender.removeFromSuperview()
        
        let btn = UIButton()
        labelSetting(text: "ピンをタップして\n詳細表示", btn: btn)
        btn.addTarget(self, action: #selector(self.nextPage), for: .touchDown)
        
        let image = UIImage(named: "callout.png")
        calloutView = UIImageView(image: image)
        view.addSubview(calloutView)
        calloutView.frame = CGRect(x: Screen.w/2, y: Screen.h/2-40, width: 0, height: 0)
        UIView.animate(withDuration: 0.7) {
            self.calloutView.frame = CGRect(x: Screen.w/2-72, y: Screen.h/2-133, width: 144, height: 93)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.4) {
            self.label.text = "＋を押して\nピンを編集・追加"
        }
    }
    
    @objc func nextPage() {
        label.removeFromSuperview()
        
        textLabel.text = "スワイプ"
        textLabel.textColor = UIColor.black
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.transform = textLabel.transform.rotated(by: CGFloat(Double.pi)/(-2))
        view.addSubview(textLabel)
        textLabel.frame = CGRect(x: Screen.w-80, y: Screen.h/2-50, width: 100, height: 100)
        
        animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animate2), userInfo: nil, repeats: true)
        
    }
    
    @objc func animate2() {
        UIView.animate(withDuration: 2) {
            if self.textLabel.frame == CGRect(x: Screen.w-100, y: Screen.h/2-50, width: 100, height: 100) {
                self.textLabel.frame = CGRect(x: Screen.w-60, y: Screen.h/2-50, width: 100, height: 100)
            } else {
                self.textLabel.frame = CGRect(x: Screen.w-100, y: Screen.h/2-50, width: 100, height: 100)
            }
        }
    }
}

class TutorialPage2: ViewController {
    
    private var label = UITextView()
    private let iphone = UIView()
    private var w = CGFloat(), h = CGFloat()
    private var pinView = UIImageView()
    private var calloutView = UIImageView()
    private var detailView = UIImageView()
    private let exp = UITextView()
    private var btnsView = UIImageView()
    private var arrowView = UIImageView()
    static var animationTimer: Timer?
    
    override func viewDidLoad() {
        print("TUTORIAL2")
        
        // map
        let map = UIImage(named: "map.png")
        let mapImageView = UIImageView(image: map)
        mapImageView.frame = CGRect(x: 100, y: 100, width: 526, height: 838)
        
        let cropCGImageRef = map!.cgImage!.cropping(to: CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h))!
        let cropImage = UIImage(cgImage: cropCGImageRef)
        let cropImageView = UIImageView(image: cropImage)
        cropImageView.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        view.addSubview(cropImageView)
        
        // detailパネル
        let detailImage = UIImage(named: "detail.png")
        detailView = UIImageView(image: detailImage)
        detailView.frame = CGRect(x: Screen.w/2-100, y: Screen.h/2+400, width: 200, height: 173)
        view.addSubview(detailView)
        
        // iPhone
        let image = UIImage(named: "iphone.png")
        let w = image!.size.width, h = image!.size.height
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        
        let cropCGImageRef1 = image!.cgImage!.cropping(to: CGRect(x: w/2-Screen.w/2, y: h/2-Screen.h/2, width: Screen.w, height: Screen.h))!
        let cropImage1 = UIImage(cgImage: cropCGImageRef1)
        let cropImageView1 = UIImageView(image: cropImage1)
        cropImageView1.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        view.addSubview(cropImageView1)
        
        // タイトル
        let label = UILabel()
        label.text = "ピンの詳細を見る"
        label.frame = CGRect(x: Screen.w/2-120, y: 60, width: 240, height: Screen.h/32)
        label.backgroundColor = UIColor(white: 1, alpha: 0.8)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        view.addSubview(label)
        
        // ピン
        let pin = UIImage(named: "shrimp.png")
        pinView = UIImageView(image: pin)
        view.addSubview(pinView)
        pinView.frame = CGRect(x: Screen.w/2-10, y: Screen.h/2-40, width: 30, height: 40)
        // バルーンをアニメーションで表示
        let image2 = UIImage(named: "callout2.png")
        calloutView = UIImageView(image: image2)
        view.addSubview(calloutView)
        calloutView.frame = CGRect(x: Screen.w/2, y: Screen.h/2-40, width: 0, height: 0)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
            UIView.animate(withDuration: 0.7) {
                self.calloutView.frame = CGRect(x: Screen.w/2-86, y: Screen.h/2-91, width: 172, height: 51)
            }
        }
        
        let btn = UIButton()
        labelSetting(text: "詳細を見たい\nピンをタップ", btn: btn)
        btn.addTarget(self, action: #selector(self.openDetail), for: .touchDown)
    }
    
    func labelSetting(text: String, btn: UIButton) {
        label.frame = CGRect(x: Screen.w/2-130, y: Screen.h/2-200, width: 260, height: 60)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.isEditable = false
        label.backgroundColor = UIColor.white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        
        btn.frame = CGRect(x: 205, y: 15, width: 30, height: 30)
        btn.setTitle("OK", for: UIControl.State())
        btn.backgroundColor = UIColor(white: 0, alpha: 0.3)
        btn.layer.cornerRadius = 15
        label.addSubview(btn)
        view.addSubview(label)
    }
    
    @objc func openDetail(sender: UIButton) {
        sender.removeFromSuperview()
        
        let btn = UIButton()
        labelSetting(text: "'詳細'ボタンを押して\n表示", btn: btn)
        btn.addTarget(self, action: #selector(self.hideLabel), for: .touchDown)
        // 詳細パネルを表示
        detailView.frame = CGRect(x: Screen.w/2-100, y: Screen.h/2+400, width: 200, height: 173)
        UIView.animate(withDuration: 0.5) {
            self.detailView.frame = CGRect(x: Screen.w/2-100, y: Screen.h/2+50, width: 200, height: 173)
        }
        // ボタン画像
        let btnsImage = UIImage(named: "btns.png")
        btnsView = UIImageView(image: btnsImage)
        view.addSubview(btnsView)
        btnsView.frame = CGRect(x: Screen.w/2-65, y: Screen.h/2+192.5, width: 0, height: 0)
        // 文字
        exp.text = "ピンを消去・編集"
        exp.clipsToBounds = true
        exp.layer.cornerRadius = 8
        exp.layer.borderColor = UIColor.black.cgColor
        exp.textAlignment = .center
        exp.layer.borderWidth = 2
        exp.isEditable = false
        exp.backgroundColor = UIColor.white
        view.addSubview(exp)
        exp.frame = CGRect(x: Screen.w/2-65, y: Screen.h/2+90, width: 0, height: 60)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            UIView.animate(withDuration: 0.5) {
                self.btnsView.frame = CGRect(x: Screen.w/2-110, y: Screen.h/2+123, width: 83.5, height: 72.5)
                self.exp.frame = CGRect(x: Screen.w/2-120, y: Screen.h/2+90, width: 110, height: 30)
            }
        }
    }
    // ラベルを隠して×ボタンに誘導する矢印を表示
    @objc func hideLabel() {
        UIView.animate(withDuration: TimeInterval(1.0),
                       animations: {
                        self.label.frame = CGRect(x: Screen.w, y: Screen.h/2-200, width: 260, height: 60)
                        self.btnsView.frame = CGRect(x: Screen.w, y: Screen.h/2+123, width: 83.5, height: 72.5)
                        self.exp.frame = CGRect(x: Screen.w, y: Screen.h/2+90, width: 110, height: 30) },
                       completion: { (finished) in
                        self.label.removeFromSuperview()
                        self.btnsView.removeFromSuperview()
                        self.exp.removeFromSuperview()
        })
        
        let image = UIImage(named: "arrow-1.png")
        arrowView = UIImageView(image: image)
        view.addSubview(arrowView)
        arrowView.frame = CGRect(x: 70, y: Screen.h-108, width: 40, height: 40)
        
        TutorialPage2.animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
        
    }
    // 矢印アニメーション
    @objc func animate() {
        UIView.animate(withDuration: 1) {
            if self.arrowView.frame == CGRect(x: 50, y: Screen.h-88, width: 40, height: 40) {
                print("1")
                self.arrowView.frame = CGRect(x: 90, y: Screen.h-128, width: 40, height: 40)
            } else {
                print("2")
                self.arrowView.frame = CGRect(x: 50, y: Screen.h-88, width: 40, height: 40)
            }
        }
    }
}
