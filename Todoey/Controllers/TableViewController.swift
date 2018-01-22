//
//  TableViewController.swift
//  Todoey
//
//  Created by EthanLin on 2018/1/21.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //找到儲存用戶個人資料的路徑
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
       
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "buy milk"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "go to mall"
//        itemArray.append(newItem3)
//
        
        //  取資料
        loadItems()
        
//        if let items = defaults.array(forKey: "TodoListarray") as? [Item]{
//            itemArray = items
//        }
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //三元運算子 vale = condition ? valueIfTrue:valueIfFalse
        
        
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
       //上面的判斷是簡化成下面一行
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //如果被點到的row有圖案載點按一次就取消，否則加上checkmark
        
        if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        
        saveItems()
        
        
        
//        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        //消除點到會一直維持灰色，讓他點一下後就消除點選
        tableView.deselectRow(at: indexPath, animated: true)
       
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
      
        //在警告控制器加上textFeild，並且把此警告控制器存到var textFeild，在上面會另外實體化一個textField目的是為了讓下面的action也可以用
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
       let action =  UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user click the add item button on UIAlert
        
            let newItem = Item()
            newItem.title = textField.text!
        
            self.itemArray.append(newItem)
        
            // 存資料
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        
            self.saveItems()
        
        }

        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //用Encoder存資料成plist檔
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            //把data寫到我們路徑下
            try data.write(to: self.dataFilePath!)
        }catch{
            print(error.localizedDescription)
        }
        
        
        self.tableView.reloadData()
    }
    
    //用Decoder取資料
    func loadItems(){
        if let data = try? Data(contentsOf: self.dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error.localizedDescription)
            }
           
        }
    }
}