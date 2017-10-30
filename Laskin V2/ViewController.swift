//
//  ViewController.swift
//  Laskin V2
//
//  Created by Markus Hyvärinen on 20/09/2017.
//  Copyright © 2017 Markus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var numincalc: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var calchistory: UILabel!
    var num = 0
    var decindex = 0
    var decnum = 0
    var previousnum : Double = 0
    var isdecimal = false
    var calcaction = ""
    var history : [Double] = []
    var historyoperators : [String] = []
    var bracketL : [Int] = []
    var bracketR : [Int] = []
    var edit = false
    var historytext = ""
    var selected = 0
    var editselected = false
    @IBOutlet weak var leftA: UIButton!
    @IBOutlet weak var rightA: UIButton!
    @IBOutlet weak var leftB: UIButton!
    @IBOutlet weak var leftBR: UIButton!
    @IBOutlet weak var rightB: UIButton!
    @IBOutlet weak var rightBR: UIButton!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: FUNCTIONS
    //Does the calculation action based on the received string
    func operatoraction(action : String){
        //this edit is a flag for calculation editor
        if (edit == true){
            historyoperators [selected] = action
            editselected = true
            updatecalculation()
        }
        if (edit == false){
            //If no previous number combines the two string in to double and adds it to the previous number
            if (previousnum == 0){
                previousnum = Double(String(num) + "." + String(decnum))!
                history.append(Double(previousnum))
                num = 0
                decnum = 0
                calcaction = action
                isdecimal = false
                decindex = 0
                updateall()
            }
            
            //Else it will call equal function that will save the new answer and update will update to show it
            else{
                if (Double(String(num) + "." + String(decnum))! != 0){
                    equal()
                }
                calcaction = action
                updateall()
            }
        }
    }
    
    //Adds the received value to the calc
    func number(number : Int){
        if (edit == true){
            editselected = true
        }
        //If the decimal flag is down aka its not decimal number then it multiplies the whole number and adds the pressed number to it
        if (isdecimal == false){
            num = num*10+number
        }
        //If the number is decimal number then it will be added to the end of decimal "whole" number
        if (isdecimal == true){
            if (decindex == 0){
                decnum = number
                decindex += 1
            }
            else{
                decnum = decnum*10+number
                decindex += 1
            }
        }
        if (editselected == true){
            updatecalculation()
        }
        else{
            updatecalc()
        }
    }
    
    //updates the main display where you insert th numbers
    func updatecalc(){
        //for editing it takes the double value from array and converts it to two int values and then to string
        if (edit == true && editselected == false){
            let temp = String(format: "%g", history[selected])
            let B = temp.characters.split{$0 == "."}.map(String.init)
            num = Int(B[0])!
            if (B.count == 2){
                decnum = Int(B[1])!
                isdecimal = true
                decindex = B[1].characters.count
            }
            if (B.count == 1){
                decnum = 0
                isdecimal = false
            }
        }
        if (isdecimal == false){
            numincalc.text = String(num)
        }
        else{
            if (decindex == 0) {
                numincalc.text = String(num)+"."
            }
            else{
                numincalc.text = String(num)+"."+String(decnum)
            }
        }
    }
    
    //updates the answer/previous number and format %g removes extra zeroes from the end
    func updateprevious(){
        answer.text = String(format: "%g", previousnum)
    }
    
    //Just updates calculation action symbol
    func updateA(){
        action.text = calcaction
    }
    
    //calls for all update functions
    func updateall(){
        updatehistory()
        updateprevious()
        updatecalc()
        updateA()
    }
    
    //updates the histry
    func updatehistory(){
        historytext = ""
        var counter = 0
        var x = 0
        while (counter < history.count){
            while (x < bracketL.count){
                while (x < bracketL.count){
                    if (bracketL[x] == counter){
                        historytext += "("
                    }
                    x += 1
                }
            }
            x = 0
            if (counter == selected && edit == true){
               historytext += "[" + String(format: "%g", history[counter]) + "]"
            }else{
                historytext += String(format: "%g", history[counter])
            }
            while (x < bracketR.count){
                while (x < bracketR.count){
                    if (bracketR[x] == counter){
                        historytext += ")"
                    }
                    x += 1
                }
            }
            x = 0
            if (history.count > counter+1){
                historytext += historyoperators[counter]
            }
            counter += 1
        }
        calchistory.text = historytext
    }
    
    //updates the calculations if something was edited
    func updatecalculation(){
        if (edit == true){
            if (editselected == true){
                history [selected] = Double(String(num) + "." + String(decnum))!
                var a = 1
                previousnum = history[0]
                while (a <= history.count-1){
                    if (historyoperators[a-1] == "+"){
                        previousnum += history[a]
                    }
                    if (historyoperators[a-1] == "-"){
                        previousnum = previousnum - history[a]
                    }
                    if (historyoperators[a-1] == "*"){
                        previousnum = previousnum * history[a]
                    }
                    if (historyoperators[a-1] == "/"){
                        previousnum = previousnum / history[a]
                    }
                    a += 1
                }
            }
            
        }
        updateall()
        editselected = false
    }
    
    //MARK: BUTTONS - numbers
    //numbers 0-9 just call function that takes Int that adds the int to the end of display
    @IBAction func one() {
        number(number: 1)
    }
    
    @IBAction func two() {
        number(number: 2)
    }
    
    @IBAction func three() {
        number(number: 3)
    }
    
    @IBAction func four() {
        number(number: 4)
    }
    
    @IBAction func five() {
        number(number: 5)
    }
    
    @IBAction func six() {
        number(number: 6)
    }
    
    @IBAction func seven() {
        number(number: 7)
    }
    
    @IBAction func eight() {
        number(number: 8)
    }
    
    @IBAction func nine() {
        number(number: 9)
    }
    
    @IBAction func zero() {
        number(number: 0)
    }
    
    @IBAction func dot(){
        if (isdecimal == true){
            return
        }
        isdecimal = true
        updatecalc()
    }
    
    //MARK:BUTTONS - calculation actions
    //Calls function that takes string and basically calculates or places the number in calculator to previous/answer field
    @IBAction func plus(){
        operatoraction(action: "+")
    }
    
    @IBAction func minus(){
        operatoraction(action: "-")
    }
    
    @IBAction func multi(){
        operatoraction(action: "*")
    }
    
    @IBAction func divide(){
        operatoraction(action: "/")
    }
    
    //calculates the new answer
    @IBAction func equal(){
        if (previousnum == 0 && decindex == 0){
            previousnum = Double(num)
            history.append(Double(String(num) + "." + String(decnum))!)
        }
        else{
            if (calcaction == "+"){
                previousnum = previousnum + Double(String(num) + "." + String(decnum))!
                history.append(Double(String(num) + "." + String(decnum))!)
                historyoperators.append("+")
                
            }
            if (calcaction == "-"){
                previousnum = previousnum - Double(String(num) + "." + String(decnum))!
                history.append(Double(String(num) + "." + String(decnum))!)
                historyoperators.append("-")
            }
            if (calcaction == "*"){
                previousnum = previousnum * Double(String(num) + "." + String(decnum))!
                history.append(Double(String(num) + "." + String(decnum))!)
                historyoperators.append("*")
            }
            if (calcaction == "/"){
                previousnum = previousnum / Double(String(num) + "." + String(decnum))!
                history.append(Double(String(num) + "." + String(decnum))!)
                historyoperators.append("/")
            }
            num = 0
            decnum = 0
            isdecimal = false
            decindex = 0
            calcaction = ""
            updateall()
        }
    }
    
    //MARK:BUTTONS - clears
    //Clears only the answer and things related to it
    @IBAction func clear(){
        num = 0
        decnum = 0
        decindex = 0
        isdecimal = false
        editselected = true
        updatecalc()
    }
    
    //Clears everything
    @IBAction func clearall(){
        leftA.isEnabled = false
        rightA.isEnabled = false
        leftB.isEnabled = false
        leftBR.isEnabled = false
        rightB.isEnabled = false
        rightBR.isEnabled = false
        num = 0
        decnum = 0
        decindex = 0
        isdecimal = false
        previousnum = 0
        calcaction = ""
        history = []
        historyoperators = []
        selected = 0
        edit = false
        updateall()
    }
    
    
    //MARK:BUTTONS - calculation editor
    //Edit button changes the flag between true/false and start selected cell on the last inserted value and enables edit buttons
    @IBAction func editbutton(){
        if (historytext == ""){
            return
        }
        selected = history.count-1
        edit = !edit
        clear()
        editselected = false
        leftA.isEnabled = !leftA.isEnabled
        rightA.isEnabled = !rightA.isEnabled
        leftB.isEnabled = !leftB.isEnabled
        leftBR.isEnabled = !leftBR.isEnabled
        rightB.isEnabled = !rightB.isEnabled
        rightBR.isEnabled = !rightBR.isEnabled
        updateall()
    }
    

    //moves the selected cell to the left (decreases it)
    @IBAction func editleft(){
        if (selected != 0 && edit == true){
            selected -= 1
            updateall()
        }
    }
    
    //moves the selected cell to the right (increases it)
    @IBAction func editright(){
        if (selected != history.count-1 && edit == true){
            selected += 1
            updateall()
        }
    }
    
    @IBAction func bracketLAdd(){
        bracketL.append(selected)
        updateall()
    }
    
    @IBAction func bracketRAdd(){
        if (bracketL.count <= bracketR.count){
            return
        }
        bracketR.append(selected)
        updateall()
    }
    
    @IBAction func bracketLRemove(){
        var x = 0
        while (x < bracketL.count) {
            if (bracketL[x] == selected) {
                bracketL.remove(at: x)
                x = bracketL.count
            }
            x += 1
        }
        updateall()
    }
    
    @IBAction func bracketRRemove(){
        var x = 0
        while (x < bracketR.count) {
            if (bracketR[x] == selected) {
                bracketR.remove(at: x)
                x = bracketR.count
            }
            x += 1
        }
        updateall()
    }


}

