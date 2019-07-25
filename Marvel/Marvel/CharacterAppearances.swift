//
//  CharacterAppearances.swift
//  Marvel
//
//  Created by Marcos Amorim on 24/07/19.
//  Copyright © 2019 Marcos Amorim. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

class CharacterAppearances: UIViewController{
    
    var CharacterInfo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formataLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.becomeTransparent()
        
    }
    
    func formataLayout(){
        
        var closeIcon = UIImage(named: "close-button.png")
        closeIcon = closeIcon?.resizeImage(newSize: CGSize(width: 27, height: 27))
        let closeButton = UIBarButtonItem.init(image: closeIcon, style: .done, target: self, action: #selector(closeViewController(_:)))
        closeButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [closeButton]
        
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
