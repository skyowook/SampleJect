package com.skw.samplejectaos.system.activity

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts.PickVisualMedia
import androidx.fragment.app.FragmentActivity
import com.skw.samplejectaos.common.LogTAG
import com.skw.samplejectaos.compose.ComposeSample
import com.skw.samplejectaos.databinding.ActivityMainBinding
import com.skw.samplejectaos.di.HiltTestApi
import com.skw.samplejectaos.di.TestModuleCase1.*
import com.skw.samplejectaos.di.TestModuleCase2.*
import com.skw.samplejectaos.system.fragment.SampleFragment
import dagger.hilt.android.AndroidEntryPoint
import java.io.ByteArrayOutputStream
import java.io.InputStream
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : FragmentActivity() {
    @ProvideCase1
    @Inject lateinit var provideCase1: HiltTestApi
    @ProvideCase1
    @Inject lateinit var provideCase1Same: HiltTestApi

    @ProvideCase2
    @Inject lateinit var provideCase2: HiltTestApi

    @ProvideCase3
    @Inject lateinit var provideCase3: HiltTestApi

    @BindCase1
    @Inject lateinit var bindCase1: HiltTestApi
    @BindCase1
    @Inject lateinit var bindCase1Same: HiltTestApi

    @BindCase2
    @Inject lateinit var bindCase2: HiltTestApi

    lateinit var pickMedia: ActivityResultLauncher<PickVisualMediaRequest>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val transaction = supportFragmentManager.beginTransaction()
        val sample = SampleFragment()
        transaction.add(sample, null)
        transaction.commit()
        val transaction1 = supportFragmentManager.beginTransaction()
        transaction1.remove(sample)
        transaction1.commit()

        hiltTest()

        val binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        pickMedia = registerForActivityResult(PickVisualMedia(), pickMediaCallback)

        binding.btnTestImage.setOnClickListener {
            testPicker()
        }

        binding.btnCompose.setOnClickListener {
            val intent = Intent(this, ComposeSample::class.java)
            startActivity(intent)
        }
    }

    private val pickMediaCallback = ActivityResultCallback<Uri?> { uri ->
        Log.i(LogTAG, "uri :: ${uri?.toString()}")
        try {
            val inputStream: InputStream? = contentResolver.openInputStream(uri!!)
            val buffer = ByteArray(1024)
            val outputStream = ByteArrayOutputStream()
            var bytesRead: Int
            while (inputStream!!.read(buffer).also { bytesRead = it } != -1) {
                outputStream.write(buffer, 0, bytesRead)
            }
            val imageBytes = outputStream.toByteArray()
            val encodedString = Base64.encodeToString(imageBytes, Base64.DEFAULT)
            Log.i(LogTAG, "Base64 Encode :::::: ${encodedString}")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun hiltTest() {
        /* Module Provides Test */
        /// 각 생성 형태 체크
        provideCase1.testLog()
        provideCase2.testLog()
        provideCase3.testLog()

        // Singleton과 별도 impl 테스트
        Log.i(LogTAG, "provideCase1 Singleton Check :: ${provideCase1 == provideCase1Same}")
        Log.i(LogTAG, "provideCase2 None Singleton Check :: ${provideCase1 == provideCase2}")
        Log.i(LogTAG, "provideCase1 Impl :: ${provideCase1.javaClass} provideCase3 Impl :: ${provideCase3.javaClass}")

        /* Module Binds Test */
        bindCase1.testLog()
        bindCase2.testLog()

        Log.i(LogTAG, "bindCase1 Singleton Check :: ${bindCase1 == bindCase1Same}")
    }

    private fun testPicker() {
        pickMedia.launch(PickVisualMediaRequest(PickVisualMedia.ImageOnly))
    }
}