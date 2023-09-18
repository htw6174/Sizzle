extends Node

var money: int = 0:
	get:
		return money

signal money_added(value: int)
signal money_subtracted(value: int)

func init():
	pass

func add_money(value: int):
	value = max(0, value)
	money += value
	money_added.emit(value)

func subtract_money(value: int) -> bool:
	value = max(0, value)
	if value > money:
		return false
	else:
		money -= value
		money_subtracted.emit(value)
		return true
