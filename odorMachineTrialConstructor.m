function duration_ms=odorMachineTrialConstructor(arduino_hexman_1,arduino_odor_vial_1,binary_string_1,durations_ms_1,...
                                                 arduino_hexman_2,arduino_odor_vial_2,binary_string_2,durations_ms_2,...   
                                                 arduino_hexman_3,arduino_odor_vial_3,binary_string_3,durations_ms_3,... 
                                                 arduino_hexman_4,arduino_odor_vial_4,binary_string_4,durations_ms_4,... 
                                                 mf_1,mf_2,mf_3,mf_4,initial_pure_air_ms)
% Write a pulse of on-off-on-off on a valve

hexclick_1=2^(arduino_hexman_1-18);
if arduino_odor_vial_1==99 % 99 is the code for not opening the odor vial
    odor_vial_open_1=0;
else
    odor_vial_open_1=2^(arduino_odor_vial_1-18);
end
absolute_time_ms_1 = [0,cumsum(durations_ms_1)];


hexclick_2=2^(arduino_hexman_2-18);
if arduino_odor_vial_2==99
    odor_vial_open_2=0;
else
    odor_vial_open_2=2^(arduino_odor_vial_2-18);
end
absolute_time_ms_2 = [0,cumsum(durations_ms_2)];

hexclick_3=2^(arduino_hexman_3-18);
if arduino_odor_vial_3==99
    odor_vial_open_3=0;
else
    odor_vial_open_3=2^(arduino_odor_vial_3-18);
end
absolute_time_ms_3 = [0,cumsum(durations_ms_3)];

hexclick_4=2^(arduino_hexman_4-18);
if arduino_odor_vial_4==99
    odor_vial_open_4=0;
else
    odor_vial_open_4=2^(arduino_odor_vial_4-18);
end
absolute_time_ms_4 = [0,cumsum(durations_ms_4)];


% Create the union of both times
union_absolute_times_ms_1_2=union(absolute_time_ms_1 , absolute_time_ms_2);
union_absolute_times_ms_2_3=union(union_absolute_times_ms_1_2 , absolute_time_ms_3);
union_absolute_times_ms=union(union_absolute_times_ms_2_3 , absolute_time_ms_4);
union_delta_t_ms=diff(union_absolute_times_ms);

%create the corresponding valve opening file
digital_out = zeros(1,length(union_delta_t_ms));

for k=2:length(union_absolute_times_ms)
        start_interval=union_absolute_times_ms(k-1);
        end_interval=union_absolute_times_ms(k);
    for kk=2:length(absolute_time_ms_1)
        start_interval_big=absolute_time_ms_1(kk-1);
        end_interval_big=absolute_time_ms_1(kk);
        do_interval_intersect = ~((end_interval_big<=start_interval)|(start_interval_big>=end_interval));
        if  do_interval_intersect
            digital_out(k-1) = digital_out(k-1)+hexclick_1*binary_string_1(kk-1);
        end
    end
end

for k=2:length(union_absolute_times_ms)
        start_interval=union_absolute_times_ms(k-1);
        end_interval=union_absolute_times_ms(k);
    for kk=2:length(absolute_time_ms_2)
        start_interval_big=absolute_time_ms_2(kk-1);
        end_interval_big=absolute_time_ms_2(kk);
         do_interval_intersect = ~((end_interval_big<=start_interval)|(start_interval_big>=end_interval));
        if  do_interval_intersect
            digital_out(k-1) = digital_out(k-1)+hexclick_2*binary_string_2(kk-1);
        end
    end
end

for k=2:length(union_absolute_times_ms)
        start_interval=union_absolute_times_ms(k-1);
        end_interval=union_absolute_times_ms(k);
    for kk=2:length(absolute_time_ms_3)
        start_interval_big=absolute_time_ms_3(kk-1);
        end_interval_big=absolute_time_ms_3(kk);
         do_interval_intersect = ~((end_interval_big<=start_interval)|(start_interval_big>=end_interval));
        if  do_interval_intersect
            digital_out(k-1) = digital_out(k-1)+hexclick_3*binary_string_3(kk-1);
        end
    end
end

for k=2:length(union_absolute_times_ms)
        start_interval=union_absolute_times_ms(k-1);
        end_interval=union_absolute_times_ms(k);
    for kk=2:length(absolute_time_ms_4)
        start_interval_big=absolute_time_ms_4(kk-1);
        end_interval_big=absolute_time_ms_4(kk);
         do_interval_intersect = ~((end_interval_big<=start_interval)|(start_interval_big>=end_interval));
        if  do_interval_intersect
            digital_out(k-1) = digital_out(k-1)+hexclick_4*binary_string_4(kk-1);
        end
    end
end

if digital_out(end)==0 % Normal case, the last pulse is a zero, no reason to keep the odor vials open
    digital_out(1:(end-1))= digital_out(1:(end-1))+odor_vial_open_1+odor_vial_open_2+odor_vial_open_3+odor_vial_open_4;
    digital_out=[odor_vial_open_1+odor_vial_open_2+odor_vial_open_3+odor_vial_open_4,digital_out,0];
    mass_flow_1=[ones(1,length(digital_out)-2),0,0]*mf_1;
    mass_flow_2=[ones(1,length(digital_out)-2),0,0]*mf_2;
    mass_flow_3=[ones(1,length(digital_out)-2),0,0]*mf_3;
    mass_flow_4=[ones(1,length(digital_out)-2),0,0]*mf_4;
    StimTimeMs=[initial_pure_air_ms,union_delta_t_ms,1]; % Initial period of pure air into the animal, this should be the trials start signal, also more important 5 seconds to clean the pipes
    SetGBOSSParameters_fast(StimTimeMs,digital_out,mass_flow_1,mass_flow_2, mass_flow_3, mass_flow_4, length(digital_out));
    duration_ms=sum(StimTimeMs);
else
    digital_out= digital_out+odor_vial_open_1+odor_vial_open_2+odor_vial_open_3+odor_vial_open_4;
    digital_out=[odor_vial_open_1+odor_vial_open_2+odor_vial_open_3+odor_vial_open_4,digital_out,0];
    mass_flow_1=[ones(1,length(digital_out)-1),0]*mf_1;
    mass_flow_2=[ones(1,length(digital_out)-1),0]*mf_2;
    mass_flow_3=[ones(1,length(digital_out)-1),0]*mf_3;
    mass_flow_4=[ones(1,length(digital_out)-1),0]*mf_4;
    StimTimeMs=[initial_pure_air_ms,union_delta_t_ms,1]; % Initial period of pure air into the animal, this should be the trials start signal, also more important 5 seconds to clean the pipes
    SetGBOSSParameters_fast(StimTimeMs,digital_out,mass_flow_1,mass_flow_2, mass_flow_3, mass_flow_4, length(digital_out));
    duration_ms=sum(StimTimeMs);
end


