package motion

import (
	"fmt"
	"time"
	"bytes"
	"image"
	"encoding/json"
	"encoding/base64"
	//"image/color"
	opencv "gocv.io/x/gocv"
	"net/http"
	"io/ioutil"
	try "github.com/manucorporat/try"
	mjpeg "github.com/0187773933/RaspiMotionAlarm/v2/mjpeg"
	// twilio https://github.com/sfreiberg/gotwilio
)

// https://github.com/hybridgroup/gocv/tree/release/cmd
// https://github.com/hybridgroup/gocv/blob/6240320eed51651fa2be9cfd304605b7497f4b6f/cmd/motion-detect/main.go#L3

// Config
const DeviceID = 0
const DeltaThreshold = 5
const ShowDisplay = false
//const MinimumArea = 500
const MinimumArea = 1000
//const MinimumMotionCounterBeforeEvent = 25
const MinimumMotionCounterBeforeEvent = 10
//const MinimumEventsBeforeAlert = 3
const MinimumEventsBeforeAlert = 1
const AlertCooloffDurationSeconds = 180
const AlertServerHost = "localhost"
const AlertServerPort = "9367"
const AlertServerEndPointURL = "alert"

// Runtime Vars
var LastAlertTime time.Time

// func TwilioSendSMS( from_number string , to_number string , message string ) {
// 	twilio := gotwilio.NewTwilioClient( "accountSid" , "authToken" )
// 	twilio.SendSMS( from_number , to_number , message , "" , "" )
// }

// func TwilioCallNumber( from_number string , to_number string , call_handler_url string ) {
// 	twilio := gotwilio.NewTwilioClient( "accountSid" , "authToken" )
// 	twilio.SendSMS( from_number , to_number , message , "" , "" )
// 	callback_params := gotwilio.NewCallbackParameters( call_handler_url )
// 	twilio.CallWithUrlCallbacks( from_number , to_number , callback_params )
// }

func Alert( frame_buffer []uint8 ) {
	LastAlertTime = time.Now()
	fmt.Println( "sending sms alert" )
	try.This( func() {
        	frame_buffer_b64_string := base64.StdEncoding.EncodeToString(frame_buffer)
	        post_data , _ := json.Marshal(map[string]string{
                	"frame_buffer_b64_string": frame_buffer_b64_string ,
        	})
        	url := fmt.Sprintf( "http://%s:%s/%s" , AlertServerHost , AlertServerPort , AlertServerEndPointURL )
	        client := &http.Client{}
		request , request_error := http.NewRequest( "POST" , url , bytes.NewBuffer( post_data ) )
	        request.Header.Set( "Content-Type" , "application/json" )
        	if request_error != nil { fmt.Println( request_error ); }
	        response , _ := client.Do( request )
        	defer response.Body.Close()
	        body , body_error := ioutil.ReadAll( response.Body )
        	if body_error != nil { fmt.Println( body_error ); }
	        fmt.Println( body )
        }).Catch( func ( e try.E ) {
                fmt.Println( e )
        })
}

func Test( stream *mjpeg.Stream ) {

	LastAlertTime = time.Now()
	// this breaks if you change cool off constant
	duration , _ := time.ParseDuration("-3m")
	LastAlertTime = LastAlertTime.Add( duration )

	// Vars
	motion_counter := 0
	events_counter := 0

	webcam , webcam_error := opencv.OpenVideoCapture( DeviceID )
	if webcam_error != nil { panic( webcam_error ) }
	defer webcam.Close()

	var window *opencv.Window
	if ShowDisplay == true {
		window = opencv.NewWindow( "Motion Window" )
		defer window.Close()
	}

	frame := opencv.NewMat()
	defer frame.Close()

	delta := opencv.NewMat()
	defer delta.Close()

	threshold := opencv.NewMat()
	defer threshold.Close()

	mog2 := opencv.NewBackgroundSubtractorMOG2()
	defer mog2.Close()

	//status := "Ready"
	//status_color_ready := color.RGBA{ 0 , 255 , 0 , 0 }
	//status_color_motion := color.RGBA{ 255 , 0 , 0 , 0 }

	fmt.Printf( "Start reading device: %v\n" , DeviceID )
	for {

		ok := webcam.Read( &frame );
		if !ok { fmt.Printf( "Device closed: %v\n" , DeviceID ); panic( "device closed" ) }
		if frame.Empty() { continue }

		//status = "Ready"

		// Create Delta ( foreground only )
		mog2.Apply( frame , &delta )

		// Create Threshold from Delta
		opencv.Threshold( delta , &threshold , 25 , 255 , opencv.ThresholdBinary )

		// Dilate Threshold , still no intervals , can we just do this twice ?
		kernel := opencv.GetStructuringElement( opencv.MorphRect, image.Pt( 3 , 3 ) )
		defer kernel.Close()
		opencv.Dilate( threshold , &threshold , kernel )
		opencv.Dilate( threshold , &threshold , kernel )

		// Find Contours
		contours := opencv.FindContours( threshold , opencv.RetrievalExternal , opencv.ChainApproxSimple )
		now := time.Now()
		inside_cooloff := true
		difference := now.Sub( LastAlertTime )
		if difference.Seconds() > AlertCooloffDurationSeconds {
			inside_cooloff = false
		}
		fmt.Println( difference , inside_cooloff )
		for _ , contour := range contours {
			area := opencv.ContourArea( contour )
			if area < MinimumArea {
				continue
			} else {
				if inside_cooloff == false {
					motion_counter += 1
				}
			}
			//status = "Motion detected"
			// if ShowDisplay == true {
			// 	opencv.DrawContours( &frame , contours , i , status_color_motion , 2 )
			// 	rect := opencv.BoundingRect( contour )
			// 	opencv.Rectangle( &frame , rect , color.RGBA{ 0 , 0 , 255 , 0 } , 2 )
			// }

			//opencv.DrawContours( &frame , contours , i , status_color_motion , 2 )
			//rect := opencv.BoundingRect( contour )
			//opencv.Rectangle( &frame , rect , color.RGBA{ 0 , 0 , 255 , 0 } , 2 )
		}

		fmt.Printf( "Motion Counter === %d === Events Counter === %d\n" , motion_counter , events_counter )

		// Show Display
		//opencv.PutText( &frame , status , image.Pt( 10 , 20 ) , opencv.FontHersheyPlain , 1.2 , status_color_ready , 2 )
		if ShowDisplay == true {
			window.IMShow( frame )
			if window.WaitKey( 1 ) == 27 {
				break
			}
		}

		// Update MJPEG Stream
		frame_buffer , _ := opencv.IMEncode ( ".jpg" , frame )
		stream.UpdateJPEG( frame_buffer )
		//if frame_buffer_error == nil {
		//	stream.UpdateJPEG( frame_buffer )
		//} else {
		//	fmt.Println( frame_buffer_error )
		//}

                // Calculate State Decisions Based on Current Value of motion_counter
                if motion_counter >= MinimumMotionCounterBeforeEvent { events_counter += 1; motion_counter = 0 }
                if events_counter >= MinimumEventsBeforeAlert { Alert( frame_buffer ); events_counter = 0; motion_counter = 0 }

	}

}