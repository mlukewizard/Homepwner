//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Luke on 20/08/2017.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate,
        UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        //If the device has a camera, take a picture; otherwise just pick from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        //Place image picker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    var item: Item! {
        didSet{
            navigationItem.title = item.name
        }
    }
    
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        //Get picked image from info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        //Put that image on the screen in the image view
        imageView.image = image
        
        //Take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        let value = item.valueInDollars
        valueField.text = numberFormatter.string(from: NSNumber(value:value))
        dateLabel.text = dateFormatter.string(from: item.dateCreated as Date)

        //Get the item key
        let key = item.itemKey
        
        //If there is an assocaited image with the item display it on the image view
        let imageToDisplay = imageStore.imageForKey(key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //"Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text,
                let value = numberFormatter.number(from: valueText){
                item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
}
