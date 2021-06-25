//
//  ProfileController.swift
//  StreamFlow
//
//  Created by Irakli Lomidze on 20.06.21.
//

import UIKit
import GoogleSignIn



class ProfileController: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var signInBtn: GIDSignInButton! // It is actually in a view
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var signOutView: UIView!
    @IBOutlet weak var signOutBtnG: UIButton!
    @IBOutlet weak var underlineNameLabel: UILabel!
    @IBOutlet weak var deleteContinueMoviesBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        
        signOutView.layer.cornerRadius = 10
        signOutView.layer.borderWidth = 0.5
        signOutView.layer.borderColor = UIColor.blue.cgColor
        deleteContinueMoviesBtn.layer.borderWidth = 0.3
        deleteContinueMoviesBtn.layer.borderColor = UIColor.gray.cgColor
        deleteContinueMoviesBtn.layer.cornerRadius = 10
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        
        if GIDSignIn.sharedInstance().currentUser != nil {
            print("ProfileController: ", "user exists")
            print("ProfileController: ", GIDSignIn.sharedInstance().currentUser.userID!)
            userNameLabel.isHidden = false
            signInBtn.isHidden = true
            signOutView.isHidden = false
            underlineNameLabel.isHidden = false
            userNameLabel.text = GIDSignIn.sharedInstance().currentUser.profile.name
        } else if GIDSignIn.sharedInstance().hasPreviousSignIn() {
            GIDSignIn.sharedInstance().restorePreviousSignIn()
        }
    }
    
    
    @IBAction func signOutBtnAction(_ sender: Any) {
        userNameLabel.isHidden = true
        signOutView.isHidden = true
        underlineNameLabel.isHidden = true
        signInBtn.isHidden = false
        FirestoreManager.setUserID(id: "")
        ContinueWatchingData.eraseData()
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil {
            userNameLabel.isHidden = false
            signOutView.isHidden = false
            underlineNameLabel.isHidden = false
            signInBtn.isHidden = true
        
            userNameLabel.text = user.profile.name
            
            FirestoreManager.setUserID(id: user.userID)
            
            let firestoreManager = FirestoreManager()
            firestoreManager.updateDataFromUserDefaults()
            
            print("ProfileController: ", "Sign In Success") // TODO: Debug remove
            print("ProfileController: ", user.userID!) // TODO: Debug remove
        } else {
            print("ProfileController: ", "NO user exists") // TODO: Debug remove
            return
        }
    }
    
    @IBAction func deleteContinueMoviesBtnAction(_ sender: Any) {
        
    }
    
    
    // END CLASS
}
