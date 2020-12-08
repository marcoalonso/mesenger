//
//  AppDelegate.swift
//  mesenger
//
//  Created by marco alonso on 01/12/20.
//

import UIKit
import Firebase
import UIKit
import FBSDKCoreKit
import GoogleSignIn


@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
        
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                
            print("Error al iniciar sesion con Google \(error)")
            }
            return
        }
        
        guard let user = user else {
            return
        }
        
        print("Inicio sesion con Google \(user)")
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                // insert to dababase
                let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        //upload image
                        
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else {
                                return
                            }
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data,_,_ in
                                guard let data = data else {
                                    return
                                }
                                let filename = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("StorageManager error: \(error)")
                                    }
                                })
                            }).resume()
                        }
                    }
                })
            }
        })
        
        //MARK: - Acces token of Google
        guard let authentication = user.authentication else {
            print("Missing auth objetc of google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("Error al login con google")
                return
            }
            print("Logueado con Google correctamente!")
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            
        })
      }

      func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
          // Perform any operations when the user disconnects from app here.
          print("El usuario de Google se desconectó")
      }
    
}

