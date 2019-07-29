//
//  CharacterAppearancesMenu.swift
//  Marvel
//
//  Created by Marcos Amorim on 25/07/19.
//  Copyright © 2019 Marcos Amorim. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

class CharacterAppearancesMenu: UIViewController{

    @IBOutlet weak var comicsButton: UIButton!
    @IBOutlet weak var seriesButton: UIButton!
    @IBOutlet weak var storiesButton: UIButton!
    @IBOutlet weak var eventsButton: UIButton!
    
    let COMICS_ID   = 1
    let SERIES_ID   = 2
    let STORIES_ID  = 3
    let EVENTS_ID   = 4

    var CharacterInfo: NSDictionary!
    var CharacterAppearances: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comicsButton.tag    = COMICS_ID
        seriesButton.tag    = SERIES_ID
        storiesButton.tag   = STORIES_ID
        eventsButton.tag    = EVENTS_ID
        
        formatLayout()
    }
    
    func formatLayout() {
        
        comicsButton.tag    = COMICS_ID
        seriesButton.tag    = SERIES_ID
        storiesButton.tag   = STORIES_ID
        eventsButton.tag    = EVENTS_ID
        
        comicsButton.diagonalCorners()
        seriesButton.diagonalCorners()
        storiesButton.diagonalCorners()
        eventsButton.diagonalCorners()
        
    }
    
    @IBAction func goToAppearancesButton(_ sender: Any) {
        
        guard let appearancesVC = self.storyboard?.instantiateViewController(withIdentifier: "CharacterAppearances") else { return }
        let navController = UINavigationController(rootViewController: appearancesVC)
        
        (appearancesVC as! CharacterAppearances).CharacterInfo = CharacterInfo
        (appearancesVC as! CharacterAppearances).appearance_ID = (sender as! UIButton).tag

        self.navigationController?.present(navController, animated: true, completion: nil)
        
    }
    
}
