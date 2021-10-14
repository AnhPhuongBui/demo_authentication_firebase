//
//  ViewController.swift
//  demo_authen
//
//  Created by Bui Anh Phuong on 10/5/21.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    @IBOutlet private weak var lbStatus: UILabel!
    @IBOutlet private weak var btnSignIn: UIButton!
    @IBOutlet private weak var btnSignUp: UIButton!
    @IBOutlet private weak var tfEmail: UITextField!
    @IBOutlet private weak var tfPassWord: UITextField!
    
    var isLogin: Bool = false {
        didSet {
            if isLogin {
                btnSignIn.setTitle("Sign Out", for: .normal)
                btnSignUp.isEnabled = false
            } else {
                btnSignUp.isEnabled = true
                btnSignIn.setTitle("Sign In", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = Auth.auth().currentUser {
            // logout
           signOut()
        }
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
//        guard let email = tfEmail.text, let pass = tfPassWord.text else { return }
        let email = "phuong.bui@tda.company"
        let pass = "12345678"
        Auth.auth().createUser(withEmail: email, password: pass) {[weak self] (authResult, error) in
            if let error = error{
                self?.lbStatus.text = "Error: \(error.localizedDescription)"
            } else {
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                        print(errorCode)
                        self?.lbStatus.text = "Error: \(error.localizedDescription)"
                        self?.signOut()
                    }  else {
                        self?.isLogin = true
                        self?.lbStatus.text = "User signs up successfully, please check email "
                    }
                })
                
            }
        }
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
//        guard let email = tfEmail.text, let pass = tfPassWord.text else { return }
        let email = "phuong.bui@tda.company"
        let pass = "12345678"
        if let _ = Auth.auth().currentUser {
            // logout
           signOut()
            return
        }
        Auth.auth().signIn(withEmail: email, password: pass) {[weak self] (authResult, error) in
            if let error = error{
                self?.lbStatus.text = "Error: \(error.localizedDescription)"
            } else {
                if let user = Auth.auth().currentUser, user.isEmailVerified {
                    self?.lbStatus.text = "User verified email and login successfully"
                    self?.isLogin = true
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let vc = storyBoard.instantiateViewController(withIdentifier: "UpdateInfoUserVC") as? UpdateInfoUserVC {
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }  else {
                    self?.lbStatus.text = "The user hasn't verified email"
                    self?.signOut(isShowStatus: false )
                }
            }
        }
    }
     
    private  func signOut(isShowStatus: Bool = true ) {
        do {
            try Auth.auth().signOut()
            isLogin = false
            if isShowStatus  {
                self.lbStatus.text = "Sing out successfully"
            }
        } catch {
            self.lbStatus.text = "Sign out error"
        }
    }
}

