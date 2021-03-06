//
//  ListUserVC.swift
//  demo_authen
//
//  Created by Bui Anh Phuong on 10/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import AVKit
class ListUserVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var viewVideo: UIView!
    
    var listUser: [User] = []
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var lastDocument: DocumentSnapshot? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "InfoUserCell", bundle: nil), forCellReuseIdentifier: "InfoUserCell")
        tableView.alwaysBounceVertical = false 
    }
    
    private func getUser() {
        db.collection("users").getDocuments(){[weak self](querySnapshot, error) in
            if let err = error {
                print("Error getting: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let user = User(from: document.data())
                    self?.listUser.append(user)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func orderByAge(_ sender: UIButton) {
        listUser.removeAll()
        db.collection("users").order(by: "age", descending: false).getDocuments { [weak self](querySnapshot, error) in
            if let err = error {
                print("Error getting: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let user = User(from: document.data())
                    self?.listUser.append(user)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func limitValue(_ sender: UIButton) {
        listUser.removeAll()
        let query = db.collection("users").order(by: "age", descending: false).limit(to: 3)
        
        query.getDocuments { [weak self](querySnapshot, error) in
            if let err = error {
                print("Error getting: \(err)")
            } else {
                self?.lastDocument = querySnapshot?.documents.last
                for document in querySnapshot!.documents {
                    let user = User(from: document.data())
                    self?.listUser.append(user)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func loadMore(_ sender: UIButton) {
//        Auth.auth().currentUser
//        if let _ = Auth.auth().currentUser {
//            // logout
//            do {
//                Auth.auth()
//                try Auth.auth().signOut()
//               
//            } catch {
//                print("Sign out error")
//            }
//        }
        guard let lastDocument = lastDocument else { return }
        let nextQuery  = db.collection("users").order(by: "age", descending: false).limit(to: 3).start(afterDocument: lastDocument)
        nextQuery.getDocuments { [weak self](querySnapshot, error) in
            if let err = error as NSError?, let errorCode = FirestoreErrorCode(rawValue: err.code)  {
                print(errorCode)
                print("Error getting: \(err)")
            } else {
                self?.lastDocument = querySnapshot?.documents.last
                for document in querySnapshot!.documents {
                    let user = User(from: document.data())
                    self?.listUser.append(user)
                }
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func downloadFile(_ sender: UIButton) {
        let storageRef = storage.reference()
        let videoRef = storageRef.child("event/video/Big_Buck_Bunny_1080_10s_1MB.mp4")
        
        //  1. Generate a download URL
//        videoRef.downloadURL { (url, error) in
//            if let error = error {
//                print("download error: \(error.localizedDescription)")
//            } else {
//                self.playVideo(url: url)
//            }
//        }
        // Download to local file
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first  else { return }
        let localURL = documentsUrl.appendingPathComponent("event/video.mp4")
        let _ = videoRef.write(toFile: localURL) { url, error in
            if let error = error  as NSError?, let errorCode = StorageErrorCode(rawValue: error.code){
                print(errorCode)
                print("download error: \(error.localizedDescription)")
            } else {
                self.playVideo(url: url)
            }
        }
    }
    func playVideo(url: URL?) {
        guard let videoUrl = url else { return }
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.viewVideo.bounds
        self.viewVideo.layer.addSublayer(playerLayer)
        player.play()
    }
}
extension ListUserVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoUserCell", for: indexPath) as? InfoUserCell else {
            return UITableViewCell()
        }
        cell.setUser(user: listUser[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    
}
