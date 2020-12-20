MBOOT_HEADER_MAGIC  equ     0x1BADB002
MBOOT_PAGE_ALIGN    equ     1 << 0
MBOOT_MEM_INFO      equ     1 << 1
MBOOT_HEADER_FLAGS  equ     MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ     - (MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

STACK_SIZE          equ     32768       ; 定义栈的尺寸大小
 
GLOBAL start            ; 内核代码入口
GLOBAL glb_mboot_ptr    ; 向外部声明的struct multiboot*变量
EXTERN kern_entry       ; 主函数入口

[BITS 32]             ; 内核以32位形式编译

section .text         ; 代码段

align 4               ; 4字节对齐

Multi_boot_header:    ; 声明变量，只用`Multiboot Header`必须的那些部分
    dd MBOOT_HEADER_MAGIC
    dd MBOOT_HEADER_FLAGS
    dd MBOOT_CHECKSUM

start:                  ; 汇编的指令开始的地方，前面声明这个入口了
    cli            ; 此时还没有设置好保护模式的中断处理，所以必须关闭中断
    mov esp, stack+STACK_SIZE   ; 设置内核栈地址 
    mov ebp, 0                  ; 帧指针修改为 0
    mov [glb_mboot_ptr], ebx    ; 将 ebx 中存储的指针存入全局变量
    call kern_entry             ; 调用内核入口函数，也就是我我们的主函数

stop:
    hlt  
    jmp stop  

section .bss

glb_mboot_ptr: 
    resb 4

stack:
    resb STACK_SIZE