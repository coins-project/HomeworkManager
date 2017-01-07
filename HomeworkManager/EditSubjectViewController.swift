import UIKit
import RealmSwift

class EditSubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var subjects :Results<Subject>?
    private let realm = RealmModelManager.sharedManager
    private var update = false
    var subjectName :String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let realm = try Realm()
            subjects = realm.objects(Subject)
            tableView.reloadData()
        }catch{
            print("error")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var subject:Subject? = nil
        do{
            let realm = try Realm()
            subject = realm.objects(Subject)[indexPath.row]
        }catch{
            print("エラー")
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Subject", forIndexPath: indexPath) as! EditSubjectViewCell
        cell.subject.text = subject!.name
        cell.backgroundColor = UIColor.hexStr(subject!.hexColor, alpha: 1)
        
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        subjectName = subjects![indexPath.row].name
        performSegueWithIdentifier("editSubject",sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editSubject") {
            let colorPanel: ColorPanelViewController = (segue.destinationViewController as? ColorPanelViewController)!
            colorPanel.subjectName.text = subjectName
            //colorPanel.
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
