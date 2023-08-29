package com.skw.samplejectaos.di

import android.util.Log
import com.skw.samplejectaos.common.LogTAG
import javax.inject.Inject

/**
 * Hilt 테스트 구현체 (Provide와 Binds 테스트를 위해 생성자 2개 만들어둠)
 */
class HiltTestApiImpl2 @Inject constructor(): HiltTestApi {
    private var testName: String = "HiltTestApiImpl2"

    constructor(name: String) : this() {
        this.testName = name
    }

    override fun testLog() {
        Log.i(LogTAG, "test name :: $testName")
    }
}