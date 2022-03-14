package sins.test.sampleject.activity

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.view.View
import sins.test.sampleject.R
import sins.test.sampleject.dialog.SBottomSheetDialogFragment

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<View>(R.id.btn_test2).setOnClickListener {
            SBottomSheetDialogFragment().show(supportFragmentManager, "test")
        }
    }
}