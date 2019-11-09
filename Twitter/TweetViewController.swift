//
//  TweetViewController.swift
//  Twitter
//
//  Created by Rotimi Awani on 11/6/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class TweetViewController: UIViewController, UITextViewDelegate{
    

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self

        tweetTextView.becomeFirstResponder()
        getUser()
        
        // Style the textview
        tweetTextView.layer.borderColor = UIColor.gray.cgColor
        tweetTextView.layer.borderWidth = 1.0
        tweetTextView.layer.cornerRadius = 8
        profileImageView.layer.cornerRadius = 32
        
        self.updateCharacterCount()
        
    }
    
    func getUser() {
        let myUrl = "https://api.twitter.com/1.1/account/verify_credentials.json"
        TwitterAPICaller.client?.getDictionaryRequest(url: myUrl, parameters: ["count": 1], success: { (user: NSDictionary) in
            print(user)
            let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
            let data = try? Data(contentsOf: imageUrl!)
            if let imageData = data {
                self.profileImageView.image = UIImage(data: imageData)
            }
                
            
        }, failure: { (error) in
            print("Could not retrive user object")
        })
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let characterLimit = 140
        
        // get the current text, or use an empty string if that failed
        let currentText = tweetTextView.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let newText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // Allow or disallow the new text
        return newText.count < characterLimit
    }
    
    func updateCharacterCount() {
        let tweetCount = self.tweetTextView.text.count
        self.countLabel.text = "\((0) + tweetCount)/140"
    }
    
    func textViewDidChange(_ textView: UITextView) {
       self.updateCharacterCount()
    }

}
