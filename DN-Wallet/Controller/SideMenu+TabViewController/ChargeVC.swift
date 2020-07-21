//
//  ChargeVC.swift
//  DN-Wallet
//
//  Created by Mac OS on 2/29/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class ChargeVC: UIViewController {
    
    
    //MARK:- Outlets
    @IBOutlet weak var dropDown: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var segmentControl: DNSegmentControl!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var creditTable: UITableView!
    
    //MARK:- Properities
    var lastSelectedIndexPath: IndexPath?
    var selectedCardId: String = "0"
    var tableDataSource: UITableViewDiffableDataSource<Section, CardInfo>!
    var cards: [CardInfo] = [CardInfo(id: "1", name: "Visa", type: "prepad", last4digits: "1547"),
                             CardInfo(id: "2", name: "Master Card", type: "prepad", last4digits: "5427"),
    CardInfo(id: "3", name: "Meza", type: "charge", last4digits: "8437")]
    
    //MARK:- Initialization
    fileprivate func configureSegmentControl() {
        segmentControl.firstSegmentTitle    = "Charge"
        segmentControl.secondSegmentTitle   = "Withdrew"
        segmentControl.delegate             = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNavigationBar()
        configureSegmentControl()
        
        dropDown.delegate = self
        amountField.delegate = self
        creditTable.delegate = self
        setupCreditTableDataSource()
        creditTable.dataSource = tableDataSource
        
        dropDown.text = "EGP"
        //setUserPreference()
    }
    
    private func setUserPreference() {
        if let currency = UserPreference.getStringValue(withKey: UserPreference.currencyKey) {
            dropDown.text = currency
        }
    }
    
    func handleNavigationBar() {
        navigationItem.title = "Charge - Withdraw"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .DnColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let scanBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnPressed))
        navigationItem.rightBarButtonItem = scanBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
            
        }
    
    private func setupCreditTableDataSource() {
        tableDataSource = UITableViewDiffableDataSource(tableView: creditTable, cellProvider: { (MyTable, indexPath, data) -> UITableViewCell? in
            guard let cell = MyTable.dequeueReusableCell(withIdentifier: ChargeCreditCell.reuseIdentifier, for: indexPath)  as? ChargeCreditCell else {return UITableViewCell()}
            cell.data = data
            return cell
        })
        updateTableViewWithData()
    }
    
    private func updateTableViewWithData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CardInfo>()
        snapshot.appendSections(Section.allCases)
        for item in cards {
            snapshot.appendItems([item])
        }
        tableDataSource.apply(snapshot)
    }
    
    //MARK:- Actions
    @objc func doneBtnPressed() {
        print("done button pressed")
    }
    

}

extension ChargeVC: UITextFieldDelegate, PopUpMenuDelegate {
    func selectedItem(title: String, code: String?) {
        dropDown.text = title + "\t\t(\(code ?? " "))"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dropDown {
            textField.endEditing(true)
            amountField.endEditing(true)
            let vc = PopUpMenu()
            vc.menuDelegate = self
            vc.dataSource = .currency
            self.present(vc, animated: true, completion: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension ChargeVC: UITableViewDelegate {
    
    func unCheckLastCell() {
        if let cell = creditTable.cellForRow(at: lastSelectedIndexPath!) as? ChargeCreditCell {
            cell.checkBoxToggle(check: false)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChargeCreditCell {
            if lastSelectedIndexPath != nil {
                unCheckLastCell()
            }
            cell.checkBoxToggle(check: true)
            lastSelectedIndexPath = indexPath
            self.selectedCardId = cell.credit_Id
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.text = "  Select Payment Card"
        header.textColor = .DnTextColor
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
}

// handel segmentControl Action
extension ChargeVC: DNSegmentControlDelegate {
    func segmentValueChanged(to index: Int) {
        if index == 0 {
            // charge...
            print("charge...")
        } else {
            // withdrew...
            print("withdrew...")
        }
    }
    
    
}

//Networking
extension ChargeVC {
    func initViewControllerWithData(cardList: [CardInfo]) {
        self.cards = cardList
        DispatchQueue.main.async { self.updateTableViewWithData() }
    }
}
