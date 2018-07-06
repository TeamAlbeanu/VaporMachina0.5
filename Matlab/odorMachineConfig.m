function odorMachineConfig
%Arduino port map of odor machine to be used by stimulus matrix constructor
%Written by Michael Gross, modified by Devon Cowan

%All vials on the same manifold go to the same hex valve. Each manifold
%actually consists of a pair, on which mirrored valves are shorted to each
%other (so valves for fresh air into the vial, and odorized air out of the vial
%are opened/closed at the same time). 

global manifold;

%Bank 1
manifold(1).hexman=18; %Arduino pin for hex valves
manifold(1).odorant(1).name='Ethyl Valerate';
manifold(1).odorant(1).vial=26; %Arduino pin for vial
manifold(1).odorant(2).name='Empty M1-2';
manifold(1).odorant(2).vial=27;
manifold(1).odorant(3).name='Empty M1-3';
manifold(1).odorant(3).vial=28;
manifold(1).odorant(4).name='Empty M1-4';
manifold(1).odorant(4).vial=29;
manifold(1).odorant(9).vial=99; %To not open any valves on this bank

%Bank 2
manifold(2).hexman=19; %Arduino pin for hex valves
manifold(2).odorant(1).name='Empty M2-1';
manifold(2).odorant(1).vial=30; %Arduino pin for vial
manifold(2).odorant(2).name='Empty M2-2';
manifold(2).odorant(2).vial=31;
manifold(2).odorant(3).name='Empty M2-3';
manifold(2).odorant(3).vial=32;
manifold(2).odorant(4).name='Empty M2-4';
manifold(2).odorant(4).vial=33;
manifold(2).odorant(5).name='Empty M2-5';
manifold(2).odorant(5).vial=34;
manifold(2).odorant(6).name='Empty M2-6';
manifold(2).odorant(6).vial=35;
manifold(2).odorant(9).vial=99; %To not open any valves on this bank

%Bank 3
manifold(3).hexman=20; %Arduino pin for hex valves
manifold(3).odorant(1).name='Empty M3-1';
manifold(3).odorant(1).vial=36; %Arduino pin for vial
manifold(3).odorant(2).name='Empty M3-2';
manifold(3).odorant(2).vial=37;
manifold(3).odorant(3).name='Empty M3-3';
manifold(3).odorant(3).vial=38;
manifold(3).odorant(4).name='Empty M3-4';
manifold(3).odorant(4).vial=39;
manifold(3).odorant(5).name='Empty M3-5';
manifold(3).odorant(5).vial=40;
manifold(3).odorant(6).name='Empty M3-6';
manifold(3).odorant(6).vial=41;
manifold(3).odorant(9).vial=99; %To not open any valves on this bank

%Bank 4
manifold(4).hexman=21; %Arduino pin for hex valves
manifold(4).odorant(1).name='Empty M4-1';
manifold(4).odorant(1).vial=42; %Arduino pin for vial
manifold(4).odorant(2).name='Empty M4-2';
manifold(4).odorant(2).vial=43;
manifold(4).odorant(3).name='Empty M4-3';
manifold(4).odorant(3).vial=44;
manifold(4).odorant(4).name='Empty M4-4';
manifold(4).odorant(4).vial=45;
manifold(4).odorant(9).vial=99; %To not open any valves on this bank
end
