with Ada.Unchecked_Deallocation;

package body Ada_Utils.Containers.Dynamic_Arrays is
    procedure Free is new Ada.Unchecked_Deallocation (T_Array, T_Array_Access);

    --
    -- init & destroy
    --

    procedure Init (A: in out Dynamic_Array; Len: Natural := 0; Cap: Natural := DEFAULT_CAPACITY) is
    begin
        A.Cap  := Cap;
        A.Len  := Len;
        A.Data := new T_Array (0 .. Cap);
        if A.Data = null then
            raise Allocation_Error;
        end if;
    end Init;

    procedure Destroy (A: in out Dynamic_Array) is
    begin
        Free (A.Data);
        A.Len := 0;
        A.Cap := 0;
    end Destroy;

    --
    -- dynamic arrays operations
    --

    procedure Append (A: in out Dynamic_Array; Item: T) is
        New_Cap  : Natural;
        New_Data : T_Array_Access;
    begin
        if A.Len + 1 > A.Cap then
            New_Cap  := A.Cap * 2;
            New_Data := new T_Array (0 .. New_Cap);
            if A.Data = null then
                raise Allocation_Error;
            end if;

            New_Data (0 .. A.Cap) := A.Data.all;
            Free (A.Data);
            A.Data := New_Data;
            A.Cap  := New_Cap;
        end if;

        A.Data (A.Len) := Item;
        A.Len := A.Len + 1;
    end Append;

    function Pop (A: in out Dynamic_Array) return T is
    begin
        if A.Len = 0 then
            raise Constraint_Error with "tried to pop empty dynamic array";
        end if;
        A.Len := A.Len - 1;
        return A.Data (A.Len);
    end;

    --
    -- iterator
    --

    function Reference (A : aliased in out Dynamic_Array; Position : Cursor) return Element_Reference is
    begin
       return (Element => A.Data(Position.Idx)'Access);
    end Reference;

    function Iterate (A: Dynamic_Array) return Iterator_Interfaces.Forward_Iterator'Class is
    begin
        return (A);
    end Iterate;

    function Has_Element (Position: Cursor) return Boolean is
    begin
        return Position.Idx < Position.Len;
    end Has_Element;

    function First (A: Dynamic_Array) return Cursor is (Cursor'(0, A.Len));
    function Next (A: Dynamic_Array; Position: Cursor) return Cursor is (Cursor'(Position.Idx + 1, Position.Len));

    function Last (A: Dynamic_Array) return Cursor is (Cursor'(A.Len - 1, A.Len));
    function Previous (A: Dynamic_Array; Position: Cursor) return Cursor is (Cursor'(Position.Idx - 1, Position.Len));

end Ada_Utils.Containers.Dynamic_Arrays;
