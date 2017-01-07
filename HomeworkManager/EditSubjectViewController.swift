import UIKit
//import RealmSwift

class EditSubjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
//    var subject = Subject()
//    private let realm = RealmModelManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

    
    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var subject:Subject? = nil
        do{
            let realm = try Realm()
            subject = realm.objects(Subject)[indexPath.row]
        }catch{
            print("エラー")
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath) as! EditSubjectViewCell
        cell.subject.text = subject!.name
        cell.backgroundColor = UIColor.hexStr(subject!.hexColor, alpha: 1)

        return cell
    }

*/
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editDetail") {
            let colorPanel: ColorPanelViewController = (segue.destinationViewController as? ColorPanelViewController)!
            let text = "あいうえお"
            colorPanel.subjectName.text = text
        }
    }
}
