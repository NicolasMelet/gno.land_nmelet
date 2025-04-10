package calculator

import (
	"strconv"
	"strings"

	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/txlink"
)

type Node struct {
	value string // Value of the current node
	left  *Node
	right *Node
}

const (
	specialCharacters = "+-*/."
	topPriority       = "*/"
	lowPriority       = "+-"
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

func evaluateValidity(line string) {
	if len(line) == 0 {
		panic("Invalid empty input")
	} // edge case empty line
	if strings.Index(specialCharacters, string(line[0])) != -1 ||
		strings.Index(specialCharacters, string(line[len(line)-1])) != -1 {
		panic("Invalid equation")
	} // edge case special character at begining or end

	isPriorSpecial := false

	for i := 1; i < len(line)-1; i++ {
		if strings.Index(specialCharacters, string(line[i])) != -1 {
			if isPriorSpecial {
				panic("Invalid equation")
			}
			isPriorSpecial = true
			continue
		}
		isPriorSpecial = false
	}
}

func searchForPriority(priorityList string, line string) *Node {
	for i := 0; i < len(priorityList); i++ {
		idx := strings.Index(line, string(priorityList[i]))
		if idx != -1 {
			return &Node{string(line[idx]), createTree(line[:idx]), createTree(line[idx:])}
		}
	}
	return nil
}

func createTree(line string) *Node {
	node := searchForPriority(lowPriority, line) // we put the lowest priority at the top of the tree, these operations will be executed last
	if node != nil {
		return node
	}
	node = searchForPriority(topPriority, line)
	if node != nil {
		return node
	}

	// if this code is reached, the only value possible in line is a number
	return &Node{line, nil, nil}
}

// func readTree(tree *Node) float64 {

// }

func ComputeResult() {
	evaluateValidity(displayVal)
	// tree := createTree(displayVal)

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
