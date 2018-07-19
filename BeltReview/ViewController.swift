//
//  ViewController.swift
//  BeltReview
//
//  Created by Lyla Vela on 7/18/18.
//  Copyright © 2018 Lyla Vela. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var tableData: [Note] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonPressed(_ sender: Any) {
   performSegue(withIdentifier: "addEditSegue", sender: sender)
        
    }
    
    @IBAction func unwindSegueFromAddEditVC(segue: UIStoryboardSegue){
        let src = segue.source as! addEditVC
       // data that comes from your source
        let title = src.titleTextField.text!
        let note = src.noteTextView.text!
        let date = src.dateDatePicker.date
        
        print("Printing information -->",title,note,date)
        
        if src.editMode{
            if let indexPathAddEditVC = src.indexPathAddEditVC as? IndexPath{
                
                let item = tableData[indexPathAddEditVC.row]
                item.title = title
                item.note = note
                item.date = date
                item.completed = true
                appDelegate.saveContext()
                tableView.reloadData()
            }
            
        }
        else {
       //instance from CoreData
        let newNote = Note(context: context)
        newNote.title = title
        newNote.note = note
        newNote.date = date
        newNote.completed = false
        
        tableData.append(newNote)
        appDelegate.saveContext()
        tableView.reloadData()
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("prepareForSegue to ShowVC!")
//        if let indexPath = sender as? IndexPath{
//            if segue.identifier == "ShowSegue"{
//                let dest = segue.destination as! ShowVC
//                print("going to ShowVC through ShowSegue from prepare segue func in ViewController")
//                let note = tableData[indexPath.row]
//                dest.note = note
//                dest.indexPath = indexPath
//            }
//            else if segue.identifier == "AddEditSegue"{
//                print("going to AddEditVC as add item")
//                let nav = segue.destination as! UINavigationController
//                let dest_2 = nav.topViewController as! AddEditVC
//                let note = tableData[indexPath.row]
//                print(note)
//                dest_2.note = note
//                dest_2.indexPath = indexPath
//            }
//        }
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let indexPath = sender as? IndexPath{
            if segue.identifier == "showSegue"{
                let title = tableData[indexPath.row].title
                let note = tableData[indexPath.row].note
                let date = tableData[indexPath.row].date
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                
                let dest = segue.destination as! showVC
                dest.titleShow = title as! String
                dest.dateShow = formatter.string(from: date!)
                dest.noteShow = note as! String
                //   print(titleShow, dateShow, noteShow)
                
            }
            else if segue.identifier == "addEditSegue"{
                let nav = segue.destination as! UINavigationController
                let dest = nav.topViewController as! addEditVC
                
                let title = tableData[indexPath.row].title
                let note = tableData[indexPath.row].note
                let date = tableData[indexPath.row].date
                print(title, note, date)
                
                dest.editMode = true
                
                dest.titleEdit = title as! String
                dest.noteEdit = note as! String
                dest.dateEdit = date!
                dest.indexPathAddEditVC = indexPath
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    //    tableView.reloadRows(at: [indexPath], with: .automatic)
        fetchAllData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func fetchAllData(){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Note.date), ascending: false)
        let sortCompleted = NSSortDescriptor(key: #keyPath(Note.completed), ascending: true)
       
        request.sortDescriptors = [sort]
        request.sortDescriptors = [sortCompleted]
        
        do{
            tableData = try context.fetch(request)
            
        }catch{
            print("Error-->", error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thisCell", for: indexPath) as! ThisCell
        let cellData = tableData[indexPath.row]
        cell.titleLabel.text = cellData.title
        cell.delegate = self
        cell.indexPathThisCell = indexPath
        
        let imgName = cellData.completed ? "full_circle" : "empty_circle"
        cell.buttonChecked.setBackgroundImage(UIImage(named: imgName), for: .normal)
        return cell
    }
    // delete trailing swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view , completionHandler in
            
            self.context.delete(self.tableData[indexPath.row])
            self.tableData.remove(at: indexPath.row)
            self.appDelegate.saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(false)
        }
        // edit
        let note = tableData[indexPath.row].completed
        if note == false {
        
            let editAction = UIContextualAction(style: .normal, title: "Edit") {action, view, completionHandler in
            
            self.performSegue(withIdentifier: "addEditSegue", sender: indexPath)
            completionHandler(false)
            
            }
            
            let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            return swipeConfig
        } else {
            let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipeConfig
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSegue", sender: indexPath )
    }
    
}

extension ViewController:ThisCellDelegate{
    func buttonChecked(from sender: ThisCell, indexPath: IndexPath) {
        let indexPath = tableView.indexPath(for: sender)!
        tableData[indexPath.row].completed = !tableData[indexPath.row].completed
        appDelegate.saveContext()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}




