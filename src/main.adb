with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Streams;
with Test_Streams;
with GNAT.Memory_Dump;
with System.Storage_Elements;


procedure Main is
   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
   use Ada.Streams;
   use System.Storage_Elements;

   procedure Put (Item : Stream_Element_Array) is
   begin
      for E of Item loop
         Put (Integer (E), 0);
         Put (" ");
      end loop;
   end Put;

   Data1 : Stream_Element_Array (1 .. 4) := (1, 2, 3, 4);
   Data2 : Stream_Element_Array (1 .. 2);
   O : Test_Streams.Overlay_Memory_Stream := Test_Streams.Create (Data1'Address, Data1'Length);
   Last : Stream_Element_Offset;
   K : Character;


begin

   loop
      Get_Immediate (K);
      exit when K = 'q';
      Read (Test_Streams.Stream (O).all, Data2, Last);
      --Integer'Write (Test_Streams.Stream (O), Integer'Value (K & ""));
      Put_Line ("Last " & Last'Img);
      Put (Data2);
      New_Line;
   end loop;


   null;
end;
