package io.bytre

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import io.flutter.plugin.common.BinaryMessenger
import java.io.FileNotFoundException
import java.io.IOException

private const val CHANNEL = "io.bytre/storage"
private const val PERM_CHANNEL = "$CHANNEL/permissions"
private const val CRUD_CHANNEL = "$CHANNEL/crud"
private const val OPEN_DIRECTORY_REQUEST_CODE = 100

enum class ErrorCodes(val code: String) {
    NOT_FOUND("NOT_FOUND"),
    OPERATION_FAILED("OPERATION_FAILED"),
    MISSING_URI("MISSING_URI"),
    USER_CANCELLED("USER_CANCELLED")
}

class MainActivity: FlutterActivity() {
    private var reqPermResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERM_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "request") {
                reqPermResult = result
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
                intent.addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                        or Intent.FLAG_GRANT_READ_URI_PERMISSION
                        or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                startActivityForResult(intent, OPEN_DIRECTORY_REQUEST_CODE)
            }
        }

        val options = BinaryMessenger.TaskQueueOptions().apply { isSerial = false }
        val taskQueue = flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue(options)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CRUD_CHANNEL, StandardMethodCodec.INSTANCE, taskQueue).setMethodCallHandler {
            call, result ->

            // Used as a return type to ensure all crud operations call a result
            abstract class ResultReturn {
                abstract fun build()
            }

            class ResultReturnSuccess(val obj: Any?): ResultReturn() {
                override fun build() {
                    result.success(obj)
                }
            }

            class ResultReturnError(val errCode: ErrorCodes, val message: String, val detail: String? = null): ResultReturn() {
                override fun build() {
                    result.error(errCode.code, message, detail)
                }
            }

            fun crudOperation(operation: (uri: Uri) -> ResultReturn) {
                val uri = Uri.parse(call.argument("uri"))
                operation(uri).build()
            }

            fun serializeDocument(file: DocumentFile): HashMap<String, String> = hashMapOf(
                    "name" to (file.name ?: "???"),
                    "uri" to file.uri.toString(),
                    "type" to when {
                        file.isDirectory -> "dir"
                        else -> "file"
                    }
            )

            when (call.method) {
                "createFile" -> crudOperation { uri ->
                    val name = call.argument<String>("name")!!
                    val doc = DocumentFile.fromTreeUri(this, uri)!!
                    var mimeType = MimeTypeMap.getFileExtensionFromUrl(uri.toString())
                    if (mimeType.isEmpty()) mimeType = "*/*"
                    val file = doc.createFile(mimeType, name)
                    if (file == null) ResultReturnError(ErrorCodes.OPERATION_FAILED, "Failed to create file '$name'")
                    else ResultReturnSuccess(serializeDocument(file))
                }
                "createDirectory" -> crudOperation { uri ->
                    val name = call.argument<String>("name")!!
                    val doc = DocumentFile.fromTreeUri(this, uri)!!
                    val dir = doc.createDirectory(name)
                    if (dir == null) ResultReturnError(ErrorCodes.OPERATION_FAILED, "Failed to create directory '$name'")
                    else ResultReturnSuccess(serializeDocument(dir))
                }
                "readFile" -> crudOperation { uri ->
                    val name = DocumentFile.fromTreeUri(this, uri)!!.name
                    val errorMsg = "Failed to read file '$name'"
                    try {
                        val stream = contentResolver.openInputStream(uri)
                        if (stream == null) {
                            ResultReturnError(ErrorCodes.OPERATION_FAILED, errorMsg, "Document provider recently crashed")
                        } else {
                            val bytes = stream.readBytes()
                            stream.close()
                            ResultReturnSuccess(bytes)
                        }
                    } catch (e: FileNotFoundException) {
                        ResultReturnError(ErrorCodes.NOT_FOUND, errorMsg, "File not found")
                    } catch (e: IOException) {
                        ResultReturnError(ErrorCodes.OPERATION_FAILED, errorMsg, "IO error encountered")
                    }
                }
                "writeFile" -> crudOperation { uri ->
                    val name = DocumentFile.fromTreeUri(this, uri)!!.name
                    val errorMsg = "Failed to write file '$name'"
                    val bytes = call.argument<ByteArray>("data")!!
                    try {
                        val stream = contentResolver.openOutputStream(uri)
                        if (stream == null) {
                            ResultReturnError(ErrorCodes.OPERATION_FAILED, errorMsg, "Document provider recently crashed")
                        } else {
                            stream.write(bytes)
                            stream.close()
                            ResultReturnSuccess(null)
                        }
                    } catch (e: FileNotFoundException) {
                        ResultReturnError(ErrorCodes.NOT_FOUND, errorMsg, "File not found")
                    } catch (e: IOException) {
                        ResultReturnError(ErrorCodes.OPERATION_FAILED, errorMsg, "IO error encountered")
                    }
                }
                "deleteRecursively" -> crudOperation { uri ->
                    ResultReturnSuccess(DocumentFile.fromTreeUri(this, uri)!!.delete())
                }
                "listDirectory" -> crudOperation { uri ->
                    val doc = DocumentFile.fromTreeUri(this, uri)!!
                    ResultReturnSuccess(doc.listFiles().map{file -> serializeDocument(file)})
                }
                "isFile" -> crudOperation { uri ->
                    val doc = DocumentFile.fromTreeUri(this, uri)!!
                    ResultReturnSuccess(doc.isFile)
                }
                "isDirectory" -> crudOperation { uri ->
                    val doc = DocumentFile.fromTreeUri(this, uri)!!
                    ResultReturnSuccess(doc.isDirectory)
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            OPEN_DIRECTORY_REQUEST_CODE -> {
                if (resultCode == RESULT_OK) {
                    val uri = data?.data
                    if (uri == null) {
                        reqPermResult?.error(ErrorCodes.MISSING_URI.code, null, null)
                    } else {
                        contentResolver.takePersistableUriPermission(uri,
                                Intent.FLAG_GRANT_READ_URI_PERMISSION
                                or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                        val root = DocumentFile.fromTreeUri(this, uri)!!
                        reqPermResult?.success(hashMapOf(
                            "name" to root.name,
                            "uri" to root.uri.toString()
                        ))
                    }
                } else {
                    reqPermResult?.error(ErrorCodes.USER_CANCELLED.code, null, null)
                }
                reqPermResult = null
            }
        }
    }
}
