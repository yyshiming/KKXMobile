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
        
        isNavigationBarHidden = true
        view.addSubview(kkxNavigationBar)
        kkxNavigationBar.titleLabel.text = "KKXMobile"
        
        kkxNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: kkxNavigationBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: kkxNavigationBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: kkxNavigationBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
        
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("扫一扫", for: .normal)
        scanButton.setTitleColor(.black, for: .normal)
        scanButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        scanButton.addTarget(self, action: #selector(scanAction), for: .touchUpInside)
        
        let alertButton = UIButton(type: .system)
        alertButton.setTitleColor(.black, for: .normal)
        alertButton.setTitle("弹框", for: .normal)
        alertButton.titleLabel?.font = .systemFont(ofSize: 16)
        alertButton.addTarget(self, action: #selector(alertAction), for: .touchUpInside)
        
        kkxNavigationBar.titleLabel.text = "KKXMobile"
        kkxNavigationBar.rightItems = [alertButton, scanButton]
        
        testGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func testGradient() {
        let gradientView = UIView()
        view.addSubview(gradientView)
        gradientView.frame = CGRect(x: 20, y: 200, width: 200, height: 200)

        gradientView
            .maskedCorners(.init(maskedCorners: .all, cornerRadius: 20))
            .gradient(
                .init(
                    colors: [.rgba(242, 219, 178), .rgba(238, 191, 120)],
                    startPoint: .init(x: 0, y: 0.5),
                    endPoint: .init(x: 1, y: 0.5)
                )
            )
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

