package com.niusounds.flutter_pd.exception

import java.lang.Exception

class PdException(val code: String,
                  message: String?,
                  val detail: Any? = null) : Exception(message)
