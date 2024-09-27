format PE console
entry start

include 'win32ax.inc'

section '.data'
    fileName db 'C:\path\to\your\file.txt', 0 ; Замените на ваш путь к файлу
    successMessage db 'Файл успешно прочитан!', 0
    errorMessage db 'Ошибка при чтении файла!', 0

section '.text'
start:
    ; Получаем размер файла
    invoke File.GetSize, [fileName]
    ; Проверяем, был ли файл успешно открыт
    cmp eax, INVALID_HANDLE_VALUE
    je .error

    ; Если все успешно, выводим сообщение об успехе
    invoke StdOut, successMessage
    invoke CloseHandle, eax ; Закрываем дескриптор файла
    jmp .endd

.error:
    invoke StdOut, errorMessage

.endd:
    invoke ExitProcess, 0

proc File.GetSize uses edi, fileName
    locals
        hFile   dd ?
        length  dd ?
        read    dd ?
        pBuffer dd ?
    endl

    ; Открываем файл
    invoke CreateFile, [fileName], GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov [hFile], eax

    ; Проверяем, успешен ли вызов
    cmp eax, INVALID_HANDLE_VALUE
    je .fail

    ; Получаем размер файла
    invoke GetFileSize, [hFile], 0
    ; Закрываем дескриптор файла
    invoke CloseHandle, [hFile]
    ret

.fail:
    mov eax, INVALID_HANDLE_VALUE
    ret
endp
