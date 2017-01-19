#include "com_wxj_jni_demo_JniDemo.h"
#include <stdio.h>
#include <stdlib.h>
#include <string>


JNIEXPORT void JNICALL Java_com_wxj_jni_demo_JniDemo_printf
  (JNIEnv * env, jobject jobj, jstring jstr)
{
	const char* p_str = (char*)env->GetStringUTFChars(jstr, 0);
	printf("%s\n", p_str);
}
