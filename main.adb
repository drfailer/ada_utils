with Ada.Text_IO; use Ada.Text_IO;
with System;
with System.Storage_Pools;
with System.Storage_Elements; use System.Storage_Elements;
with Ada_Utils.Containers.Dynamic_Arrays; use Ada_Utils.Containers;
with Ada_Utils.Memory.Arena_Allocators; use Ada_Utils.Memory;

procedure Main is
    package Integer_Dynamic_Array is new Dynamic_Arrays (Integer);

    Arr: Integer_Dynamic_Array.Dynamic_Array;

    Arena: Arena_Allocators.Arena (1024);
    Addr: System.Address;

    type Integer_Access is access Integer with Storage_Pool => Arena;
    Pooled_Integer: Integer_Access;
begin
    --
    -- arena
    --
    Put_Line ("Arena base address: " & To_Integer (Arena.Buffer (0)'Address)'Img & ", Arena offset: " & Arena.Offset'Img);
    Addr := Arena.Allocate(Integer'Max_Size_In_Storage_Elements);
    Put_Line ("Allocated address 1: " & To_Integer (Addr)'Img & ", Arena offset: " & Arena.Offset'Img);
    Addr := Arena.Allocate(Integer'Max_Size_In_Storage_Elements);
    Put_Line ("Allocated address 2: " & To_Integer (Addr)'Img & ", Arena offset: " & Arena.Offset'Img);
    Addr := Arena.Resize(Addr, Integer'Max_Size_In_Storage_Elements, 2*Integer'Max_Size_In_Storage_Elements);
    Put_Line ("Allocated address 3: " & To_Integer (Addr)'Img & ", Arena offset: " & Arena.Offset'Img);

    Pooled_Integer := new Integer; -- allocate integer using the arena
    Put_Line ("Allocated int: " & To_Integer (Pooled_Integer'Address)'Img & ", Arena offset: " & Arena.Offset'Img);


    --
    -- dynamic array
    --
    Integer_Dynamic_Array.Init (Arr);
    Put_Line ("Length: " & Arr.Len'Img & ", Capacity: " & Arr.Cap'Img);
    Integer_Dynamic_Array.Append (Arr, 1);
    Integer_Dynamic_Array.Append (Arr, 2);
    Integer_Dynamic_Array.Append (Arr, 3);
    Integer_Dynamic_Array.Append (Arr, 4);
    Put_Line ("Length: " & Arr.Len'Img & ", Capacity: " & Arr.Cap'Img);

    for E of Arr loop
        Put_Line (E'Img);
    end loop;
    Integer_Dynamic_Array.Destroy (Arr);
end Main;
