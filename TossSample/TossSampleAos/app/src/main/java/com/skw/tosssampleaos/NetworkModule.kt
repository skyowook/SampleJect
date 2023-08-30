package com.skw.tosssampleaos

import com.google.gson.Gson
import com.skw.tosssampleaos.toss.TossApi
import com.skw.tosssampleaos.toss.TossOAuthApi
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
class NetworkModule {
    @Provides
    @Singleton
    fun provideTossApi(): TossApi {
        return Retrofit.Builder()
            .baseUrl(AppConstants.TOSS_API_SERVER)
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .build()
            .create(TossApi::class.java)
    }
    @Provides
    @Singleton
    fun provideTossAuthApi(): TossOAuthApi {
        return Retrofit.Builder()
            .baseUrl(AppConstants.TOSS_OAUTH_SERVER)
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .build()
            .create(TossOAuthApi::class.java)
    }
}