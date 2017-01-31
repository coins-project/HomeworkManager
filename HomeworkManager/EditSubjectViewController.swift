import UIKit
import RealmSwift

class EditSubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var subjects :Results<Subject>?
    private let realm = RealmModelManager.sharedManager
    var subjectName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjects = realm.findAllObjects(Subject)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let subject:Subject? = subjects![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Subject", forIndexPath: indexPath) as! EditSubjectViewCell
        cell.subject.text = subject!.name
        cell.backgroundColor = UIColor.hexStr(subject!.hexColor, alpha: 1)
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        subjectName = subjects![indexPath.row].name
        performSegueWithIdentifier("editSubject" , sender: UITableViewCell.self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSubject" {
            let colorPanelViewController: ColorPanelViewController = segue.destinationViewController as! ColorPanelViewController
            colorPanelViewController.deliverName = subjectName
            colorPanelViewController.update = true
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            realm.delete(subjects![indexPath.row])
            self.tableView.reloadData()
        default:
            return
        }
    }
}
