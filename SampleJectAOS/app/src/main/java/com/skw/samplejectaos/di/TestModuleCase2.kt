package com.skw.samplejectaos.di

import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Qualifier
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class TestModuleCase2 {
    @Qualifier annotation class BindCase1
    @Qualifier annotation class BindCase2

    @BindCase1
    @Binds
    @Singleton
    abstract fun bindCase1(impl: HiltTestApiImpl1): HiltTestApi

    @BindCase2
    @Binds
    abstract fun bindCase2(impl: HiltTestApiImpl2): HiltTestApi
}