package calculator

import (
	"gno.land/p/demo/ufmt"
)

var val int

func Render(_ string) string {
	return ufmt.Sprintf("%d", count)
}
