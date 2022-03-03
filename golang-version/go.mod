module golang-version

go 1.17

require (
	github.com/hennedo/escpos v0.0.1
	github.com/tarm/serial v0.0.0-20180830185346-98f6abe2eb07
)

require (
	github.com/qiniu/iconv v1.2.0 // indirect
	github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e // indirect
	golang.org/x/sys v0.0.0-20220227234510-4e6760a101f9 // indirect
)

replace github.com/hennedo/escpos => ../escpos-fork
