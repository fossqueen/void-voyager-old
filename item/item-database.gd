extends Node


enum ITEM_TYPE { CONSUMER, FOOD, ILLICIT, INDUSTRIAL, MEDICINE, MINERAL, SPECIALTY }


const FUEL: Dictionary = {
	
	"Cost": 10
}


const DATABASE: Dictionary = {
	
	0 : {
		"Name": "Platinum",
		"Type": ITEM_TYPE.MINERAL,
		"Desc": "",
		"Cost": 200,
	},
	
	1 : {
		"Name": "Gold",
		"Type": ITEM_TYPE.MINERAL,
		"Desc": "",
		"Cost": 100,
	},
	
	2 : {
		"Name": "Silver",
		"Type": ITEM_TYPE.MINERAL,
		"Desc": "",
		"Cost": 100,
	},
	
	3 : {
		"Name": "Iron",
		"Type": ITEM_TYPE.MINERAL,
		"Desc": "",
		"Cost": 50,
	},
	
	4 : {
		"Name": "Nickel",
		"Type": ITEM_TYPE.MINERAL,
		"Desc": "",
		"Cost": 50,
	},
	
	5 : {
		"Name": "Diamonds",
		"Type": ITEM_TYPE.MINERAL,
		"Desc": "",
		"Cost": 500,
	},
	
	6 : {
		"Name": "Welding Kit",
		"Type": ITEM_TYPE.SPECIALTY,
		"Desc": "Make your own repairs to your ship! Require's 'Scrap Metal'.",
		"Cost": 1000,
	},
	
	7 : {
		"Name": "Scrap Metal",
		"Type": ITEM_TYPE.INDUSTRIAL,
		"Desc": "Processed minerals. Used for maintaining stations and in a pinch, ships!",
		"Cost": 25,
	},
	
	
	
}
