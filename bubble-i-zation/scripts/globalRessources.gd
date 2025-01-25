extends Node

class_name globalRessources

var pops
var mat
var food
var water
var oxygen
var fuel

var cities: Array[RessourceNode] = []
var factories: Array[RessourceNode] = []
var citiesAndFactories = cities & factories

func add_to_cities (ressourceNode:RessourceNode):
	cities += ressourceNode
