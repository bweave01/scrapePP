function  ppData = parsePpBlocks(ppHtml)
%PARSEPPBLOCKS Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames(ppHtml);
nHorses = length(fields);
for iHorse = 1:nHorses
    thisHorse = fields{iHorse};
    data = ppHtml.(thisHorse);
    
    % Name
    expr = '<span[ ]+class="horseName"[ ]+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    name = tok{1}{:};
    
    % Owner
    expr = '<span[ ]+class="horseOwnerName"[ ]+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    owner = tok{1}{:};
    
    % Jockey
    expr = '<span[ ]+title="(\w* \w[ ]?\w?)([^"]+)"';
    tok = regexp(data,expr,'tokens');
    jockey.name = tok{1}{1};
    jockey.record = tok{1}{2};
    
    % Horse Personal Data
    expr = '<div[ ]+class="horsePersonalData"><span>';
    expr = [expr, '<span[ ]+class="color">([^<]+)</span>'];
    expr = [expr, '<span[ ]+class="runnerSex">([^<]+)</span>'];
    expr = [expr, '<span[ ]+class="runnerAge">([^<]+)</span>'];
    expr = [expr, '<span[ ]+class="birthMonth">([^<]+)</span>'];
    tok = regexp(data,expr,'tokens');
    
    color = tok{1}{1};
    switch color
        case 'B.'
            color = 'Bay';
        case 'Bl.'
            color = 'Black';
        case 'Br.'
            color = 'Brown';
        case 'Ch.'
            color = 'Chestnut';
        case 'Ro.'
            color = 'Roan';
        case 'Gr.'
            color = 'Gray';
        otherwise
    end
    horsePersonal.color = color;
    
    sex = tok{1}{2};
    switch sex
        case 'c.'
            sex = 'colt';
        case 'h.'    
            sex = 'horse (uncastrated male >5yr)';
        case 'g.'
            sex = 'gelding';
        case 'f.'
            sex = 'filly';
        case 'm.'
            sex = 'mare';
        otherwise
    end
    horsePersonal.sex = sex;       
    horsePersonal.age = tok{1}{3};
    horsePersonal.birthMonth = tok{1}{4};
    
    % Breeding Info
    expr = '"horseSireName"[ ]+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    breed.sire = tok{1}{1};
    
    expr = '"horseDamName"[ ]+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    breed.dam = tok{1}{1};
    
    expr = '"horseBreederName"><span[ ]+class="brName"[ ]+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    breed.breeder = tok{1}{1};
    
    % Medication
    expr = '"horseMedication">(\w)?</span>';
    tok = regexp(data,expr,'tokens');
    medication = tok{1}{1};
    
    % Weight
    expr = '"horseWeightValue">([0-9]+)</span>';
    tok = regexp(data,expr,'tokens');
    weight = tok{1}{1};
    
    % Trainer
    expr = '"horseTrainerStatsInner"><span class="label">Tr:</span>';
    expr = [expr, '<span class="" title="([ \w]+)([^"])+'];
    tok = regexp(data,expr,'tokens');
    trainer.name = tok{1}{1};
    trainer.record = tok{1}{2};
    
    
    ppData.(thisHorse).name = name;
    ppData.(thisHorse).owner = owner;
    ppData.(thisHorse).jockey = jockey;
    ppData.(thisHorse).horsePersonal = horsePersonal;
    ppData.(thisHorse).breed = breed;
    ppData.(thisHorse).medication = medication;
    ppData.(thisHorse).weight = weight;
    ppData.(thisHorse).trainer = trainer;
    


end

