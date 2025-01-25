extends Resource

class_name ProductionResource

enum ResourceType {
	BauMatsStone,
	BaumMatsWood,
	Brennstoff,
	Food,
	Oxygen,
	Water
}

@export var resource_type: ResourceType
