//
//  ProfileViewController.swift
//  mesenger
//
//  Created by marco alonso on 01/12/20.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    let data = ["Log Out"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
      }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cerrar Sesion", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else {return}
            //MARK: - Cerrar sesion en Facebook & Firebase
            
            FBSDKLoginKit.LoginManager().logOut()
            
            //cerrar sesion de Google
            GIDSignIn.sharedInstance()?.signOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
            }
            catch {
                print("Error al cerrar sesion")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
        
    }
    
}
