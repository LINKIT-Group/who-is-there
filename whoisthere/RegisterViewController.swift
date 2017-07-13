//
//  RegisterViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright (c) 2017 Efe Kocabas. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBAction func nextButtonClick(_ sender: Any) {
        
        
        var userData = UserData()
        let isUpdateScreen = userData.hasAllDataFilled
        let name : String = nameTextField.text ?? ""
        
        if (userData.avatarId == 0) {
            
            AlertHelper.warn(delegate: self, message: "Please choose an avatar")
        }
        else if (name.isEmpty) {
            
            AlertHelper.warn(delegate: self, message: "Please enter your name")
        }
        else {
            
            userData.name = name
            userData.save()
            
            if (isUpdateScreen) {
                
                self.navigationController?.popViewController(animated: true)
            }
            else {
                
                if let target = self.storyboard?.instantiateViewController(withIdentifier: "MainController") as? MainController {
                    target.navigationItem.hidesBackButton = true;
                    self.navigationController?.pushViewController(target, animated: true)
                }
            }
        }
    }
    
    
    // MARK: View lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        nextButton.layer.cornerRadius = 10
        nameTextField.delegate = self
        pickColorButton.setTitle("_register_pick_color".localized, for: .normal)
    }
    
    func initData() {
        
        let userData = UserData()
        
        self.navigationItem.title = userData.hasAllDataFilled ? "_register_title".localized : "_profile_title".localized
        
        let buttonTitle = userData.hasAllDataFilled ? "_save".localized : "_next".localized
        nextButton.setTitle(buttonTitle, for: .normal)
        
        avatarButton.setImage(UIImage(named: String(format: "%@%d", Constants.kAvatarImagePrefix, userData.avatarId)), for: UIControlState.normal)
        self.view.backgroundColor = Constants.colors[userData.colorId]
        
        nameTextField.text = userData.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true
    }
}
