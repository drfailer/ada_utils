with System;
with System.Storage_Elements; use System.Storage_Elements;
with System.Address_To_Access_Conversions;

package body Ada_Utils.Memory.Arena_Allocators is

    --
    -- Functions
    --

    function Allocate (A: in out Arena; Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address is
        Base_Addr : Integer_Address := To_Integer (A.Buffer (A.Buffer'First)'Address);
        Curr_Addr : Integer_Address := To_Integer (A.Buffer (A.Offset)'Address);
        Addr      : Integer_Address := Align_Forward (Curr_Addr, Integer_Address (Align));
        Offset    : Storage_Offset := Storage_Offset (Addr - Base_Addr);
    begin
        if Offset+Size > A.Size then
            raise Storage_Error with "not enough space in arena to allocate";
        end if;
        A.Offset := Offset+Size;
        A.Last_Allocated_Address := To_Address (Addr);
        return To_Address (Addr);
    end Allocate;

    function Resize (A: in out Arena; Old_Addr: System.Address; Old_Size, New_Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address is
        Addr      : Integer_Address := To_Integer (Old_Addr);
        Last_Addr : Integer_Address := To_Integer (A.Last_Allocated_Address);
    begin
        if Addr = Last_Addr then
            Addr := Align_Forward (Addr, Integer_Address (Align)); -- realign if needed
            declare
                Base_Addr : Integer_Address := To_Integer (A.Buffer (A.Buffer'First)'Address);
                Offset    : Storage_Offset := Storage_Offset (Addr - Base_Addr);
            begin
                if Offset+New_Size > A.Size then
                    raise Storage_Error with "not enough space in arena to resize";
                end if;
                A.Offset := Offset+New_Size;
                A.Last_Allocated_Address := To_Address (Addr);
                return To_Address (Addr);
            end;
        end if;
        return Allocate (A, New_Size, Align);
    end;

    procedure Free_All (A: in out Arena) is
    begin
        A.Offset := 0;
        for Elt of A.Buffer loop
            Elt := 0;
        end loop;
    end Free_All;

    --
    -- Storage pool API
    --

    procedure Allocate(Pool: in out Arena; Storage_Address: out System.Address; Size_In_Storage_Elements: in Storage_Count; Alignment: in Storage_Count) is
    begin
        Storage_Address := Allocate(Pool, Size_In_Storage_Elements, Alignment);
    end Allocate;

    procedure Deallocate(Pool: in out Arena; Storage_Address: in System.Address; Size_In_Storage_Elements: in Storage_Count; Alignment: in Storage_Count) is
    begin
        null;
    end Deallocate;

    function Storage_Size(Pool: Arena) return Storage_Count is (Pool.Size);

    --
    -- Allocator API
    --

    procedure Allocator_Proc (Op: Allocator_Operation; Data: System.Address; Old_Size, New_Size, Align: Storage_Count; Old_Addr: System.Address; Result_Addr: in out System.Address) is
        package Arena_Ptr_Cast is new System.Address_To_Access_Conversions (Arena);
        A: Arena_Ptr_Cast.Object_Pointer := Arena_Ptr_Cast.To_Pointer (Data);
    begin
        case Op is
        when Alloc_Op_Allocate => Result_Addr := Allocate (A.all, New_Size, Align);
        when Alloc_Op_Free => null;
        when Alloc_Op_Free_All => Free_All (A.all);
        when Alloc_Op_Resize => Result_Addr := Resize (A.all, Old_Addr, Old_Size, New_Size, Align);
        end case;
    end Allocator_Proc;

    function Make_Allocator (A: in out Arena) return Allocator is (Allocator'(Data => A'Address, Proc => Allocator_Proc'Access));

end Ada_Utils.Memory.Arena_Allocators;
