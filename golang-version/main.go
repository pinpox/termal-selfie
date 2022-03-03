package main

import (
	"image"
	_ "image/gif"
	_ "image/jpeg"
	"log"
	"os"

	"github.com/hennedo/escpos"

	"github.com/tarm/serial"
)

func main() {
	c := &serial.Config{Name: "/dev/ttyS1", Baud: 9600}
	socket, err := serial.OpenPort(c)
	if err != nil {
		log.Fatal(err)
	}
	defer socket.Close()

	p := escpos.New(socket)

	// add here:
	p.SetConfig(escpos.ConfigEpsonTMT88II)

	f, err := os.Open("./logo.gif")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	img, fmtName, err := image.Decode(f)

	if err != nil {
		panic(err)
	}

	log.Println(fmtName)
	p.PrintImage(img)

	// p.LineFeed()

	p.Size(1, 1).Justify(escpos.JustifyCenter).Write("This is a test")

	// p.WriteRaw([]byte{'\n'})

	// png, err := qrcode.Encode("https://example.org", qrcode.Medium, 256)
	// p.QRCode("https://github.com/hennedo/escpos", true, 10, escpos.QRCodeErrorCorrectionLevelH)

	// convert []byte to image for saving to file
	// img2, _, _ := image.Decode(bytes.NewReader(png))
	// p.PrintImage(img2)

	// p.WriteRaw([]byte{'\n'})
	// p.Write("megaclan3000 is love, megaclan3000 is life.")

	// p.Size(1, 1).Justify(escpos.JustifyCenter).Write("megaclan3000 is love, megaclan3000 is life")

	// You need to use either p.Print() or p.PrintAndCut() at the end to send the data to the printer.
	// var esc byte = 0x1B
	// var gs byte = 0x1D
	// p.WriteRaw([]byte{esc, 'm'})

	//Linefeed
	// p.WriteRaw([]byte{'\n'})

	// var cutters []byte = []byte{0x1D, 0x56, 0x42, 0xA}
	// p.WriteRaw(cutters)

	p.PrintAndCut()
}
