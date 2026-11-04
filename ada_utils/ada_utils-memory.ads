with System.Storage_Elements; use System.Storage_Elements;

package Ada_Utils.Memory is

    --
    -- constants
    --

    DEFAULT_ALIGNMENT: constant Storage_Count := 8;

    --
    -- functions
    --

    function Align_Forward (Addr: Integer_Address; Align: Integer_Address) return Integer_Address;

end Ada_Utils.Memory;
