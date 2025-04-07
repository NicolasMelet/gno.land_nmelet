package calculator

import (
	"strings"

	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/txlink"
)

var (
	val        float64
	displayVal string
)

func init() {
	displayVal = "0"
}

func addToMath(newEl string) {
	val++
	ufmt.Print("add to math")
	if displayVal == "0" {
		displayVal = newEl
		return
	}
	displayVal += newEl
}

func Render(_ string) string {
	ufmt.Print("TEEEEE")
	var sb strings.Builder
	sb.WriteString(`# Calculator page

Have you ever wanted to do maths but never actually found a calculator ?
Do I have the realm for you...

Result: ` + displayVal + ufmt.Sprintf("%f\n", val) + `
---------------
| res|||del|
|---|---|---|---|
|  ` + ufmt.Sprintf("[7](%s)", txlink.Call("addToMath", "newEl", "7")) + `|  8|  9|  +|
|  4|  5|  6|  -|
|  1|  2|  3|  *|
|  0|  .|  =|  /|`)
	// ufmt.Sprint("%f", val)
	return sb.String()
}
