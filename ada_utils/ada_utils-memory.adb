with System;
with System.Storage_Elements; use System.Storage_Elements;

package body Ada_Utils.Memory is

    --
    -- functions
    --

    function Align_Forward (Addr: Integer_Address; Align: Integer_Address) return Integer_Address is
        Result_Addr: Integer_Address := Addr;
        Modulo: Integer_Address;
    begin
        pragma Assert ((Align and (Align - 1)) = 0, "Alignment must be a power of 2.");
        Modulo := Addr and (Align - 1);
        if Modulo /= 0 then
            Result_Addr := Addr + (Align - Modulo);
        end if;
        return Result_Addr;
    end Align_Forward;

    --
    -- allocator
    --

    function Allocate (A: Allocator; Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address is
        Old_Addr, Result_Addr: System.Address := To_Address (0);
    begin
        A.Proc (Alloc_Op_Allocate, A.Data, 0, Size, Align, Old_Addr, Result_Addr);
        return Result_Addr;
    end Allocate;

    procedure Free (A: Allocator; Addr: in out System.Address) is
        Result_Addr: System.Address :=To_Address (0);
    begin
        A.Proc (Alloc_Op_Free, A.Data, 0, 0, 0, Addr, Result_Addr);
    end Free;

    procedure Free_All (A: Allocator) is
        Dummy_Old_Addr, Dummy_Result_Addr: System.Address := To_Address (0);
    begin
        A.Proc (Alloc_Op_Free_All, A.Data, 0, 0, 0, Dummy_Old_Addr, Dummy_Result_Addr);
    end Free_All;

    function Resize (A: Allocator; Old_Addr: System.Address; Old_Size, New_Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address is
        Result_Addr: System.Address;
    begin
        A.Proc (Alloc_Op_Resize, A.Data, Old_Size, New_Size, Align, Old_Addr, Result_Addr);
        return Result_Addr;
    end Resize;

end Ada_Utils.Memory;
