with Ada.Streams;
with Ada.Streams.Stream_IO;
with System;

package Test_Streams is

   pragma Preelaborate;

   use type Ada.Streams.Stream_Element_Offset;

   pragma Compile_Time_Error (Standard'Storage_Unit /= Ada.Streams.Stream_Element'Size, "this is not 8-bit machine.");

   type Overlay_Memory_Stream (<>) is limited private;

   function Create (Address : System.Address; Count : Ada.Streams.Stream_Element_Count) return Overlay_Memory_Stream;

   procedure Reset (Object : in out Overlay_Memory_Stream);

   function Stream (Object : aliased Overlay_Memory_Stream) return not null access Ada.Streams.Root_Stream_Type'Class;
   pragma Inline (Stream);

   --  Note: Write propagates Storage_Error if overflow.

private

   type Overlay_Memory_Stream is limited new Ada.Streams.Root_Stream_Type with record
      Address : System.Address;
      Count : Ada.Streams.Stream_Element_Count;
      Index : Ada.Streams.Stream_Element_Offset;
   end record;

   overriding procedure Read (Object : in out Overlay_Memory_Stream; Item : out Ada.Streams.Stream_Element_Array; Last : out Ada.Streams.Stream_Element_Offset);
   overriding procedure Write (Object : in out Overlay_Memory_Stream; Item : Ada.Streams.Stream_Element_Array) with
     Pre => True or Item'Length <= Object.Count - Object.Index;


end Test_Streams;
