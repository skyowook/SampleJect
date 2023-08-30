package com.skw.tosssampleaos

import android.content.Context
import android.content.SharedPreferences
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import androidx.lifecycle.LifecycleCoroutineScope
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import java.io.IOException
import java.security.GeneralSecurityException
import kotlin.coroutines.CoroutineContext
import kotlin.coroutines.EmptyCoroutineContext

@Throws(GeneralSecurityException::class, IOException::class)
fun getSecurePref(context: Context): SharedPreferences {
    val spec = KeyGenParameterSpec.Builder(
        MasterKey.DEFAULT_MASTER_KEY_ALIAS,
        KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
    )
        .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
        .setKeySize(256).build()


    val master = MasterKey.Builder(context).setKeyGenParameterSpec(spec).build()
    return EncryptedSharedPreferences.create(
        context,
        "SECURE_PREF_FILE",
        master,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )
}

fun LifecycleCoroutineScope.launchSilently(
    context: CoroutineContext = EmptyCoroutineContext,
    start: CoroutineStart = CoroutineStart.DEFAULT,
    block: suspend CoroutineScope.() -> Unit
): Job = launchSafely(context, start, block, null)

fun LifecycleCoroutineScope.launchSafely(
    context: CoroutineContext = EmptyCoroutineContext,
    start: CoroutineStart = CoroutineStart.DEFAULT,
    block: suspend CoroutineScope.() -> Unit,
    handleException: ((Throwable) -> Unit)?
): Job {

    val exceptionHandler = CoroutineExceptionHandler { _, exception ->
        handleException?.invoke(exception)
    }

    return launch(
        context = context + exceptionHandler,
        start = start,
        block = block
    )
}