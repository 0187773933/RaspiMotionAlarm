package main

import (
	"fmt"
	"log"
	"time"
	"net/http"
	_ "net/http/pprof"
	bcrypt "golang.org/x/crypto/bcrypt"
	auth "github.com/abbot/go-http-auth"
	//mjpeg "github.com/hybridgroup/mjpeg"
	mjpeg "github.com/0187773933/RaspiMotionAlarm/v2/mjpeg"
	motion "github.com/0187773933/RaspiMotionAlarm/v2"
)

// Switch to Fiber
// https://docs.gofiber.io/api/middleware/basicauth
// https://docs.gofiber.io/api/middleware#helmet
// https://docs.gofiber.io/api/app#handler

var stream *mjpeg.Stream

// func Secret( user , realm string ) string {
// 	if user == "john" {
// 		// password is "hello"
// 		return "$1$dlPL2MqE$oQmn16q49SqdmhenQuNgs1"
// 	}
// 	return ""
// }

// https://github.com/abbot/go-http-auth/issues/56#issuecomment-393651189
// https://pkg.go.dev/golang.org/x/crypto/bcrypt#GenerateFromPassword
func Secret( user , realm string ) string {
	if user == "admin" {
		hashedPassword , err := bcrypt.GenerateFromPassword( []byte( "waduwaduwadu" ) , bcrypt.DefaultCost )
		if err == nil {
			return string( hashedPassword )
		}
	}
	return ""
}

// https://golang.org/pkg/net/http/#ServeMux.HandleFunc
// https://github.com/abbot/go-http-auth/blob/7f557639efd97bd84723b69471931553e1e0ade9/basic.go#L134
// https://github.com/hybridgroup/mjpeg/blob/master/stream.go#L18
// https://golang.org/pkg/net/http/#ResponseWriter
func handle( w http.ResponseWriter , r *auth.AuthenticatedRequest ) {
	w.Header().Add( "Content-Type" , "multipart/x-mixed-replace;boundary=MJPEGBOUNDARY" )
	c := make( chan []byte )
	stream.Lock.Lock()
	stream.M[ c ] = true
	stream.Lock.Unlock()
	for {
		time.Sleep( stream.FrameInterval )
		b := <-c
		_, err := w.Write( b )
		if err != nil {
			break
		}
	}
	stream.Lock.Lock()
	delete( stream.M , c )
	stream.Lock.Unlock()
	log.Println( "Stream:" , r.RemoteAddr , "disconnected" )
}

func main() {
	stream = mjpeg.NewStream()
	go motion.Test( stream )

	// start http server
	// https://medium.com/better-programming/hands-on-with-jwt-in-golang-8c986d1bb4c0
	// http://localhost:9363/frame.jpeg
	//http.Handle( "/frame.jpeg" , stream )
	authenticator := auth.NewBasicAuthenticator( "localhost" , Secret )
	http.HandleFunc( "/frame.jpeg" , authenticator.Wrap( handle ) )
	log.Fatal( http.ListenAndServe( "0.0.0.0:9363" , nil ) )
}