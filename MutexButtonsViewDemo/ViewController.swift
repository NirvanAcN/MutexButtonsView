//
//  ViewController.swift
//  MutexButtonsViewDemo
//
//  Created by iCe_Rabbit on 2016/12/24.
//  Copyright © 2016年 HOME Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mutexView: MutexButtonsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mutexView.delegate = self
    }

}

extension ViewController: MutexButtonsViewDelegate {
    func mutexButtonsViewButtonsTitle() -> [String] {
        return (0...arc4random()%4 + 2).map { return "item\($0)" }
    }
    
    func mutexButtonsView(_ mutexButtonsView: MutexButtonsView, didSelect index: Int) {
        print("item\(index) had selected")
    }
    
}
