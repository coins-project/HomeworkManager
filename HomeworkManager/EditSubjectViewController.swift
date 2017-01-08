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
        self.colorPanel.setSubjectNameAndColor(subjects![indexPath.row].name)
        performSegueWithIdentifier("editSubject", sender: nil)
    }
    
/*##########################################
    class User: MailServerDelegate {
        
        let mailServer: MailServer
        
        init(){
            self.mailServer = MailServer()
            self.mailServer.delegate = self
        }
        
        /*
         * ボタンが押された時の処理
         */
        func sendButtonPushed(message: String){
            // メールを送信する。送信の結果は、delegate経由で受け取る。
            self.mailServer.sendMail(message)
        }
        
        // 送信結果。mailServerからコールされる
        func onSuccessSendMail() -> Void {
            print("success!")
        }
        func onFailureSendMail() -> Void {
            print("failure..")
        }
    }
    
    protocol MailServerDelegate {
        
        /*
         * 送信した時のイベント
         * 「メール送信成功しました！」
         * 「メール送信失敗しました...」
         */
        func onSuccessSendMail() -> Void
        func onFailureSendMail() -> Void
    }
    
    // メールを送信して、delegateに対して結果を知らせます。
    class MailServer {
        
        // イベントを通知する先
        weak var delegate: MailServerDelegate?
        
        /*
         * メールを送信する処理
         * 「あ、このメッセージを送るんですね、わかりました。メール送信します。
         *   完了したらdelegateに知らせますね。」
         */
        func sendMail(message: String) -> Void{
            // 非同期メール送信処理を書く
            if 成功 {
                self.delegate?.onSuccessSendMail()
            } else {
                self.delegate?.onFailureSendMail()
            }
        }
    }
 */
    
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
        func deliverName(subjectName: String)
    }
