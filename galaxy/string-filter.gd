extends Resource
class_name Filter

var bad_words: Array = [
	"fuc",
	"fuk",
	"fag",
	"nga",
	"ngr",
	"nig",
	"cnt",
	"cum",
	"kum",
	"jew",
	"jap",
	"kkk",
	"sex",
]

func check_string(string):
	if bad_words.has(string):
		return true
	else:
		return false
