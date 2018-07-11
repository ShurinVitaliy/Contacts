//
//  ContactViewController.swift
//  MyContacts
//
//  Created by Admin on 08.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import os.log

class ContactViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addressTextField: UITextField!
    
    var contact: Contact?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressTextField.delegate = self
        
        if let contact = contact{
            navigationItem.title = contact.name
            nameTextField.text = contact.name
            phoneNumberTextField.text = contact.phoneNumber
            photoImageView.image = contact.photo
            addressTextField.text = contact.address
        }
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    @IBAction func cancel(_ sender: Any) {
        let isPressentingInAddContactMode = presentingViewController is UINavigationController
        
        if isPressentingInAddContactMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ContactViewController is not inside a navigation controller.")
        }
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
            let name = nameTextField.text ?? ""
            let phoneNumber = phoneNumberTextField.text ?? ""
            let photo = photoImageView.image
            let address = addressTextField.text ?? ""
        
        contact = Contact(name: name, phoneNumber: phoneNumber, photo: photo, address: address)
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState(){
        let nameText = nameTextField.text ?? ""
        let phoneNumberText = phoneNumberTextField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty && !phoneNumberText.isEmpty
        
    }
}
