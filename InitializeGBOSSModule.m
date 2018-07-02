% Code written by Josh Sanders. Modified by Gonzalo Otazu, 2011

clc

if exist('Sergboss')
    fclose(Sergboss);
    delete(Sergboss);
    clear Sergboss
end
global Sergboss
disp('Searching for a valid GBOSS module. Please wait.')
Found = 0;

    disp(['Trying port COM5'])
    TestSer = serial('COM5', 'BaudRate', 115200, 'DataBits', 8, 'StopBits', 1, 'Timeout', 1);
    fopen(TestSer);
    pause(1);
    fprintf(TestSer, char(59)); % Unique code for the Gboss olfactory machine
    tic
    while TestSer.BytesAvailable == 0
        fwrite(TestSer, char(59));
        if toc > 1
            break
        end
    end
    g = 0;
    try
    g = fread(TestSer, 1);
    catch
        % ok
    end
    if g ~= 0
        Found = 1;
    end
    fclose(TestSer);
    delete(TestSer)
    clear TestSer
    
if Found ~= 0
    Sergboss = serial('COM5', 'BaudRate', 115200, 'DataBits', 8, 'StopBits', 1, 'Timeout', 1);
else
    error('Could not find a valid BOSS Module');
end

set(Sergboss, 'OutputBufferSize', 8000);
set(Sergboss, 'InputBufferSize', 8000);
fopen(Sergboss);

disp(['Success! BOSS Module is ready on port COM5'])
clear Found g serialInfo