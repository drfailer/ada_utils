with System;
with System.Storage_Elements; use System.Storage_Elements;
with System.Storage_Pools; use System.Storage_Pools;
with Ada_Utils.Memory; use Ada_Utils.Memory;

package Ada_Utils.Memory.Arena_Allocators is

    --
    -- types
    --

    type Storage_Array is array (Storage_Offset range <>) of Storage_Element;

    type Arena (Size: Storage_Count) is new Root_Storage_Pool with record
        Buffer: Storage_Array (0 .. Size);
        Offset: Storage_Offset := 0;
        Last_Allocated_Address: System.Address;
    end record;

    --
    -- functions
    --

    function Allocate (A: in out Arena; Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address;
    function Resize (A: in out Arena; Old_Addr: System.Address; Old_Size: Storage_Count; New_Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address;
    procedure Free_All (A: in out Arena);

    --
    -- Storage pool API
    --

    overriding procedure Allocate(Pool: in out Arena; Storage_Address: out System.Address; Size_In_Storage_Elements: in Storage_Count; Alignment: in Storage_Count);
    overriding procedure Deallocate(Pool: in out Arena; Storage_Address: in System.Address; Size_In_Storage_Elements: in Storage_Count; Alignment: in Storage_Count);
    overriding function Storage_Size(Pool: Arena) return Storage_Count;

end Ada_Utils.Memory.Arena_Allocators;
