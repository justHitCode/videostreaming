//
//  MainViewController.swift
//  OpenLive
//
//  Created by GongYuhua on 6/25/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit
import AgoraRtcKit


struct AgoraRtcKitprofile:Decodable{
  //   var response:String!
    var responseString:String!
    var channelName:String!
    var group_id:String!
    var session_admin_flag:String!
    var group_name:String!
}
var chanelnamestring1:String=""
  var group_idstring1:String!
  var session_admin_flagstring1:String!
  var group_namestring1:String!

class MainViewController: UIViewController {
    var chanelnamestring:String!
    var group_idstring:String!
     var session_admin_flagstring:String!
    var group_namestring:String!
    
  
    
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var logoTop: NSLayoutConstraint!
    @IBOutlet weak var inputTextFieldTop: NSLayoutConstraint!
    
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()
    
    private var settings = Settings()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let parameters = ["appid":"7039e080cec2e88938e9a73f0e9e12c2b1a6","userid":"1a2082fdd2ad57a1e353ff8a6d713843","agenda_id":"2"] as [String : Any]
 guard let url = URL(string:"http://check.webmobi.in:3000/api/user/stream_information")
      else{
                                               print("Error")
                                               return
                                           }

                                           var request = URLRequest(url: url)
                        request.httpMethod="post"
                                           request.addValue("application/json", forHTTPHeaderField: "content-Type")
                          //  request.setValue(tokenexhibittorloggedin1, forHTTPHeaderField:"token")
                                           guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                                               return
                                           }
                                           request.httpBody = httpBody
                                           let session = URLSession.shared
                                           session.dataTask(with: request){ (data,response,error)in
                                               if let response = response{
                                         

                                               }
                                               if let data = data {
                                                   print(data)
                                                   do {
                                                       let json = try JSONSerialization.jsonObject(with: data, options: [])
                                   print(json)
                                                let AgoraRtcKitprofile1 = try JSONDecoder().decode(AgoraRtcKitprofile.self, from: data)
                                                    if AgoraRtcKitprofile1.channelName.isEmpty{
                                                        
                                                    }else{
                                                         self.chanelnamestring=AgoraRtcKitprofile1.channelName
                                                    }
                                                    if AgoraRtcKitprofile1.group_id.isEmpty{
                                                                                                       
                                                                                                   }else{
                                                                                                         self.group_idstring=AgoraRtcKitprofile1.group_id
                                                                                                   }
                                                   if AgoraRtcKitprofile1.session_admin_flag.isEmpty{
                                                                                                                                                        
                                                                                                                                                    }else{
                                                                                                                                                          self.session_admin_flagstring=AgoraRtcKitprofile1.session_admin_flag
                                                                                                                                                    }
                                                    if AgoraRtcKitprofile1.group_name.isEmpty{
                                                                                                                                                                                                         
                                                                                                                                                                                                     }else{
                                                                                                                                                                                                           self.group_namestring=AgoraRtcKitprofile1.group_name
                                                                                                                                                                                                     }
                                                    group_namestring1=self.group_namestring
                                                    chanelnamestring1=self.chanelnamestring
                                                   group_idstring1=self.group_idstring
                                                   session_admin_flagstring1=self.session_admin_flagstring
                                                      
                                                   }catch{
                                                      print(error)
                                                   
                                                  }
                                              }
                                              if let error = error{
print(error)
                                              }
                      }.resume()
              
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputTextField.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier,
            segueId.count > 0 else {
            return
        }
        
        switch segueId {
        case "mainToSettings":
            let settingsVC = segue.destination as? SettingsViewController
            settingsVC?.delegate = self
            settingsVC?.dataSource = self
        case "mainToRole":
            let roleVC = segue.destination as? RoleViewController
            roleVC?.delegate = self
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.endEditing(true)
    }
    
    @IBAction func doStartButton(_ sender: UIButton) {
        if chanelnamestring1.isEmpty{
            
        }else{
         let roomName = chanelnamestring1
            if roomName.count > 0{
            settings.roomName = roomName
                   performSegue(withIdentifier: "mainToRole", sender: nil)
            
        } else {
                return
        }
        }
    }
    
    @IBAction func doExitPressed(_ sender: UIStoryboardSegue) {
    }
}

private extension MainViewController {
    func updateViews() {
        let key = NSAttributedString.Key.foregroundColor
        let color = UIColor(red: 156.0 / 255.0, green: 217.0 / 255.0, blue: 1.0, alpha: 1)
        let attributed = [key: color]
        let attributedString = NSMutableAttributedString(string: "CHANNEL NAME", attributes: attributed)
        inputTextField.attributedPlaceholder = attributedString
        
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowColor = UIColor.black.cgColor
        
        if UIScreen.main.bounds.height <= 568 {
            logoTop.constant = 69
            inputTextFieldTop.constant = 37
        }
    }
}

extension MainViewController: LiveVCDataSource {
    func liveVCNeedSettings() -> Settings {
        return settings
    }
    
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit {
        return agoraKit
    }
}

extension MainViewController: SettingsVCDelegate {
    func settingsVC(_ vc: SettingsViewController, didSelect dimension: CGSize) {
        settings.dimension = dimension
    }
    
    func settingsVC(_ vc: SettingsViewController, didSelect frameRate: AgoraVideoFrameRate) {
        settings.frameRate = frameRate
    }
}

extension MainViewController: SettingsVCDataSource {
    func settingsVCNeedSettings() -> Settings {
        return settings
    }
}

extension MainViewController: RoleVCDelegate {
    func roleVC(_ vc: RoleViewController, didSelect role: AgoraClientRole) {
        settings.role = role
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.endEditing(true)
        return true
    }
}
