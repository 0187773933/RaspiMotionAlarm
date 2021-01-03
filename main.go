package main

import (
	"log"
	"net/http"
	_ "net/http/pprof"
	mjpeg "github.com/hybridgroup/mjpeg"
	motion "github.com/0187773933/RaspiMotionAlarm/v2"
)

func main() {
	stream := mjpeg.NewStream()
	go motion.Test( stream )

	// start http server
	// http://localhost:9363/frame.jpeg
	http.Handle( "/frame.jpeg" , stream )
	log.Fatal( http.ListenAndServe( "0.0.0.0:9363" , nil ) )
}