//
//  ViewController.swift
//  DerDieDas_p
//
//  Created by Gabor Silber on 19/01/15.
//  Copyright (c) 2015 Gabor Silber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var guessedArtikel: String = ""
    var randomWort = ""
    
    var punkte: Int = 0
    var maxpunkte: Int = 0
    
    @IBOutlet weak var punkteLabel: UILabel!
    @IBOutlet weak var wortLabel: UILabel!
    @IBOutlet weak var derButton: UIButton!
    @IBOutlet weak var dieButton: UIButton!
    @IBOutlet weak var dasButton: UIButton!
    @IBOutlet weak var wahrheitLabel: UILabel!
    @IBOutlet weak var nachstesButton: UIButton!
    @IBOutlet weak var genugButton: UIButton!
    @IBOutlet weak var nochEinSpielButton: UIButton!
    @IBOutlet weak var weiterButton: UIButton!
    
    
    @IBAction func derButton(sender: UIButton) {
        guessedArtikel = "der"
        vergleich()
    }
    
    @IBAction func dieButton(sender: UIButton) {
        guessedArtikel = "die"
        vergleich()
    }
    
    @IBAction func dasButton(sender: UIButton) {
        guessedArtikel = "das"
        vergleich()
    }
    
    @IBAction func nachstesButton(sender: UIButton) {
        generateWort()
    }
    
    @IBAction func genugButton(sender: UIButton) {
        var prozent:Int = punkte*100/maxpunkte
        var komment: String = ""
        
        nachstesButton.hidden = true
        punkteLabel.hidden = true
        genugButton.hidden = true
        derButton.hidden = true
        dieButton.hidden = true
        dasButton.hidden = true
        nochEinSpielButton.hidden = false
        weiterButton.hidden = false
        
        wortLabel.text = "Danke schön! Ihr Ergebnis ist "+String(punkte)+" von"+" "+String(maxpunkte)+" "+String(prozent)+"%"
        println(prozent)
        let interval051: HalfOpenInterval = 0..<51
        switch prozent {
            case interval051: wahrheitLabel.text = "Deutsch ist zu schwer für Sie. Probieren Sie vielleicht Englisch!"
            case 51..<66: wahrheitLabel.text = "Ihr soll mehr lernen!"
            case 66..<76: wahrheitLabel.text = "Na ja..."
            case 76..<90: wahrheitLabel.text = "Nicht schlecht, aber auch nicht gut!"
            case 90..<100: wahrheitLabel.text = "Ganz gut!"
            case 100: wahrheitLabel.text = "Sind Sie ein Pifke?"
        default: break
        }
    }
    
    
    @IBAction func nochEinSpielButton(sender: UIButton) {
        derButton.hidden = false
        dieButton.hidden = false
        dasButton.hidden = false
        genugButton.hidden = false
        nochEinSpielButton.hidden = true
        weiterButton.hidden = true
        
        punkte = 0
        maxpunkte = 0
        punkteLabel.text = "0/0"
        punkteLabel.hidden = false
        
        generateWort()
    }
    
    @IBAction func weiterButton(sender: UIButton) {
        derButton.hidden = false
        dieButton.hidden = false
        dasButton.hidden = false
        genugButton.hidden = false
        punkteLabel.hidden = false
        nochEinSpielButton.hidden = true
        weiterButton.hidden = true

        
        generateWort()
    }
    
    
    
    func vergleich(){
        if (guessedArtikel == wahrheitLabel.text) {
            wahrheitLabel.text = "Genau! "+guessedArtikel+" "+wortLabel.text!
            wahrheitLabel.textColor = UIColor.blueColor()
            punkte++
        }
        else {
            var wahrArtikel = wahrheitLabel.text
            wahrheitLabel.text = "Nunu! "+wahrArtikel!+" "+wortLabel.text!
            wahrheitLabel.textColor = UIColor.redColor()
        }
        wahrheitLabel.hidden = false
        nachstesButton.hidden = false
        maxpunkte++
        punkteLabel.text = String("\(punkte)")+"/"+String("\(maxpunkte)")
    }
    
    func generateWort() {
        
        wahrheitLabel.hidden = true
        nachstesButton.hidden = true
        
        //assign the csv file
        let csvURL = NSURL(string: "http://ecocomic.com/worter/worter2.csv")
        var error: NSErrorPointer = nil
        let csv = CSV(contentsOfURL: csvURL!, error: error)
        
        //generates a random word from the csv file
        let rows = csv?.rows
        let columns = csv?.columns
        let csvLength = csv?.rows.count
        var randomWort = Int(arc4random_uniform(csvLength!+1))-1
        if (randomWort != -1){
            //sets the labels according to the generated random word
            wortLabel.text = csv?.rows[randomWort]["Wort"]
            wahrheitLabel.text = csv?.rows[randomWort]["Artikel"]
        }
        else{
            generateWort()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wahrheitLabel.hidden = true
        nachstesButton.hidden = true
        nochEinSpielButton.hidden = true
        weiterButton.hidden = true
        
        generateWort()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}