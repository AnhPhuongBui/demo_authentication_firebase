//
//  ListUserVC.swift
//  demo_authen
//
//  Created by Bui Anh Phuong on 10/11/21.
//

import UIKit
import FirebaseFirestore
class ListUserVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var listUser: [User] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    private func getUser() {
        db.collection("users").getDocuments(){(querySnapshot, error) in
            if let err = error {
                print("Error getting: \(err)")
            } else {
                for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                
                        }
            }
        }
    }
}
