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

end Ada_Utils.Memory;
