extends Node

# currentLevelName : [Left, Right, Top, Bottom]
var levelConnect = {
	"officeHub" : ["Office/officeTwo", "Office/officeOne", "Office/officeThree", null],
	"officeOne" : ["Office/officeHub", null, null, null],
	"officeTwo" : [null, "Office/officeHub", null, null],
	"officeThree" : [null, null, null, "Office/officeHub"],
	"forestHub" : [null, null, null, null]
}
