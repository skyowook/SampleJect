package com.skw.samplejectaos.activity

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import com.skw.samplejectaos.common.LogTAG
import com.skw.samplejectaos.databinding.ActivityMainBinding
import com.skw.samplejectaos.di.HiltTestApi
import com.skw.samplejectaos.di.TestModuleCase1.*
import com.skw.samplejectaos.di.TestModuleCase2.*
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        hiltTest()

        setContentView(ActivityMainBinding.inflate(layoutInflater).root)
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
}