import UIKit
import RealmSwift

class EditSubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var subjects :Results<Subject>?
    private let realm = RealmModelManager.sharedManager
    private var update = false
    var subjectName = ""
    var subjectColor = ""
    
    let colorPanel = ColorPanelViewController()
    var delegate: ToColorPanelDelegate!
    
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
        }//書き方がわからない
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Subject", forIndexPath: indexPath) as! EditSubjectViewCell
        cell.subject.text = subject!.name
        cell.backgroundColor = UIColor.hexStr(subject!.hexColor, alpha: 1)
        
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.delegate.setSubjectNameAndColor(subjects![indexPath.row].name)
        performSegueWithIdentifier("editSubject", sender: nil)
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

    protocol ToColorPanelDelegate {
        func setSubjectNameAndColor(subjectName: String)
    }
