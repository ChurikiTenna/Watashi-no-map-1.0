//
//  ViewController.swift
//  leaning
//
//  Created by Tenna on 1/27/2 R.
//  Copyright © 2 Reiwa Tenna. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift
import GoogleMobileAds

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var interstitial: GADInterstitial!
    let mapView = MKMapView()
    let introBtn = UIButton()
    var currentPosBtn = UIButton()
    var deletePinsBtn = UIButton(), deleteAllPinsBtn = UIButton()
    var settingBtn = UIButton()
    var hideTableBtn = UIButton(), hidePanelBtn = UIButton()
    var deletePinBtn = UIButton()
    var modifyPinBtn = UIButton()
    var panel1 = UIView(), panel2 = UIView()
    
    var locManager: CLLocationManager!
    var searchBar = UISearchBar()
    var searchCompleter = MKLocalSearchCompleter()
    let tableView = UITableView()
    var annotation = MKPointAnnotation()
    var editview = EditView()
    let settingView = SettingView()
    var imagepinview = UIImageView()
    let pinheight = 32, pinwidth = 24
    
    var pincount = 0
    var pininfoDisplayed = false
    var isExistingPin = false
    
    var pincoordinate = CLLocationCoordinate2D()
    var pintitle = String()
    var pinsubtitle = String()
    var pinimage = String()
    
    struct Pin {
        
        var coordinate = CLLocationCoordinate2D()
        var title = String()
        var subtitle = String()
        var image = String()
        
        init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: String) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            self.image = image
        }
    }
    var Pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 現在地を取得
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locManager.startUpdatingLocation()
            }
        }
        // マップを表示
        initMap()
        mapView.delegate = self
        mapView.frame = self.view.frame
        mapView.isZoomEnabled = true
        self.view.addSubview(mapView)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.mapLongPressed))
        mapView.addGestureRecognizer(longPress)

        // 現在地ボタン
        currentPosBtn = btnSetting(title: "現在地")
        currentPosBtn.frame = CGRect(x: 7, y: 80, width: 80, height: 30)
        self.mapView.addSubview(currentPosBtn)
        currentPosBtn.addTarget(self, action: #selector(ViewController.LocbtnTap), for: .touchDown)
        
        // pinを消去するボタン
        deletePinsBtn = btnSetting(title: "ピン消去")
        deletePinsBtn.frame = CGRect(x: 94, y: 80, width: 80, height:30)
        self.mapView.addSubview(deletePinsBtn)
        deletePinsBtn.addTarget(self, action: #selector(ViewController.deletePins), for: .touchDown)
        
        // 設定ボタン
        settingBtn = btnSetting(title: "")
        let image = UIImage(named: "setting.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 4.5, y: 2, width: 26, height: 26)
        settingBtn.frame = CGRect(x: Screen.w-42, y: 80, width: 35, height: 30)
        settingBtn.addSubview(imageView)
        self.mapView.addSubview(settingBtn)
        settingBtn.addTarget(self, action: #selector(ViewController.showSettingView), for: .touchDown)
        
        // SearchBar
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 7, y: 35, width: Screen.w-14, height: 40)
        searchBar.layer.cornerRadius = 15
        searchBar.clipsToBounds = true
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.placeholder = "入力して検索"
        searchBar.layer.borderColor = UserSetting.color3?.cgColor
        searchBar.layer.borderWidth = 3
        self.mapView.addSubview(searchBar)
        
        // tableView
        tableView.delegate = self
        tableView.dataSource = self
        searchCompleter.delegate = self
        
        // tableViewを隠すボタン
        hideTableBtn = btnSetting(title: "隠す")
        self.view.addSubview(hideTableBtn)
        hideTableBtn.addTarget(self, action: #selector(ViewController.HideTable), for: .touchDown)
        hideTableBtn.isHidden = true
        
        //記録されているピンを表示
        let realm = try! Realm()
        
        for realm in realm.objects(PinItem.self) {
            
            let coordinate = CLLocationCoordinate2D(latitude: Double(realm.coordinateLat)!, longitude: Double(realm.coordinateLon)!)
            let customAnnotation = CustomAnnotation.init(coordinate: coordinate, title: realm.title!, subtitle: realm.subtitle ?? "", image: realm.image!)

            self.mapView.addAnnotation(customAnnotation)
        }
        // custom class
        registerMapAnnotationViews()
        
        //Google AdMob todo
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
        let request = GADRequest()
        self.interstitial.load(request)
        
        //初回起動時のチュートリアルラベル
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if(launchedBefore == true) {
            print("launchedbefore")
            launchedbefore()
        } else {
            print("firstlaunch")
            firstLaunch()
        }
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // annotationviewを登録
    func registerMapAnnotationViews() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotation.self))
    }
    // ボタンの基本設定
    func btnSetting(title: String) -> UIButton {
        
        let btn = UIButton()
        btn.setTitle(title, for:UIControl.State())
        btn.setTitleColor(UIColor.black, for: UIControl.State())
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UserSetting.color2?.cgColor
        btn.layer.borderWidth = 1.5
        
        return btn
    }
    //パネルを消す時のボタン設定
    func hidePanelBtnSetting() -> UIButton {
        let btn = UIButton()
        // パネルを消すボタン
        let imageB = UIImage(named: "batsu.png")
        let imageviewB = UIImageView(image: imageB)
        let imgWidthB:CGFloat = imageB!.size.width
        imageviewB.frame = CGRect(x: 0, y: 0, width: imgWidthB/1.4, height: imgWidthB/1.4)
        btn.addSubview(imageviewB)
        return btn
    }
    // 初回起動時のチュートリアルボタン
    func firstLaunch() {
        introBtn.setTitle("チュートリアルはこちらです", for: UIControl.State())
        introBtn.frame = CGRect(x: Screen.w/2-120, y: Screen.h-120, width: 240, height: 50)
        introBtnSetting()
    }
    // 二回目以降
    func launchedbefore() {
        introBtn.setTitle(" ?", for: UIControl.State())
        introBtn.frame = CGRect(x: -10, y: Screen.h-120, width: 50, height: 35)
        introBtnSetting()
    }
    //tutorialを表示するボタンの設定
    func introBtnSetting() {
        introBtn.setTitleColor(UIColor.black, for: UIControl.State())
        introBtn.backgroundColor = UIColor(white: 1, alpha: 0.8)
        introBtn.layer.cornerRadius = 10
        introBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(introBtn)
        introBtn.addTarget(self, action: #selector(ViewController.tutorial), for: .touchDown)
    }
    // tutoへ移動
    @objc func tutorial() {
        print("begin tuto")
        btnAnimation(btn: introBtn)
        performSegue(withIdentifier: "goNext", sender: nil)
    }
    
    // 現在地を取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        updateCurrentPos((locations.last?.coordinate)!)
    }
    //現在地に移動
    func updateCurrentPos(_ coordinate:CLLocationCoordinate2D) {
        var region:MKCoordinateRegion = mapView.region
        region.center = coordinate
        mapView.setRegion(region,animated:true)
        print("update userpos")
    }
    // マップの範囲を指定
    func initMap() {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated:true)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        print("initionlize map")
    }
    // ボタンが押された時のアニメーション
    func btnAnimation(btn: UIButton) {
        btn.setTitleColor(UIColor.gray, for: UIControl.State())
        btn.alpha = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            UIView.animate(withDuration: 0.5){
                btn.setTitleColor(UIColor.black, for: UIControl.State())
                btn.alpha = 1
            }
        }
    }
    //地図を現在地に移動
    @objc func LocbtnTap() {
        
        btnAnimation(btn: currentPosBtn)
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locManager.startUpdatingLocation()
            }
        }
        initMap()
    }
    //ピンを消去するボタンを表示
    @objc func deletePins() {
        deletePinsBtn.isEnabled = false
        // 押されたボタン
        btnAnimation(btn: deletePinsBtn)
        // 詳細パネルがあれば隠す
        if panel2.frame == CGRect(x: 6, y: Screen.h/2+100, width: Screen.w-12, height: Screen.h/2) {
            self.panel2.removeFromSuperview()
            self.deletePinBtn.removeFromSuperview()
            self.modifyPinBtn.removeFromSuperview()
        }
        // 背景
        panel1 = addPanel(frame: CGRect(x: 7, y: 120, width: Screen.w-14, height: 60))
        // ピンを全て消去するボタン
        deleteAllPinsBtn = btnSetting(title: "ピンをすべて消去")
        deleteAllPinsBtn.addTarget(self, action: #selector(ViewController.deleteAllPins), for: .touchDown)
        // パネルを隠すボタン
        hidePanelBtn = hidePanelBtnSetting()
        hidePanelBtn.addTarget(self, action: #selector(ViewController.hideDeletingPanel), for: .touchDown)
        
        view.addSubview(panel1)
        view.addSubview(hidePanelBtn)
        view.addSubview(deleteAllPinsBtn)
        
        originOfDeletingPanel()
        
        UIView.animate(withDuration: 0.5) {
            self.panel1.frame = CGRect(x: 7, y: 120, width: Screen.w-14, height: 60)
            self.hidePanelBtn.frame = CGRect(x: 20, y: 135, width: 30, height: 30)
            self.deleteAllPinsBtn.frame = CGRect(x: 80, y: 130, width: 140, height: 40)
        }
    }
    // ピン消去のパネルのorigin
    func originOfDeletingPanel() {
        panel1.frame = CGRect(x: 7, y: -60, width: Screen.w-14, height: 60)
        hidePanelBtn.frame = CGRect(x: 20, y: -30, width: 30, height: 30)
        deleteAllPinsBtn.frame = CGRect(x: 80, y: -40, width: 140, height: 40)
    }
    // パネルを隠す
    @objc func hideDeletingPanel() {
        print("hidepanel")
        deletePinsBtn.isEnabled = true
        btnAnimation(btn: hidePanelBtn)
        // 上に移動
        UIView.animate(withDuration: 0.5) {
            self.originOfDeletingPanel()
        }
    }
    //ピンを全て消去
    @objc func deleteAllPins() {
        btnAnimation(btn: deleteAllPinsBtn)
        let alertController: UIAlertController = UIAlertController(title:"ピンを全て消去しますか？", message: "", preferredStyle: .alert)
        // Defaultのaction
        let defaultAction: UIAlertAction = UIAlertAction(title: "消去", style: .default, handler:{ (action:UIAlertAction!) -> Void in
                                    self.hideDeletingPanel()
                                    let realm = try! Realm()
                                    try! realm.write { realm.delete(realm.objects(PinItem.self))
                                    }
                                    let annotations = self.mapView.annotations
                                    self.mapView.removeAnnotations(annotations)
                })
        // Cancelのaction (何もしない)
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action:UIAlertAction!) -> Void in })
        
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    //候補テーブルを非表示
    @objc func HideTable() {
        tableView.isHidden = true
        hideTableBtn.isHidden = true
    }
    
    @objc func showSettingView() {
        btnAnimation(btn: settingBtn)
        settingView.frame = CGRect(x: 0, y: Screen.h, width: Screen.w, height: Screen.h)
        // SettingViewを出す
        UIView.animate(withDuration: 0.5) {
            self.settingView.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        }
        settingView.cancelBtn.addTarget(self, action: #selector(ViewController.hideSettingView), for: .touchDown)
        settingView.createBtn.addTarget(self, action: #selector(ViewController.changeSetting), for: .touchDown)
        view.addSubview(settingView)
    }
    // 設定パネルを閉じる
    @objc func hideSettingView() {
        btnAnimation(btn: settingView.cancelBtn)
        settingView.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        // SettingViewを隠す
        UIView.animate(withDuration: 0.5) {
            self.settingView.frame = CGRect(x: 0, y: Screen.h, width: Screen.w, height: Screen.h)
        }
    }
    // 変更を反映
    @objc func changeSetting() {
        UserSetting.color1 = settingView.btn1.backgroundColor
        UserSetting.color2 = settingView.btn2.backgroundColor
        UserSetting.color3 = settingView.btn3.backgroundColor
        let colorArray: [UIColor] = [UserSetting.color1!, UserSetting.color2!, UserSetting.color3!]
        
        let realm = try! Realm()
        // 前の色情報を消す
        try! realm.write {
            realm.delete(realm.objects(ThemeColor.self))
        }
        // 新しい色を保存
        var index = 0
        for color in colorArray {
            let themeColor = ThemeColor()
            let r: String = NSString(format: "%.7f", color.rgba.r) as String
            let g: String = NSString(format: "%.7f", color.rgba.g) as String
            let b: String = NSString(format: "%.7f", color.rgba.b) as String
            themeColor.r = r
            themeColor.g = g
            themeColor.b = b
            try! realm.write {
                realm.add(themeColor)
            }
            index += 1
        }
        
        let userPin = UserPin()
        
        switch settingView.selectedPin {
        case settingView.btnB:
            UserSetting.pinImage = "hitoB.png"
        case settingView.btnY:
            UserSetting.pinImage = "hitoY.png"
        default:
            UserSetting.pinImage = "hitoP.png"
        }
        userPin.name = UserSetting.pinImage
        // Databaseに追加
        try! realm.write {
            realm.delete(realm.objects(UserPin.self))
            realm.add(userPin)
        }
        // reset
        mapView.showsUserLocation = false
        mapView.removeAnnotations(mapView.annotations)
        loadView()
        viewDidLoad()
        editview = EditView()
        hideSettingView()
    }
}

extension ViewController: MKMapViewDelegate{
    
    @objc func mapLongPressed(sender: UILongPressGestureRecognizer) {
        
        let location: CGPoint = sender.location(in: mapView)
        
        if (sender.state == UIGestureRecognizer.State.began){
            print("map longpressed!")
            let mapPoint: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
            annotation.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
            pincoordinate = annotation.coordinate
            mapView.addAnnotation(annotation)
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: mapPoint.latitude, longitude: mapPoint.longitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemarks = placemarks {
                    if let pm = placemarks.first {
                        self.annotation.title = "\(pm.name ?? "")"
                        self.annotation.subtitle = "\(pm.subThoroughfare ?? "") \(pm.thoroughfare ?? "") \(pm.subLocality ?? "") \(pm.locality ?? "") \(pm.subAdministrativeArea ?? "") \(pm.administrativeArea ?? "") \(pm.postalCode ?? "") \(pm.country ?? "")"
                    }
                }
            }
        }
    }
    // annotationをタップされた時
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        searchBar.resignFirstResponder()
        hideDeletingPanel()
        hideDetailPanel()
        pincoordinate = view.annotation!.coordinate
        
        if view.annotation is CustomAnnotation {
            // detailOpenに渡す用
            let realm = try! Realm()
            let lat = String(pincoordinate.latitude)
            let lon = String(pincoordinate.longitude)
            let predicate = NSPredicate(format: "coordinateLat == %@ AND coordinateLon == %@", lat, lon)
            let pininfo = realm.objects(PinItem.self).filter(predicate).first
            pintitle = pininfo!.title!
            pinsubtitle = pininfo!.subtitle ?? ""
            pinimage = pininfo!.image!
        }
        print("annotation tapped!")
    }
    // annotationview表示
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var isInUserLoc = false
        if annotation is MKUserLocation { isInUserLoc = true }
        
        var view: MKAnnotationView
        // カスタムビュー
        if let annotation = annotation as? CustomAnnotation {
            let identifier = "custompin"
            if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                view = customAnnotationView
                view.annotation = annotation
            } else {
                view = setupCustomView(for: annotation, on: mapView)
            }
            //もし現在地ならhitoも表示する
            if isInUserLoc == true {
                view.image = UIImage(named: UserSetting.pinImage!)
            }
            return view
        }
        // 現在地ビュー
        if isInUserLoc == true {
            let askButton = UIButton()
            let view = annotationViewSetting(title: "＋", askButton: askButton)
            askButton.addTarget(self, action: #selector(ViewController.showEditView), for: .touchDown)
            print("set userpos image")
            view.image = UIImage(named: UserSetting.pinImage!)
            return view
        }
        // 通常ビュー
        let identifier = "marker"
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView as! MKMarkerAnnotationView
        } else {
            view = setUpMKAnnotationView(for: annotation, on: mapView)
        }

        pincoordinate = view.annotation!.coordinate
        return view
    }
    //Defaultピンを作成
    func setUpMKAnnotationView(for annotation: MKAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        print("default view")
        let askButton = UIButton()
        let view = annotationViewSetting(title: "＋", askButton: askButton)
        askButton.addTarget(self, action: #selector(ViewController.showEditView), for: .touchDown)
        view.image = UIImage(named: "redpin-1.png")
        return view
    }
    //カスタムピンを作成
    func setupCustomView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        print("custom view")
        let askButton = UIButton()
        let view = annotationViewSetting(title: "詳細", askButton: askButton)
        pintitle = annotation.title!
        pinsubtitle = annotation.subtitle!
        pincoordinate = annotation.coordinate
        view.image = UIImage(named: annotation.image!)
        askButton.addTarget(self, action: #selector(ViewController.detailOpen), for: .touchDown)
        return view
    }
    // annotationviewの設定
    func annotationViewSetting(title: String, askButton: UIButton) -> MKAnnotationView {
        let view = MKAnnotationView()
        
        view.annotation = annotation
        // callout
        view.canShowCallout = true
        view.centerOffset = CGPoint(x: 0, y: -20)
        askButton.setTitle(title, for:UIControl.State())
        askButton.setTitleColor(UIColor.black, for:UIControl.State())
        askButton.backgroundColor = UIColor(white:0.95, alpha: 1)
        askButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        askButton.sizeToFit()
        askButton.layer.cornerRadius = 15.0
        view.rightCalloutAccessoryView = askButton
        //影
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.cgColor
        view.sizeThatFits(CGSize(width: 24, height: 32))
        let shadowPath = CGPath(ellipseIn:
            CGRect(x: 4, y: 18, width: 20, height: 20), transform: nil)
        view.layer.shadowPath = shadowPath
        
        return view
    }
    // 詳細ボタンを押したときに出る
    @objc func detailOpen() {
        //ピン消去のパネルがあれば隠す
        if panel1.frame == CGRect(x: 7, y: 120, width: Screen.w-14, height: 60) {
            hideDeletingPanel()
        }
        // 前のパネルがあれば隠す
        if panel2.frame == CGRect(x: 6, y: Screen.h/2+100, width: Screen.w-12, height: Screen.w/2) {
            print("hideprevious!!")
            panel2.removeFromSuperview()
            deletePinBtn.removeFromSuperview()
            modifyPinBtn.removeFromSuperview()
            hidePanelBtn.removeFromSuperview()
        }
        //タイトルとサブタイトルの下のパネル
        panel2 = addPanel(frame: CGRect(x: 6, y: Screen.h/2+100, width: Screen.w-12, height: Screen.h/2))
        // タイトルラベルのbackground
        let frame1 = CGRect(x: 10, y: 10, width: Screen.w-32, height: 35)
        let back1 = labelBackground(frame: frame1)
        panel2.addSubview(back1)
        // タイトルを表示
        let titleLabel = UITextView()
        titleLabel.isEditable = false
        titleLabel.text = pintitle
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.frame = CGRect(x: 20, y: 12, width: Screen.w-52, height: 31)
        panel2.addSubview(titleLabel)
        
        // サブタイトルラベルのbackground
        let frame2 = CGRect(x: 10, y: 55, width: Screen.w-32, height: Screen.h/2-220)
        let back2 = labelBackground(frame: frame2)
        panel2.addSubview(back2)
        // サブタイトルを表示
        let subtitleLabel = UITextView()
        subtitleLabel.isEditable = false
        subtitleLabel.text = pinsubtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.frame = CGRect(x: 20, y: 57, width: Screen.w-52, height: Screen.h/2-225)
        panel2.addSubview(subtitleLabel)
        
        // 消去ボタン
        deletePinBtn = btnSetting(title: "")
        let image1 = UIImage(named: "bin.png")
        let imageView = UIImageView(image: image1)
        imageView.frame = CGRect(x: 3.5, y: 4.5, width: 25, height: 25)
        deletePinBtn.addSubview(imageView)
        deletePinBtn.addTarget(self, action: #selector(ViewController.deletePin), for: .touchDown)
        // ピンを編集するボタン
        modifyPinBtn = btnSetting(title: "")
        let image2 = UIImage(named: pinimage)
        let imageview = UIImageView(image: image2)
        imageview.frame = CGRect(x: 7, y: 5.5, width: 18, height: 24)
        modifyPinBtn.addSubview(imageview)
        modifyPinBtn.addTarget(self, action: #selector(ViewController.modifyPlace), for: .touchDown)
        // パネルを消すボタン
        hidePanelBtn = hidePanelBtnSetting()
        hidePanelBtn.addTarget(self, action: #selector(ViewController.hideDetailPanel), for: .touchDown)
        
        view.addSubview(panel2)
        view.addSubview(deletePinBtn)
        view.addSubview(modifyPinBtn)
        view.addSubview(hidePanelBtn)
        
        // アニメーションで表示
        originOfDetailPanel()
        UIView.animate(withDuration: 0.5) {
            self.panel2.frame = CGRect(x: 6, y: Screen.h/2+100, width: Screen.w-12, height: Screen.h/2)
            self.deletePinBtn.frame = CGRect(x: 30, y: Screen.h-57, width: 32, height: 35)
            self.modifyPinBtn.frame = CGRect(x: 80, y: Screen.h-57, width: 32, height: 35)
            self.hidePanelBtn.frame = CGRect(x: Screen.w-60, y: Screen.h-52, width: 30, height: 30)
        }
    }
    
    func originOfDetailPanel() {
        panel2.frame = CGRect(x: 6, y: Screen.h, width: Screen.w-12, height: Screen.h)
        deletePinBtn.frame = CGRect(x: 30, y: Screen.h, width: 32, height: 35)
        modifyPinBtn.frame = CGRect(x: 80, y: Screen.h, width: 32, height: 35)
        hidePanelBtn.frame = CGRect(x: Screen.w-60, y: Screen.h, width: 30, height: 30)
    }
    // ピンの内容を変更
    @objc func modifyPlace() {
        btnAnimation(btn: modifyPinBtn)
        editview.textField.text = pintitle
        editview.memoText.text = pinsubtitle
        isExistingPin = true
        
        hideDetailPanel()
        showEditView()
    }
    // Detailpanelを閉じる
    @objc func hideDetailPanel() {
        print("hide detail panel")
        btnAnimation(btn: hidePanelBtn)
        UIView.animate(withDuration: 0.5) {
            self.originOfDetailPanel()
        }
    }
    // textlabelsの後ろ
    func labelBackground(frame: CGRect) -> UILabel {
        let labelBack = UILabel()
        labelBack.frame = frame
        labelBack.backgroundColor = UIColor.white
        labelBack.layer.cornerRadius = 10
        labelBack.clipsToBounds = true
        labelBack.layer.borderWidth = 2
        labelBack.layer.borderColor = UserSetting.color2?.cgColor
        return labelBack
    }
    // 影付きパネルを追加
    func addPanel(frame: CGRect) -> UIView {
        let panel = UIView()
        panel.frame = frame
        panel.backgroundColor = UserSetting.color1
        panel.center = view.center
        panel.layer.cornerRadius = 10
        panel.layer.masksToBounds = false
        
        panel.layer.borderColor = UserSetting.color3?.cgColor
        panel.layer.borderWidth = 3

        panel.layer.shadowColor = UIColor.black.cgColor
        panel.layer.shadowOffset = CGSize(width: 0, height: 2)
        panel.layer.shadowOpacity = 0.4
        panel.layer.shadowRadius = 4

        panel.layer.shadowPath = UIBezierPath(roundedRect: panel.bounds, cornerRadius: 10).cgPath
        panel.layer.shouldRasterize = true
        panel.layer.rasterizationScale = UIScreen.main.scale
        
        return panel
    }
    // 選択されたピンを消去
    @objc func deletePin(for annotation: CustomAnnotation) {
        
        btnAnimation(btn: deletePinBtn)
        
        let alertController: UIAlertController = UIAlertController(title:"ピンを消去しますか？", message: "", preferredStyle: .alert)
        // Defaultのaction
        let defaultAction: UIAlertAction = UIAlertAction(title: "消去", style: .default, handler:{ (action:UIAlertAction!) -> Void in
                self.hideDetailPanel()
                //タップしたピンとおなじ位置にあるピンを消去（＝タップしたピンを消去）
                for annotation in self.mapView.annotations {
                    if annotation.coordinate.latitude == self.pincoordinate.latitude,
                        annotation.coordinate.longitude == self.pincoordinate.longitude {
                        self.mapView.removeAnnotation(annotation)
                        }
                    }
                    let lat = String(self.pincoordinate.latitude)
                    let lon = String(self.pincoordinate.longitude)
                    
                    let realm = try! Realm()
                    let predicate = NSPredicate(format: "coordinateLat == %@ AND coordinateLon == %@", lat, lon)
                    let pininfo = realm.objects(PinItem.self).filter(predicate)
                    
                    try! realm.write { realm.delete(pininfo) }
                })
        // Cancelのaction (何もしない)
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action:UIAlertAction!) -> Void in })
        
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    // EditViewを出す
    @objc func showEditView() {
        hideDetailPanel()
        hideDeletingPanel()
        
        editview.frame = CGRect(x: 0, y: Screen.h, width: Screen.w, height: Screen.h)
        // EditViewを出す
        UIView.animate(withDuration: 0.5) {
            self.editview.frame = CGRect(x: 0, y: 0, width: Screen.w, height: Screen.h)
        }
        // editviewのボタンにアクションを追加
        editview.createBtn.addTarget(self, action: #selector(ViewController.Create), for: .touchDown)
        editview.hidePanelBtn.addTarget(self, action: #selector(ViewController.hideEditView), for: .touchDown)
        
        view.addSubview(editview)
        
        // pinimageの表示 (ピンの編集ならそのピンの画像をeditviewに表示)
        if isExistingPin == true {
            UserSetting.pinColor = pinimage
        }
        imagepinview = UIImageView(image: UIImage(named: UserSetting.pinColor))
        imagepinview.frame = CGRect(x: 50, y: 175-pinheight/2, width: pinwidth, height: pinheight)
        editview.addSubview(imagepinview)
        
        // titleに入力がなければ完了ボタンはfalse
        if editview.textField.text == "" {
            editview.createBtn.isEnabled = false
            editview.createBtn.setTitleColor(UIColor.gray, for:.normal)
        }
        // メモ欄に入力がなければplaceholderを表示
        if editview.memoText.text == "" {
            editview.memoPlaceholder.isHidden = false
        }
    }
    // pinimageを変更
    @objc func changePin() {
        // 以前のを消去
        imagepinview.removeFromSuperview()
        // 追加
        imagepinview = UIImageView(image: UIImage(named: UserSetting.pinColor))
        imagepinview.frame = CGRect(x: 50, y: 175-pinheight/2, width: pinwidth, height: pinheight)
        editview.addSubview(imagepinview)
        
        // titleに入力がなければ完了ボタンはfalse
        if editview.textField.text == "" {
            editview.createBtn.isEnabled = false
            editview.createBtn.setTitleColor(UIColor.gray, for:.normal)
        }
    }
    // ピンを追加
    @objc func Create() {
        btnAnimation(btn: editview.createBtn)
        
        //Google AdMob
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else { print("ad failed") }
        
        // 保存
        let realm = try! Realm()
        let pinItem = PinItem()
        pinItem.coordinateLat = String(pincoordinate.latitude)
        pinItem.coordinateLon = String(pincoordinate.longitude)
        pinItem.title = editview.textField.text!
        pinItem.subtitle = editview.memoText.text!
        pinItem.image = UserSetting.pinColor
        
        // 同じ場所にあるピンをマップから消す
        for annotation in mapView.annotations {
            if annotation.coordinate.latitude == pincoordinate.latitude,
                annotation.coordinate.longitude == pincoordinate.longitude {
                self.mapView.removeAnnotation(annotation)
                }
        }
        // 新しいピンをmapViewに追加
        let customAnnotation = CustomAnnotation.init(coordinate: pincoordinate, title: editview.textField.text!, subtitle: editview.memoText.text!, image: UserSetting.pinColor)
        self.mapView.addAnnotation(customAnnotation)
        self.mapView.removeAnnotation(self.annotation)
        
        // 同じ場所にあるピンをRealmで探す
        let predicate = NSPredicate(format: "coordinateLat == %@ AND coordinateLon == %@", pinItem.coordinateLat, pinItem.coordinateLon)
        let result = realm.objects(PinItem.self).filter(predicate).first
        // Databaseに追加/元あったピンを消去
        try! realm.write {
            if result != nil { realm.delete(result!) }
            realm.add(pinItem)
        }
        
        initEditView()
        
        print("created!!")
    }
    // editviewの編集内容を破棄
    @objc func hideEditView() {
        print("hide editview")
        btnAnimation(btn: editview.hidePanelBtn)
        // タイトルが空欄ならそのまま閉じる
        if editview.textField.text != "" {
            let alertController:UIAlertController = UIAlertController(title:"編集内容を破棄しますか？", message: "", preferredStyle: .alert)
            // Defaultのaction (パネルを隠す）
            let defaultAction:UIAlertAction = UIAlertAction(title: "消去", style: .default, handler:{ (action:UIAlertAction!) -> Void in
                        self.initEditView()
                    })
            // Cancelのaction (何もしない)
            let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action:UIAlertAction!) -> Void in
            })
            
            // actionを追加
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            initEditView()
        }
    }
    // EditView 初期化 & 隠す
    func initEditView() {
        
        editview.textField.resignFirstResponder()
        editview.memoText.resignFirstResponder()
        isExistingPin = false
        UserSetting.pinColor = "redpin-1.png"
        editview.textField.text = ""
        editview.memoText.text = ""
        
        UIView.animate(withDuration: 0.5) {
            self.editview.frame = CGRect(x: 0, y: Screen.h, width: Screen.w, height: Screen.h)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    // 検索バーが変更された時
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("searchBar text changed")
        // 初期化
        Pins = [Pin]()
        searchBar.showsCancelButton = true
        pininfoDisplayed = false
        
        guard let text = searchBar.text else { return false }
        searchCompleter.queryFragment = text
        
        // realmのピンをタイトルから検索
        let realm = try! Realm()
        let predicate = NSPredicate(format: "title CONTAINS %@", text)
        let results = realm.objects(PinItem.self).filter(predicate)
        pincount = results.count
        
        if pincount != 0 {
            var index = 0
            for result in results {
                Pins.append(Pin(coordinate: CLLocationCoordinate2D(latitude: Double(result.coordinateLat)!, longitude: Double(result.coordinateLon)!), title: result.title!, subtitle: result.subtitle!, image: result.image!))
                print(index)
                index += 1
            }
        }
        return true
    }
    
    // Searchクリック
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        tableView.isHidden = true
        hideTableBtn.isHidden = true
        searchBar.resignFirstResponder()
        
        // Search request
        searchMap()
        self.view.endEditing(true)
        
        print("search button clicked")
    }
    
    // キャンセルボタンタップ時に呼び出される
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        tableView.isHidden = true
        hideTableBtn.isHidden = true
    }
    // Search request
    func searchMap() {
        
        // Activity Indicator
        let indicater = UIActivityIndicatorView()
        indicater.style = UIActivityIndicatorView.Style.medium
        indicater.center = self.view.center
        indicater.hidesWhenStopped = true
        indicater.startAnimating()
        self.view.addSubview(indicater)
        // Request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        let activeSearch = MKLocalSearch(request: request)
        activeSearch.start { response, error in
            indicater.stopAnimating()
            response?.mapItems.forEach { item in
                print("search.start is called")
                // Locationを取得
                let lat = response?.boundingRegion.center.latitude
                let lon = response?.boundingRegion.center.longitude
                // Annotationを追加
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: lat!, longitude: lon!)
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let placemarks = placemarks {
                        if let pm = placemarks.first {
                            self.annotation.title = self.searchBar.text
                            self.annotation.subtitle = "\(pm.subThoroughfare ?? "") \(pm.thoroughfare ?? "") \(pm.subLocality ?? "") \(pm.locality ?? "") \(pm.subAdministrativeArea ?? "") \(pm.administrativeArea ?? "") \(pm.postalCode ?? "") \(pm.country ?? "")"
                        }
                    }
                }
                self.annotation.coordinate = CLLocationCoordinate2DMake(lat!, lon!)
                self.mapView.addAnnotation(self.annotation)
                // ズームイン
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lon!)
                let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        hideDeletingPanel()
        hideDetailPanel()
        print("Found = ", searchCompleter.results.count)
        self.view.addSubview(tableView)
        return 1
    }
    // 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfRows = searchCompleter.results.count
        var tableheight = 0
        hideTableBtn.isHidden = false
        // Realmの候補の数を足す
        numOfRows += pincount
        // サブタイトルがなければ高さをその分低く
        for pin in Pins {
            if pin.subtitle == "" {
                tableheight = -11
            }
        }
        
        tableheight += numOfRows*58-1
        // キーボードで隠れない高さに
        if tableheight >= Int(Screen.h/2)-30 {
            tableheight = Int(Screen.h/2)-30
        }
        
        tableView.frame = CGRect(x: 7, y: 80, width: Int(Screen.w)-14, height: tableheight)
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 15
        
        hideTableBtn.frame = CGRect(x: 7, y: tableheight+85, width: Int(Screen.w)-14, height: 30)
        
        if (numOfRows == 0) { hideTableBtn.isHidden = true }
        
        return numOfRows
    }
    // 行の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.isHidden = false
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil) { cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell") }
        // Realmに保存されているピンを候補として表示
        if pincount != 0, pincount > indexPath.row {
            print("showing pininfo")
            cell?.textLabel?.text = Pins[indexPath.row].title
            cell?.detailTextLabel!.text = Pins[indexPath.row].subtitle
            cell?.imageView!.image = UIImage(named: Pins[indexPath.row].image)
            pininfoDisplayed = true
        } else {
            cell?.textLabel?.text = searchCompleter.results[indexPath.row-pincount].title
            cell?.detailTextLabel!.text = searchCompleter.results[indexPath.row-pincount].subtitle
            cell?.imageView!.image = nil
        }
        searchBar.showsCancelButton = true
        
        return cell!
    }
    // Row selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isHidden = true
        hideTableBtn.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.text = searchCompleter.results[indexPath.row].title
        // Annotationを選ばれた時
        if indexPath.row < pincount {
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: Pins[indexPath.row].coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        } else {
            // 通常検索
            searchMap()
        }
        Pins = [Pin]()
    }
}

extension ViewController: MKLocalSearchCompleterDelegate {
     
    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
        print("update result")
    }
    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("could not update result")
    }
}
