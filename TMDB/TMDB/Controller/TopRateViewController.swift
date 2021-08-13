//
//  TopRateViewController.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/5.
//

import UIKit

class TopRateViewController: UIViewController,ViewRouteProtocol{
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = screenHeight * 0.05
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func login(){
        
        var accountTextField:UITextField?
        var passwordTextField:UITextField?
        
        let loginAlert = UIAlertController(title: "登入", message: "請輸入帳密", preferredStyle: .alert)
        loginAlert.addTextField(configurationHandler: { _accountTextField in
            _accountTextField.keyboardType = .emailAddress
            accountTextField = _accountTextField
        })
        loginAlert.addTextField(configurationHandler: { _passwordTextField in
            _passwordTextField.keyboardType = .emailAddress
            _passwordTextField.isSecureTextEntry = true
            passwordTextField = _passwordTextField
        })
        
        let loginAlertAction = UIAlertAction(title: "登入", style: .default, handler: { _ in
            guard let account = accountTextField?.text,let password = passwordTextField?.text else { return }
            
            AuthenticationManager.shared.login(account: account, password: password, completion: {[unowned self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let token):
                        showMessageBox(title: "登入成功", message: "")
                        DataManager.shared.token = token.request_token
                        print(token.request_token)
                        break
                    case .failure(let error):
                        showMessageBox(title: "登入失敗", message: "\(error)")
                        break
                    }
                }
                
                
            })
        })
        
        loginAlert.addAction(loginAlertAction)
        
        let cancleAlertAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        loginAlert.addAction(cancleAlertAction)
        
        present(loginAlert, animated: true, completion: nil)
        
        
    }
    
    func showMessageBox(title:String,message:String) {
        let boxAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: "確認", style: .default, handler: nil)
        boxAlert.addAction(checkAction)
        present(boxAlert, animated: true, completion: nil)
    }
}
extension TopRateViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRateViewCell", for: indexPath) as! TopRateTableViewCell
        
        tableView.rowHeight = indexPath.row == 1 ? screenHeight*0.55 : screenHeight*0.35
        cell.dataType = (indexPath.row == 1) ? .TV : .Movie
        cell.delegate = self
        return cell
        
    }
    
    
}
