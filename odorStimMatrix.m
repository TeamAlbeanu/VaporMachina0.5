%Accepts user input values for odor identity, and stimulus duration to
%build a stimulation matrix for the odor machine.

function odorStimMatrix(pureAirMs, stimDuration_1, stimDuration_2, stimDuration_3, stimDuration_4, odor_1, odor_2, odor_3, odor_4, mf_1, mf_2, mf_3, mf_4)

global manifold;

onOffPattern_1 = [1,0];
onOffPattern_2 = [1,0];
onOffPattern_3 = [1,0];
onOffPattern_4 = [1,0];

%Stimulus duration in ms
durationMs_1 = [stimDuration_1,1];
durationMs_2 = [stimDuration_2,1];
durationMs_3 = [stimDuration_3,1];
durationMs_4 = [stimDuration_4,1];

%Build stim matrix for odor machine
durationMs = odorMachineTrialConstructor(manifold(1).hexman, manifold(1).odorant(odor_1).vial,...
    onOffPattern_1, durationMs_1, manifold(2).hexman, manifold(2).odorant(odor_2).vial,...
    onOffPattern_2, durationMs_2, manifold(3).hexman, manifold(3).odorant(odor_3).vial,...
    onOffPattern_3, durationMs_3, manifold(4).hexman, manifold(4).odorant(odor_4).vial,...
    onOffPattern_4, durationMs_4, mf_1, mf_2, mf_3, mf_4, pureAirMs);
end