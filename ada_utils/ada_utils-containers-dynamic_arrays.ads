with Ada.Iterator_Interfaces;

generic
    type T is private;
package Ada_Utils.Containers.Dynamic_Arrays is

    --
    -- constants
    --

    DEFAULT_CAPACITY: constant Natural := 8;

    --
    -- exceptions
    --

    Allocation_Error: exception;

    --
    -- iterator
    --

    type Cursor is record
        Idx, Len: Natural;
    end record;
    function Has_Element (Position: Cursor) return Boolean;
    package Iterator_Interfaces is new Ada.Iterator_Interfaces (Cursor, Has_Element);

    --
    -- dynamic array
    --

    type T_Array is array (Natural range <>) of aliased T; -- IMPORTANT: if we want to reference T, we need to specify that it is aliased (otherwize, the compiler may do optimizations that could break the access)
    type T_Array_Access is access T_Array;

    -- create type element reference (make Element a discrimitant for encapsulation)
    type Element_Reference (Element : not null access T) is null record
        with Implicit_Dereference => Element;

    type Dynamic_Array is new Iterator_Interfaces.Forward_Iterator and Iterator_Interfaces.Reversible_Iterator with record
        Cap : Natural;
        Len : Natural;
        Data : T_Array_Access;
    end record
    with -- aspects
        Default_Iterator => Iterate,
        Iterator_Element => T,
        Variable_Indexing => Reference;

    -- init & destroy
    procedure Init (A: in out Dynamic_Array; Len: Natural := 0; Cap: Natural := DEFAULT_CAPACITY);
    procedure Destroy (A: in out Dynamic_Array);

    -- dynamic array operation
    procedure Append (A: in out Dynamic_Array; Item: T);
    function Pop (A: in out Dynamic_Array) return T;

    --
    -- iterator
    --

    -- indexation functions
    function Reference (A: aliased in out Dynamic_Array; Position: Cursor) return Element_Reference;
    function Iterate (A: Dynamic_Array) return Iterator_Interfaces.Forward_Iterator'Class;

    -- forward iterator
    overriding function First (A: Dynamic_Array) return Cursor;
    overriding function Next (A: Dynamic_Array; Position: Cursor) return Cursor;

    -- reverible iterator
    overriding function Last (A: Dynamic_Array) return Cursor;
    overriding function Previous (A: Dynamic_Array; Position: Cursor) return Cursor;

end Ada_Utils.Containers.Dynamic_Arrays;
