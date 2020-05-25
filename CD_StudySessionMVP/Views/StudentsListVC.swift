//
//  StudentsListVC.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 03/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import UIKit

class StudentsListVC: UIViewController, StudentsListViewInterface, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var constrTableB: NSLayoutConstraint!
    @IBOutlet weak var lblMsg: UILabel!
    
    private let presenter = StudentsListPresenter()
    private let idCell = "idCell"
    private var offSetTableB: CGFloat = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Estudiantes"
        presenter.viewInterface = self
        offSetTableB = constrTableB.constant
        constrTableB.constant = 0
        table.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
        table.rowHeight = 44
        table.dataSource = self
        table.delegate = self
    }
    
    
    
    // MARK: - IBActions

    @IBAction func onBtnAdd(_ sender: UIBarButtonItem) {
        presenter.btnAddStudentPressed()
    }
    
    // MARK: - StudentsListViewInterface
    
    func showAddNewStudentForm() {
        let alertVC = UIAlertController(title: "Nuevo estudiante", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Guardar", style: .default) {
            [weak alertVC, weak self] (action) in
            if let textFieldFirstName = alertVC?.textFields?.first,
                let textFieldLastName = alertVC?.textFields?.last,
                let firstName = textFieldFirstName.text,
                let lastName = textFieldLastName.text,
                firstName.trimmingCharacters(in: .whitespaces).isEmpty == false,
                lastName.trimmingCharacters(in: .whitespaces).isEmpty == false
            {
                self?.presenter.addNewStudent(name: firstName.trimmingCharacters(in: .whitespaces),
                                              lastName: lastName.trimmingCharacters(in: .whitespaces))
            } else {
                self?.presenter.errorTypingNewStudent()
            }
        }
        alertVC.addTextField { (textFieldFirstName) in
            textFieldFirstName.placeholder = "Nombre"
        }
        alertVC.addTextField { (textFieldLastName) in
            textFieldLastName.placeholder = "Apellidos"
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func showMsg(_ msg:String, isError:Bool)  {
        lblMsg.text = msg
        lblMsg.textColor = (isError ? .red : .black)
        UIView.animate(withDuration: K.animTime) {
            self.constrTableB.constant = self.offSetTableB
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: K.animTime, delay: K.animTime + K.msgTime,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations:
        {
            self.constrTableB.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func reloadData() {
        table.reloadData()
    }
    
    func navigateToSessionList(forStudentIdx i: Int) {
        let sessionsVC = storyboard?.instantiateViewController(identifier: "\(SessionsVC.self)") as! SessionsVC
        sessionsVC.presenter = SessionsPresenter(studentIdx: i)
        sessionsVC.title = presenter.titleForCell(at: i)
        navigationController?.pushViewController(sessionsVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = table.dequeueReusableCell(withIdentifier: idCell)!
        cell.textLabel?.text = presenter.titleForCell(at: indexPath.row)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        presenter.didSelectStudent(at: indexPath.row)
    }

}
