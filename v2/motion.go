package motion

import (
	"fmt"
	"image"
	"image/color"
	opencv "gocv.io/x/gocv"
	mjpeg "github.com/0187773933/RaspiMotionAlarm/v2/mjpeg"
	// twilio https://github.com/sfreiberg/gotwilio
)

// https://github.com/hybridgroup/gocv/tree/release/cmd
// https://github.com/hybridgroup/gocv/blob/6240320eed51651fa2be9cfd304605b7497f4b6f/cmd/motion-detect/main.go#L3

// Config
const DeviceID = 0
const DeltaThreshold = 5
const ShowDisplay = true

//const MinimumArea = 500
const MinimumArea = 1000
const MinimumMotionCounterBeforeEvent = 25
const MinimumEventsBeforeAlert = 3

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

func Alert() {
	fmt.Println( "sending sms alert" )
}

func Test( stream *mjpeg.Stream ) {

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

	status := "Ready"
	status_color_ready := color.RGBA{ 0 , 255 , 0 , 0 }
	status_color_motion := color.RGBA{ 255 , 0 , 0 , 0 }

	fmt.Printf( "Start reading device: %v\n" , DeviceID )
	for {

		ok := webcam.Read( &frame );
		if !ok { fmt.Printf( "Device closed: %v\n" , DeviceID ); panic( "device closed" ) }
		if frame.Empty() { continue }

		status = "Ready"

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
		for i , contour := range contours {
			area := opencv.ContourArea( contour )
			if area < MinimumArea {
				continue
			} else {
				motion_counter += 1
			}
			status = "Motion detected"
			// if ShowDisplay == true {
			// 	opencv.DrawContours( &frame , contours , i , status_color_motion , 2 )
			// 	rect := opencv.BoundingRect( contour )
			// 	opencv.Rectangle( &frame , rect , color.RGBA{ 0 , 0 , 255 , 0 } , 2 )
			// }
			opencv.DrawContours( &frame , contours , i , status_color_motion , 2 )
			rect := opencv.BoundingRect( contour )
			opencv.Rectangle( &frame , rect , color.RGBA{ 0 , 0 , 255 , 0 } , 2 )
		}

		fmt.Printf( "Motion Counter === %d === Events Counter === %d\n" , motion_counter , events_counter )

		// Calculate State Decisions Based on Current Value of motion_counter
		if motion_counter >= MinimumMotionCounterBeforeEvent { events_counter += 1; motion_counter = 0 }
		if events_counter >= MinimumEventsBeforeAlert { Alert(); events_counter = 0; motion_counter = 0 }

		// Show Display
		opencv.PutText( &frame , status , image.Pt( 10 , 20 ) , opencv.FontHersheyPlain , 1.2 , status_color_ready , 2 )
		if ShowDisplay == true {
			window.IMShow( frame )
			if window.WaitKey( 1 ) == 27 {
				break
			}
		}

		// Update MJPEG Stream
		frame_buffer , frame_buffer_error := opencv.IMEncode ( ".jpg" , frame )
		if frame_buffer_error == nil {
			stream.UpdateJPEG( frame_buffer )
		} else {
			fmt.Println( frame_buffer_error )
		}

	}

}