logFile dd ?
logFileName db "log.txt", 0
FILE_CREATED_SUCCESSFULLY String "File created successfully", 10
FILE_CREATION_FAILED String "File creation failed", 10
SHADER_LOADED_SUCCESSFULLY String "shader loaded successfully", 10
SHADER_LOADED_FAILED String "shader loaded failed", 10
BMP_LOADED_SUCCESSFULLY String "bmp loaded succesfully", 0, 10

charsWritten dd ?
define FILE_LOG 1
define CONSOLE_LOG 0