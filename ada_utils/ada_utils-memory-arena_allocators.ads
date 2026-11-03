with System;
with System.Storage_Elements; use System.Storage_Elements;

package Ada_Utils.Memory.Arena_Allocators is

    --
    -- constants
    --

    DEFAULT_ALIGNMENT: constant Storage_Count := 8;

    --
    -- types
    --

    type Storage_Array is array (Storage_Offset range <>) of Storage_Element;

    type Arena (Size: Storage_Count) is tagged limited record
        Buffer: Storage_Array (0 .. Size);
        Offset: Storage_Offset := 0;
        Last_Allocated_Address: System.Address;
    end record;

    --
    -- functions
    --

    function Allocate (A: in out Arena; Size: Storage_Count; Align: Storage_Offset := DEFAULT_ALIGNMENT) return System.Address;
    function Resize (A: in out Arena; Old_Addr: System.Address; Old_Size: Storage_Count; New_Size: Storage_Count; Align: Storage_Offset := DEFAULT_ALIGNMENT) return System.Address;
    procedure Free_All (A: in out Arena);

end Ada_Utils.Memory.Arena_Allocators;
