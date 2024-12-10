package com.nextmedia.streax


import android.content.Intent
import android.view.View
import android.widget.Toast
import androidx.annotation.Nullable
import androidx.core.net.toFile
import com.snap.camerakit.support.app.CameraActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {

   // private val CAMERAKIT_GROUP_ID = ""//TODO fill group id here
    private val LENS_GROUP_IDS = arrayOf("dfc17eb3-faa2-40ff-8f3c-751a3ae1218f")
    private val CAMERAKIT_API_TOKEN = "eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNzMwNzEyMzU5LCJzdWIiOiIxZjU4YjAyNS0wOTI5LTQzNWEtYTRiMy04MDkzN2Y3Y2EzODd-UFJPRFVDVElPTn5mMDQ5MTZlNi0zNDU1LTRmMGYtOGEyYi0xMzdhN2Y2ZmMzYzcifQ.U6W6SY7xYAR7v4xShI2T_Y5hsoXcJBe7pSTuLViWLFI"
    private val CHANNEL = "com.nextmedia.streax.sc.camera"

    private lateinit var _result: MethodChannel.Result
    private lateinit var _methodChannel: MethodChannel

    private val captureLauncher =
        (this as FlutterFragmentActivity).registerForActivityResult(CameraActivity.Capture) { captureResult ->
            when (captureResult) {
                is CameraActivity.Capture.Result.Success.Video -> {
                    _result.success(hashMapOf("path" to captureResult.uri.toFile().absolutePath.toString(),
                        "mime_type" to "video"))
                }
                is CameraActivity.Capture.Result.Success.Image -> {
                    _result.success(hashMapOf("path" to captureResult.uri.toFile().absolutePath.toString(),
                        "mime_type" to "image"))
                }
                is CameraActivity.Capture.Result.Cancelled -> {
                    Toast.makeText(this@MainActivity, "Action cancelled", Toast.LENGTH_SHORT).show()
                    _result.error("Cancelled", "Action Cancelled", null)
                }
                is CameraActivity.Capture.Result.Failure -> {
                    Toast.makeText(this@MainActivity, "Action failed", Toast.LENGTH_SHORT).show()
                    _result.error("Failure", "Action failed", null)
                }
            }
        }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        _methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        _methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "openCameraKitLenses") {
                _result = result
                captureLauncher.launch(
                    CameraActivity.Configuration.WithLenses(
                        lensGroupIds = LENS_GROUP_IDS,
                        cameraKitApiToken = CAMERAKIT_API_TOKEN,
                        cameraAdjustmentsConfiguration = CameraActivity.AdjustmentsConfiguration(
                            toneAdjustmentEnabled = true,
                            portraitAdjustmentEnabled = true
                        ),
                        cameraFacingBasedOnLens = true,
                        cameraFacingFlipEnabled = true,
                        cameraFlashEnabled = true,
                    )





//                    CameraActivity.Configuration.WithLenses(F
//                        cameraKitApiToken = CAMERAKIT_API_TOKEN,
//                        lensGroupIds = arrayOf(CAMERAKIT_GROUP_ID)
//                    )
                )
            } else {
                result.notImplemented()
            }
        }
    }
}
