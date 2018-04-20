//
//  ViewController.swift
//  DragDropText
//
//  Created by Rafael M. Trasmontero on 4/19/18.
//  Copyright © 2018 RMT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    var myTableViewTextData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.textDragDelegate = self
        myTableView.dropDelegate = self
        myTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITextDragDelegate ,UITableViewDropDelegate {
    
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, itemsForDrag dragRequest: UITextDragRequest) -> [UIDragItem] {
        
        if let mySelectedTextString = myTextView.text(in: dragRequest.dragRange) {
            let myDragItem = NSItemProvider(object: mySelectedTextString as NSString)
            return [UIDragItem(itemProvider: myDragItem)]
        } else {
            return []
        }
        
    }
    
    func textDraggableView(_ textDraggableView: UIView & UITextDraggable, dragPreviewForLiftingItem item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        let myImageView = UIImageView(image:UIImage(named: "letterT"))
        myImageView.backgroundColor = UIColor.clear
        
        let myDragView = textDraggableView
        let myDragPoint = session.location(in: myDragView)
        let myDragPreviewTarget = UIDragPreviewTarget(container: myDragView, center: myDragPoint)
        
        return UITargetedDragPreview(view: myImageView, parameters: UIDragPreviewParameters(), target: myDragPreviewTarget)
        
    }
   
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let myDropDestination:IndexPath
        
        if let myIndexPath = coordinator.destinationIndexPath{
            myDropDestination = myIndexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            myDropDestination = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let stringObjectArray = items as? [String] else {return}
            self.myTableViewTextData.insert(stringObjectArray.first!, at: myDropDestination.row)
            tableView.insertRows(at: [myDropDestination], with: .automatic)
        }
        
        
    }
    
    
}

extension ViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTableViewTextData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let myTextObject = myTableViewTextData[indexPath.row]
        
        cell.textLabel?.text = myTextObject
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myTableViewTextData.remove(at: indexPath.row)
            myTableView.reloadData()
        }
    }
    
    
    
    
}
