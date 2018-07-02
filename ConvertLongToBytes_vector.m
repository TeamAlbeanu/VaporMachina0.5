function [MSByte Byte3 Byte2 LSByte] = ConvertLongToBytes_vector(Word)
if (Word>=0)&(Word<=(2^32-1))
BinaryWord = dec2bin(Word,32);

Binary_1_8 = BinaryWord(:,1:8);
Binary_9_16 = BinaryWord(:,9:16);
Binary_17_24 = BinaryWord(:,17:24);
Binary_25_32= BinaryWord(:,25:32);

MSByte = char(uint8(bin2dec(Binary_1_8)));
Byte3 = char(uint8(bin2dec(Binary_9_16)));
Byte2 = char(uint8(bin2dec(Binary_17_24)));
LSByte = char(uint8(bin2dec(Binary_25_32)));
else
    error('Input should be between zero and 2^32-1')
end