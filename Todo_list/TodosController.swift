//
//  ViewController.swift
//  Todo_list
//
//  Created by Reel on 14/07/2018.
//  Copyright © 2018 Reel. All rights reserved.
//

import UIKit
import M13Checkbox
import Alamofire


class TodosController: UIViewController, UITableViewDataSource, UITableViewDelegate, communicationController{
   
    var newTodoText:String!
    var newTodoProject: Int!
   
    
    @IBOutlet weak var tabeV: UITableView!
    
    var projects: [Project] = []
    var todos : [Int : [Todo]] = [1:[],
    2:[],
    3:[]]
    var dataTodos : [Todo] = []

    var checkboxMap = [IndexPath : M13Checkbox]()
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       let nav = segue.destination as! UINavigationController
       let destinationVC : AddTodoController = nav.topViewController as! AddTodoController
       destinationVC.projects = projects
        destinationVC.delegate = self
   
     }
  
    func addNewTodo( text: String, projPosition: Int) {
        self.newTodoProject = projPosition
        self.newTodoText = text
        var nTodo =  Todo.init(text: text, id: dataTodos.count + 1, project_id: projPosition + 1, isCompleted: false)
        dataTodos.append(nTodo)
        todos[projPosition + 1]?.append(nTodo)
        uploadNewTodo(todo: nTodo)
        tabeV.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var i = 0
      
        
        return(todos[section + 1 ]!.count)
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var nextTodo = todos[projects[indexPath.section].id]![indexPath.row]
        var checkbox = checkboxMap[indexPath]
        let cell = tableView.cellForRow(at: indexPath)
        if( cell?.selectionStyle != UITableViewCellSelectionStyle.none) {
            
            var attributeString =  NSMutableAttributedString(string: nextTodo.text)
            
            if (checkbox!.checkState != M13Checkbox.CheckState.checked) {
            attributeString.addAttribute( NSAttributedStringKey.strikethroughStyle,
                                         value: NSUnderlineStyle.styleSingle.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            checkbox?.setCheckState(M13Checkbox.CheckState.checked, animated: true)
            nextTodo.isCompleted = true
            
            } else {
                nextTodo.isCompleted = false
                checkbox?.setCheckState(M13Checkbox.CheckState.unchecked, animated: true)
            
            }
                updateTodo(todo: nextTodo)
                cell?.textLabel?.attributedText = attributeString
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       
        let title = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let font = UIFont(name: "OpenSans-Semibold", size: 16)
        title.backgroundColor = UIColor.groupTableViewBackground
        title.textLabel?.font = font
        title.textLabel?.text = projects[section].title.uppercased()
        
        title.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        return(title)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return(50)
        //высота cell (непосредственно само todo)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
       return(50)
        //высота заголовка (название проекта)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        let checkbox = M13Checkbox(frame: CGRect(x: 10.0, y: 15.0, width: 25.0, height: 25.0))
        let font = UIFont(name: "OpenSans-Light", size: 18)
        cell.textLabel?.font = font
        checkbox.boxType = M13Checkbox.BoxType.square
        checkbox.stateChangeAnimation = M13Checkbox.Animation.fill
        checkbox.checkState = M13Checkbox.CheckState.unchecked
        checkbox.cornerRadius = 0
        var nextTodo = todos[projects[indexPath.section].id]![indexPath.row]
        var attributeString =  NSMutableAttributedString(string: nextTodo.text)
        
        cell.addSubview(checkbox)
        if( nextTodo.isCompleted) {
            checkbox.checkState = M13Checkbox.CheckState.checked
            attributeString.addAttribute( NSAttributedStringKey.strikethroughStyle,
                                          value: NSUnderlineStyle.styleSingle.rawValue,
                                          range: NSMakeRange(0, attributeString.length))
        }
        checkbox.tag = indexPath.row
        checkbox.isEnabled = false
      
        cell.layoutMargins = UIEdgeInsetsMake(15, 60, 15, 10)
        cell.textLabel?.attributedText = attributeString
        checkboxMap[indexPath] = checkbox
        
        return(cell)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var i = 0
        while(projects.count == 0){
            sleep(2)
            i += 1
            if (i > 60) {break}
        }
        return(projects.count)
        
    }
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let projUrlString = "https://murmuring-gorge-28716.herokuapp.com/projects/projects/"
        guard let url = URL(string: projUrlString)  else {return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            do {
                let prs = try JSONDecoder().decode([Project].self, from: data)
                self.projects = prs
                
            } catch let jsonErr {print("err")}
            
            }.resume()
        
        let todosUrlString = "https://murmuring-gorge-28716.herokuapp.com/projects/todos/"
        guard let urltodos = URL(string: todosUrlString)  else {return}
        URLSession.shared.dataTask(with: urltodos) { (data, response, err) in
            guard let data = data else {return}
            do {
                let prs = try JSONDecoder().decode([Todo].self, from: data)
                self.dataTodos = prs
                for todo in prs {
                    if (self.todos.keys.contains(todo.project_id)) {
                        self.todos[todo.project_id]?.append(todo)
                    } else {
                        
                        self.todos[todo.project_id]?.append(todo)
                    }
                    
                }
                
            } catch let jsonErr {print(jsonErr)}
        }.resume()
        
    }
    
    func uploadNewTodo(todo: Todo) {
        let json: [String: Any] = ["project_id": todo.project_id, "id" : todo.id, "text" : todo.text, "isCompleted": false]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlq = URL(string: "https://murmuring-gorge-28716.herokuapp.com/projects/androidcreate/")!
        var request = URLRequest(url: urlq)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
    
    func updateTodo(todo: Todo) {
        let json: [String: Any] = ["id" : todo.id, "isCompleted": todo.isCompleted]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let urlq = URL(string: "https://murmuring-gorge-28716.herokuapp.com/projects/androidupdate/")!
        var request = URLRequest(url: urlq)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
}



    
    


