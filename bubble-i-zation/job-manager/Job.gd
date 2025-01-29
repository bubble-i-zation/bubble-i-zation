extends Node
class_name Job

var isCompleted := false
var isStarted := false
var isPerfomingAction := false
var isAborted := false
# This is the base class of a job and defines the interface for all job-types

# Excute will run in the process lifesycle of the porter class
func execute(porter:Porter):
	pass # This will be overridden in child classes 
