extends Node

# currentLevelName : [Left, Right, Top, Bottom]
var levelConnect = {
	"officeHub" : ["Office/officeTwo", "Office/officeOne", "Office/officeThree", null],
	"officeOne" : ["Office/officeHub", null, null, null],
	"officeTwo" : [null, "Office/officeHub", null, null],
	"officeThree" : [null, null, null, "Office/officeHub"],
	"forestHub" : [null, "forestOne", null, null],
	"forestOne" : ["forestHub", "forestTwo", null, null],
	"forestTwo" : ["forestOne", null, null, null]
}

var openDoors = {
	"forestHub" : [false, false],
	"forestOne" : [false],
	"forestTwo" : [false]
}

var pointsTaken = {
	"forestHub" : [false, false],
	"forestOne" : [false, false],
	"forestTwo" : [false, false]
}
