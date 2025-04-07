package calculator

import (
	"strconv"
	"strings"

	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/txlink"
)

var (
	val        float64
	displayVal string
)

func init() {
	val = 0
	displayVal = "0"
}

func AddToMath(newEl string) {
	ufmt.Print("add to math %s", newEl)
	if displayVal == "0" {
		displayVal = newEl
		return
	}
	displayVal += newEl
}

func Reset() {
	val = 0
	displayVal = "0"
}

func ComputeResult() {
	val = 0 // work in progress, no computation actually made for now
	displayVal = strconv.FormatFloat(val, 'g', 6, 64)
}

func RemoveLast() {
	lenVal := len(displayVal)
	if lenVal > 1 {
		displayVal = displayVal[:lenVal-1]
	} else if lenVal == 1 {
		displayVal = "0"
	}
}

func Render(_ string) string {
	var sb strings.Builder
	sb.WriteString(`# Calculator page

Have you ever wanted to do maths but never actually found a calculator ?
Do I have the realm for you...

Result: ` + displayVal + `
---------------
| ` + ufmt.Sprintf("[res](%s)", txlink.Call("Reset")) + `|||` + ufmt.Sprintf("[del](%s)", txlink.Call("RemoveLast")) + `|
|---|---|---|---|
| ` + ufmt.Sprintf("[7](%s)", txlink.Call("AddToMath", "newEl", "7")) + `| ` + ufmt.Sprintf("[8](%s)", txlink.Call("AddToMath", "newEl", "8")) + `| ` + ufmt.Sprintf("[9](%s)", txlink.Call("AddToMath", "newEl", "9")) + `| ` + ufmt.Sprintf("[+](%s)", txlink.Call("AddToMath", "newEl", `+`)) /* Adena transforms non alphanumeric char to their hexadecimal values as of now*/ + `|
| ` + ufmt.Sprintf("[4](%s)", txlink.Call("AddToMath", "newEl", "4")) + `| ` + ufmt.Sprintf("[5](%s)", txlink.Call("AddToMath", "newEl", "5")) + `| ` + ufmt.Sprintf("[6](%s)", txlink.Call("AddToMath", "newEl", "6")) + `| ` + ufmt.Sprintf("[-](%s)", txlink.Call("AddToMath", "newEl", "-")) + `|
| ` + ufmt.Sprintf("[1](%s)", txlink.Call("AddToMath", "newEl", "1")) + `| ` + ufmt.Sprintf("[2](%s)", txlink.Call("AddToMath", "newEl", "2")) + `| ` + ufmt.Sprintf("[3](%s)", txlink.Call("AddToMath", "newEl", "3")) + `| ` + ufmt.Sprintf("[*](%s)", txlink.Call("AddToMath", "newEl", "*")) + `|
| ` + ufmt.Sprintf("[0](%s)", txlink.Call("AddToMath", "newEl", "0")) + `| ` + ufmt.Sprintf("[.](%s)", txlink.Call("AddToMath", "newEl", ".")) + `| ` + ufmt.Sprintf("[=](%s)", txlink.Call("ComputeResult")) + `| ` + ufmt.Sprintf("[/](%s)", txlink.Call("AddToMath", "newEl", "/")) + `|
`)
	// ufmt.Sprint("%f", val)
	return sb.String()
}
