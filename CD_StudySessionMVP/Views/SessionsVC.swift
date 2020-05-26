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
        constrTableB.constant = 0
        table.rowHeight = 60
        table.allowsSelection = false
        table.dataSource = self
        table.delegate = self
    }
    
    // MARK: - IBActions

    @IBAction func onBtnAdd(_ sender: UIBarButtonItem) {
        let addSessionVC = storyboard?.instantiateViewController(identifier: "\(AddSessionVC.self)") as! AddSessionVC
        addSessionVC.presenter = AddSessionPresenter(studentIdx: presenter.studentIdx)
        addSessionVC.presenter.delegate = presenter
        addSessionVC.modalPresentationStyle = .popover
        present(addSessionVC, animated: true) {
            print("\(self.classForCoder)) \(#function)")
        }
    }

    @IBAction func onBtnEdit(_ sender: UIBarButtonItem) {
        presenter.btnBtnEditPressed()
        table.setEditing(presenter.isEditMode, animated: true)
    }
    
    // MARK: - SessionsViewInterface
    
    func reloadData() {
        table.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = table.dequeueReusableCell(withIdentifier: idCell)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: idCell)
        }
        let sTuple = presenter.session(at: indexPath.row)
        cell.textLabel?.text = sTuple.subject
        cell.detailTextLabel?.text = "\(sTuple.strBeginDate), \(sTuple.minutes) mins"
        return cell
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return presenter.isEditMode
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let response = presenter.deleteSession(at: indexPath.row)
        if response.isError == false {
            table.deleteRows(at: [indexPath], with: .top)
        }
    }
}
