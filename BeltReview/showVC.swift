//
//  showVC.swift
//  BeltReview
//
//  Created by Lyla Vela on 7/18/18.
//  Copyright © 2018 Lyla Vela. All rights reserved.
//

import UIKit
import CoreData

class showVC: UIViewController {

    
    @IBOutlet weak var titleLabelshowVC: UILabel!
    @IBOutlet weak var dateLabelShowVC: UILabel!
    @IBOutlet weak var textViewshowVC: UITextView!

    var cellIndexPath: Note?
    
    var titleShow: String = " "
    var noteShow: String = " "
    var dateShow: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabelshowVC.text = titleShow
        textViewshowVC.text = noteShow
        dateLabelShowVC.text = dateShow
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
