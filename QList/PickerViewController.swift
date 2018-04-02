//
//  PickerViewController.swift
//  QList
//
//  Created by Home Mac on 4/1/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell2", for: indexPath)
        cell.textLabel?.text = "TEST"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.remove()
    }

    @IBOutlet weak var pickerTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 20
        
        pickerTable.delegate = self
        pickerTable.dataSource = self
        
        pickerTable.rowHeight = 40
        pickerTable.separatorColor = UIColor.black //.lightGray.withAlphaComponent(0.4)
        pickerTable.bounces = false
        pickerTable.backgroundColor = nil
        pickerTable.tableFooterView = UIView()
        pickerTable.sectionIndexBackgroundColor = .clear
        pickerTable.sectionIndexTrackingBackgroundColor = .clear
        pickerTable.layer.cornerRadius = 20
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
