package com.wxj.jni.demo;

public class JniDemo{
	 
	 public native void printf(String str);
    
	 public static void main(String[] args){
	    System.loadLibrary("JniDemo");
		
		JniDemo jniDemo = new JniDemo();
		
		jniDemo.printf("hello world!");
	 }
}
