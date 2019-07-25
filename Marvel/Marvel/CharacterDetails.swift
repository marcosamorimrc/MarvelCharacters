//
//  CharacterDetails.swift
//  Marvel
//
//  Created by Marcos Amorim on 23/07/19.
//  Copyright © 2019 Marcos Amorim. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CharacterDetails: UIViewController{

    var CharacterInfo: NSDictionary!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var appearancesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillCharacterInfo()
        loadCharacterImage()
        appearancesButton.diagonalCorners()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.becomeTransparent()
        
    }
    
    override func willMove(toParent parent: UIViewController?) {

        self.navigationController?.becomeBlack()
        
    }
    
    func fillCharacterInfo(){
        
        nameLabel.text = (CharacterInfo["name"] as! String)
        
        let description = (CharacterInfo["description"] as! String)
        if description == "" {
            descriptionTextView.text = "No description available."
        }else{
            descriptionTextView.text = description
        }
    
    }
    
    func loadCharacterImage(){
        
        let thumbnail = CharacterInfo["thumbnail"] as! NSDictionary
        let url = "\(thumbnail["path"]!)/standard_fantastic.\(thumbnail["extension"]!)"
        
        characterImageView.sd_setImage(with: URL(string: url))
        
    }
    
    @IBAction func appearancesBtnAction(_ sender: Any) {
        
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CharacterAppearances") else { return }
        let navController = UINavigationController(rootViewController: myVC)
        
        (myVC as! CharacterAppearances).CharacterInfo = CharacterInfo
        
        self.navigationController?.present(navController, animated: true, completion: nil)
        
    }
    
}
