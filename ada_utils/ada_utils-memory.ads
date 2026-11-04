with System;
with System.Storage_Elements; use System.Storage_Elements;

package Ada_Utils.Memory is

    --
    -- constants
    --

    DEFAULT_ALIGNMENT: constant Storage_Count := 8;

    --
    -- allocator
    --

    type Allocator_Operation is (Alloc_Op_Allocate, Alloc_Op_Free, Alloc_Op_Free_All, Alloc_Op_Resize);
    type Allocator_Procedure is access procedure (Op: Allocator_Operation; Data: System.Address; Old_Size, New_Size, Align: Storage_Count; Old_Addr: System.Address; Result_Addr: in out System.Address);

    type Allocator is tagged record
        Data: System.Address;
        Proc: Allocator_Procedure;
    end record;

    function Allocate (A: Allocator; Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address;
    procedure Free (A: Allocator; Addr: in out System.Address);
    procedure Free_All (A: Allocator);
    function Resize (A: Allocator; Old_Addr: System.Address; Old_Size, New_Size: Storage_Count; Align: Storage_Count := DEFAULT_ALIGNMENT) return System.Address;

    --
    -- functions
    --

    function Align_Forward (Addr: Integer_Address; Align: Integer_Address) return Integer_Address;

end Ada_Utils.Memory;
