%Function written by Josh Sanders and modified by Gonzalo Otazu, 2011

function SetGBOSSParameters_fast(StimTimeMs,digital_out,mass_flow_1,mass_flow_2, mass_flow_3, mass_flow_4, stimulation_total_steps)

global Sergboss

try
    Sergboss = evalin('base', 'Sergboss');
catch
    error('Connection error. You must initialize the module first.');
end

fwrite(Sergboss, char(51)); %Send 51
[HighByte LowByte] = ConvertWordToBytes(stimulation_total_steps);
stimulation_total_stepsbyte=[char(LowByte) char(HighByte)];
fwrite(Sergboss, stimulation_total_stepsbyte); % Send the total number of steps that matlab will finally send

%Convert everything to char as vectors before sending them 
[HighByte_StimTimeMs LowByte_StimTimeMs] = ConvertWordToBytes_vector(StimTimeMs);
[LowByte_1_8 LowByte_9_16 LowByte_17_24 LowByte_25_32] = ConvertLongToBytes_vector(digital_out);
[HighByte_mass_flow_1 LowByte_mass_flow_1] = ConvertWordToBytes_vector_mf(mass_flow_1);
[HighByte_mass_flow_2 LowByte_mass_flow_2] = ConvertWordToBytes_vector_mf(mass_flow_2); 
[HighByte_mass_flow_3 LowByte_mass_flow_3] = ConvertWordToBytes_vector_mf(mass_flow_3);
[HighByte_mass_flow_4 LowByte_mass_flow_4] = ConvertWordToBytes_vector_mf(mass_flow_4);

complete_matrix=[HighByte_StimTimeMs, LowByte_StimTimeMs, ...
    LowByte_1_8, LowByte_9_16, LowByte_17_24, LowByte_25_32,...
    HighByte_mass_flow_1, LowByte_mass_flow_1,...
    HighByte_mass_flow_2, LowByte_mass_flow_2,...
    HighByte_mass_flow_3, LowByte_mass_flow_3,...
    HighByte_mass_flow_4, LowByte_mass_flow_4];
[a,b]=size(complete_matrix);

long_stream=reshape(complete_matrix',a*b,1);
fwrite(Sergboss,long_stream);

end
