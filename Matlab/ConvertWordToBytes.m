function [HighByte LowByte] = ConvertWordToBytes_vector(Word)
% To make life easier and faster, return char, as opposed to uint8
if (Word>=0)&(Word<=65535)
    BinaryWord = dec2bin(Word,16);
    HighBinary = BinaryWord(:,1:8);
    LowBinary = BinaryWord(:,9:16);
    HighByte = uint8(bin2dec(HighBinary));
    LowByte = uint8(bin2dec(LowBinary));
    HighByte=char(HighByte);
    LowByte=char(LowByte);
else
    error('Input should be between zero and 65535')
end
