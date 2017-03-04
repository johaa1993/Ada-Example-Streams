with Ada.Assertions;
with System.Storage_Elements;

package body Test_Streams is

   function Create (Address : System.Address; Count : Ada.Streams.Stream_Element_Count) return Overlay_Memory_Stream is
   begin
      return (Ada.Streams.Root_Stream_Type with Address => Address, Count => Count, Index => 0);
   end Create;

   procedure Reset (Object : in out Overlay_Memory_Stream) is
   begin
      Object.Index := 0;
   end Reset;

   function Stream (Object : Overlay_Memory_Stream) return not null access Ada.Streams.Root_Stream_Type'Class is
   begin
      return Object'Unrestricted_Access;
   end Stream;

   overriding procedure Read (Object : in out Overlay_Memory_Stream; Item : out Ada.Streams.Stream_Element_Array; Last : out Ada.Streams.Stream_Element_Offset) is
      use Ada.Streams;
      use System.Storage_Elements;
      use type System.Storage_Elements.Storage_Offset;
      Rest : constant Stream_Element_Count := Object.Count - Object.Index;
      Count : constant Stream_Element_Count := Stream_Element_Count'Min (Item'Length, Rest);
      Source : Stream_Element_Array (1 .. Count);
      for Source'Address use Object.Address + Storage_Offset (Object.Index);
      subtype S is Stream_Element_Offset range Item'First .. Item'First + Count - 1;
   begin
      Item (S) := Source;
      Last := S'Last;
      Object.Index := Object.Index + S'Range_Length;
   end Read;

   overriding procedure Write (Object : in out Overlay_Memory_Stream; Item : Ada.Streams.Stream_Element_Array) is
      use System.Storage_Elements;
      use Ada.Streams;
      use type System.Storage_Elements.Storage_Offset;
      Target : Stream_Element_Array (1 .. Item'Length);
      for Target'Address use Object.Address + Storage_Offset (Object.Index);
   begin
      Object.Index := Object.Index + Item'Length;
      if Object.Index > Object.Count then
         raise Storage_Error with "This item is to large for this stream. Alternative this stream buffer is too small.";
      end if;
      Target := Item;
   end Write;



end Test_Streams;
