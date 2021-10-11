//
//  UpdateInfoUserVC.swift
//  demo_authen
//
//  Created by Bui Anh Phuong on 10/8/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UpdateInfoUserVC: UIViewController {
    
    @IBOutlet private weak var tfName: UITextField!
    @IBOutlet private weak var tfAge: UITextField!
    @IBOutlet private weak var tfAddress: UITextField!
    @IBOutlet private weak var tfPhone: UITextField!
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func submitInfo(_ sender: UIButton) {
        if let name = tfName.text, let age = tfAge.text, let address = tfAddress.text, let phone = tfPhone.text, let uid = Auth.auth().currentUser?.uid {
            let user = User(uid: uid, name: name, age: age, address: address, phoneNumber: phone)
           
            
            ref = db.collection("users").addDocument(data: user.dict ?? [:], completion: { (error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let vc = storyBoard.instantiateViewController(withIdentifier: "ListUserVC") as? ListUserVC {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }

}

class User: Encodable {
    var uid: String
    var name: String
    var age: String
    var address: String
    var phoneNumber: String
    
    init(uid: String, name: String, age: String, address: String, phoneNumber: String ) {
        self.uid = uid
        self.name = name
        self.age = age
        self.address = address
        self.phoneNumber = phoneNumber
    }
}

extension Encodable {
    var dict: [String : Any]? {
        guard let data = try? JSONEncoder().encode(self)  else {
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
