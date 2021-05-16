//
//  TopRateViewController.swift
//  TMDB
//
//  Created by 連振甫 on 2021/5/5.
//

import UIKit

class TopRateViewController: UIViewController,ViewRouteProtocol,TopRateTableViewCellDelegate{
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = screenHeight * 0.05
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func showDetail(type: DataType, id: String) {
        switch type {
        case .Movie:
            showMoiveDetail(id)
            break
        case .TV:
            showTVDetail(id)
            break
        default:
            break
        }
    }
    
    func showTVDetail(_ id:String) {
        DataManager.shared.fetchTVDetail(id: id, completion: {[self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tv):
                    let viewModel = DetailViewModel(type: .TV, tvData: tv, movieData: nil)
                    showDetailViewController(viewModel: viewModel)
                case .failure(let error):
                    showMessageBox(title: "錯誤", msg: "\(error.localizedDescription)",action: nil)
                }
            }
        })
    }
    
    func showMoiveDetail(_ id:String) {
        DataManager.shared.fetchMovieDetail(id: id, completion: {[self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    let viewModel = DetailViewModel(type: .Movie, tvData: nil, movieData: movie)
                    showDetailViewController(viewModel: viewModel)
                case .failure(let error):
                    showMessageBox(title: "錯誤", msg: "\(error.localizedDescription)",action: nil)
                }
            }
        })
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
