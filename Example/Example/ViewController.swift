//
//  ViewController.swift
//  Example
//
//  Created by ming on 2022/9/22.
//

import UIKit
import KKXMobile

class ViewController: KKXViewController, KKXCustomSearchView {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scanItem = UIBarButtonItem(title: "扫一扫", style: .plain, target: self, action: #selector(scanAction))
        let alertItem = UIBarButtonItem(title: "弹框", style: .plain, target: self, action: #selector(alertAction))
        navigationItem.rightBarButtonItems = [alertItem, scanItem]
        
        navigationItem.titleView = searchView
    }

    @objc private func scanAction() {
        let controller = KKXScanViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func alertAction() {
        let controller = KKXAlertController(title: "温馨提示")
        controller.message = "修改订单会导致订单停止计时，请谨慎操作，确认无误后再确定修改"
        controller.closePosition = .topRight
        let confirmAction = KKXAlertAction { _ in
            
        }
        confirmAction.button.setAttributedTitle(NSAttributedString(string: "确认修改"), for: .normal)

        let cancelAction = KKXAlertAction()
        cancelAction.button.setAttributedTitle(NSAttributedString(string: "取消"), for: .normal)
        controller.addActions([confirmAction, cancelAction])
        present(controller, animated: true)
    }
}

