function [HighByte LowByte] = ConvertWordToBytes_vector(Word)
if (Word>=0)&(Word<=65535)
    ShiftedWord = bitshift(Word,4); %Odor machine DAC is MSBF
    BinaryWord = dec2bin(ShiftedWord,16);
    HighBinary = BinaryWord(:,1:8);
    LowBinary = BinaryWord(:,9:16);
    HighByte = char(uint8(bin2dec(HighBinary)));
    LowByte = char(uint8(bin2dec(LowBinary)));
else
    error('Input should be between zero and 65535')
end