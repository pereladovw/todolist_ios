//
//  AddTodoController.swift
//  Todo_list
//
//  Created by Reel on 15/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit
protocol communicationController {
    func addNewTodo(text: String, projPosition: Int)
}

class AddTodoController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tView: UITableView!
    var projects : [Project] = []
    var newText = ""
    var newProjId = 0
    let headers = ["Задача", "Категория"]

    var delegate: communicationController?
    
   
    
    @IBAction func addTD(_ sender: Any) {
        let indexPath = IndexPath(row: 0 , section: 0)
        let cell = tView.cellForRow(at: indexPath) as! EditTextCell
        newText = cell.textField.text!
        delegate?.addNewTodo(text: newText, projPosition: newProjId)
        dismiss(animated: true, completion: nil)
               
    }

    
    @IBAction func undo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {return(1)}
        else { if (section == 1) {return(projects.count)}
        else {return(0)}
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let cell = tableView.cellForRow(at: indexPath) as! ProjTableViewCell
            
            for i in 0...(projects.count - 1) {
                let iPath = IndexPath(row: i, section: 1)
                var icell = tableView.cellForRow(at: iPath) as! ProjTableViewCell
                icell.doneIm.isHidden = true
            }
            cell.doneIm.isHidden = false
            newProjId = indexPath.row
        }
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let title = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "projects")
        let font = UIFont(name: "OpenSans-Semibold", size: 16)
        title.backgroundColor = UIColor.groupTableViewBackground
        title.textLabel?.font = font
        title.textLabel?.text = headers[section].uppercased()
        title.selectionStyle = UITableViewCellSelectionStyle.none
    
        
        return(title)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return(50)
        //высота cell (непосредственно само todo)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return(200)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoEdit", for: indexPath) as! EditTextCell
            let font = UIFont(name: "OpenSans-Light", size: 18)
            cell.textField.font = font
            
            tableView.rowHeight = 100
            
            return(cell)
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projects", for: indexPath) as! ProjTableViewCell
            let font = UIFont(name: "OpenSans-Light", size: 18)
            cell.textLabel?.font = font
            let text = projects[indexPath.row].title
            cell.layoutMargins = UIEdgeInsetsMake(15, 15, 15, 10)
            cell.textLabel?.text = text
            tableView.rowHeight = 50
            
            return(cell)
        }
        
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return(2)
        
    }
    
    
}
