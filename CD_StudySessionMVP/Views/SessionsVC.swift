//
//  SessionsVC.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 07/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

class SessionsVC: UIViewController, SessionsViewInterface, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var constrTableB: NSLayoutConstraint!
    @IBOutlet weak var lblMsg: UILabel!

    var presenter: SessionsPresenter!
    private let idCell = "idCell"
    private var offSetTableB: CGFloat = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewInterface = self
        offSetTableB = constrTableB.constant
        table.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
        table.rowHeight = 44
        table.dataSource = self
        table.delegate = self
    }
    
    // MARK: - IBActions

    @IBAction func onBtnAdd(_ sender: UIBarButtonItem) {
        //presenter.btnAddStudySessionPressed()
    }

    
    // MARK: - SessionsViewInterface
    
    func nada() {
         
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: idCell)!
        let sTuple = presenter.session(at: indexPath.row)
        cell.textLabel?.text = "\(sTuple.strBeginDate), \(sTuple.minutes) mins"
        cell.detailTextLabel?.text = sTuple.subject
        return cell
    }
    
    // MARK: - UITableViewDelegate

    

}
