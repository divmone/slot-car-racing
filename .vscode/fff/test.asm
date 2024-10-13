format PE console
entry start

include 'win32ax.inc'

section '.data'
    fileName db 'C:\path\to\your\file.txt', 0 ; �������� �� ��� ���� � �����
    successMessage db '���� ������� ��������!', 0
    errorMessage db '������ ��� ������ �����!', 0

section '.text'
start:
    ; �������� ������ �����
    invoke File.GetSize, [fileName]
    ; ���������, ��� �� ���� ������� ������
    cmp eax, INVALID_HANDLE_VALUE
    je .error

    ; ���� ��� �������, ������� ��������� �� ������
    invoke StdOut, successMessage
    invoke CloseHandle, eax ; ��������� ���������� �����
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

    ; ��������� ����
    invoke CreateFile, [fileName], GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov [hFile], eax

    ; ���������, ������� �� �����
    cmp eax, INVALID_HANDLE_VALUE
    je .fail

    ; �������� ������ �����
    invoke GetFileSize, [hFile], 0
    ; ��������� ���������� �����
    invoke CloseHandle, [hFile]
    ret

.fail:
    mov eax, INVALID_HANDLE_VALUE
    ret
endp
