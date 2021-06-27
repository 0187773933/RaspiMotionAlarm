import tensorflow as tf

# Initialize the TFLite interpreter
interpreter = tf.lite.Interpreter( model_path="single_pose_lightning_v3.tflite" )
interpreter.allocate_tensors()

def process_opencv_frame( frame ):
	# image_path = 'PATH_TO_YOUR_IMAGE'
	# image = tf.io.read_file( image_path )
	# image = tf.compat.v1.image.decode_jpeg( image )
	frame = tf.expand_dims(frame, axis=0)
	# Resize and pad the image to keep the aspect ratio and fit the expected size.
	frame = tf.image.resize_with_pad( frame , 192 , 192 )

	# TF Lite format expects tensor type of float32.
	input_frame = tf.cast(image, dtype=tf.float32)
	input_details = interpreter.get_input_details()
	output_details = interpreter.get_output_details()
	interpreter.set_tensor(input_details[0]['index'], input_frame.numpy())
	interpreter.invoke()
	# Output is a [1, 1, 17, 3] numpy array.
	keypoints_with_scores = interpreter.get_tensor(output_details[0]['index'])
	print( keypoints_with_scores )

def OnMotionFrame( frame ):
	print( "here in on motion frame callback" )
	print( frame )