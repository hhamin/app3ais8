function falls_data = get_falls()
    falls_data = [];
    falls = [...
        '3ITB1A'; ...
        '3ITB1B'; ...
        '3ITB1C'; ...
        '3ATF2A'; ...
        '3ATF2B'; ...
        '3ATF2C'; ...
        '3SVF3A'; ...
        '3SVF3B'; ...
        '3SVF3C';];    
    data = get_data_file(falls, 'Sujet_3');
    falls_data = [falls_data; data];
    
    falls = [...
        '5ITB1A'; ...
        '5ITB1B'; ...
        '5ITB1C'; ...
        '5ATF2A'; ...
        '5ATF2B'; ...
        '5ATF2C'; ...
        '5SVF3A'; ...
        '5SVF3B'; ...
        '5SVF3C';];
    data = get_data_file(falls, 'Sujet_5');
    falls_data = [falls_data; data];