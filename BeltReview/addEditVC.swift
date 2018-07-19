//
//  addEditVC.swift
//  BeltReview
//
//  Created by Lyla Vela on 7/18/18.
//  Copyright © 2018 Lyla Vela. All rights reserved.
//

import UIKit

class addEditVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    var titleEdit = ""
    var noteEdit = ""
    var dateEdit: Date?
    var editMode = false
    var indexPathAddEditVC: IndexPath?
   
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueFromAddEditVCWithSegue", sender: self)
        let title = titleTextField.text
        let note = noteTextView.text
        let date = dateDatePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDatePicker.minimumDate = Date()
        
        if editMode == true{
          
            titleTextField.text = titleEdit
            noteTextView.text = noteEdit
            dateDatePicker.setDate(dateEdit!, animated: true)
            
        }
        // Do any additional setup after loading the view.
    }

}
