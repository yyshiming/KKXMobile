//
//  ViewController.swift
//  Example
//
//  Created by ming on 2022/9/22.
//

import UIKit
import KKXMobile

class ViewController: KKXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        kkxPrint(KKXExtensionString("search"))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "扫一扫", style: .plain, target: self, action: #selector(scanAction))
    }

    @objc private func scanAction() {
        let controller = KKXScanViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

}

