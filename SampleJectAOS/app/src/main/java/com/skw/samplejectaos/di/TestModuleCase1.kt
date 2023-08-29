package com.skw.samplejectaos.di

import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Qualifier
import javax.inject.Singleton

/**
 * Provide 테스트 모듈
 */
@Module
@InstallIn(SingletonComponent::class)   // InstallIn에 사용되는 Component에 따라 모듈 사용 범위가 지정됨.
class TestModuleCase1 {

    @ProvideCase1
    @Provides
    @Singleton
    fun provideCase1(): HiltTestApi {
        return HiltTestApiImpl1("ProvideCase1 :: Singleton")
    }

    @ProvideCase2
    @Provides
    fun provideCase2(): HiltTestApi {
        return HiltTestApiImpl1("ProvideCase2 :: None Singleton")
    }

    @ProvideCase3
    @Provides
    fun provideCase3(): HiltTestApi {
        return HiltTestApiImpl2("ProvideCase3 :: Other Impl")
    }

    @Qualifier annotation class ProvideCase1
    @Qualifier annotation class ProvideCase2
    @Qualifier annotation class ProvideCase3
}