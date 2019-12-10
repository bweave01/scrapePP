function  ppData = parsePpBlocks(ppHtml)
%PARSEPPBLOCKS Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames(ppHtml);
nHorses = length(fields);
for iHorse = 1:nHorses
    thisHorse = fields{iHorse};
    data = ppHtml.(thisHorse);
    
    % Name
    expr = '<span\s+class="horseName"\s+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    name = tok{1}{:};
    
    % Owner
    expr = '<span\s+class="horseOwnerName"\s+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    owner = tok{1}{:};
    
    % Jockey
    expr = '<span\s+title="(\w*\s\w\s?\w?)([^"]+)"';
    tok = regexp(data,expr,'tokens');
    jockey.name = tok{1}{1};
    jockey.record = tok{1}{2};
    
    % Horse Personal Data
    expr = '<div[ ]+class="horsePersonalData"><span>';
    expr = [expr, '<span\s+class="color">([^<]+)</span>'];
    expr = [expr, '<span\s+class="runnerSex">([^<]+)</span>'];
    expr = [expr, '<span\s+class="runnerAge">([^<]+)</span>'];
    expr = [expr, '<span\s+class="birthMonth">([^<]+)</span>'];
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
    expr = '"horseSireName"\s+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    breed.sire = tok{1}{1};
    
    expr = '"horseDamName"\s+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    breed.dam = tok{1}{1};
    
    expr = '"horseBreederName"><span\s+class="brName"\s+title="([^"]+)"';
    tok = regexp(data,expr,'tokens');
    breed.breeder = tok{1}{1};
    
    % Medication
    expr = '"horseMedication">(.?.?)</span>';
    tok = regexp(data,expr,'tokens');
    medication = tok{1}{1};
    if strcmp(medication,'÷')
        medication = 'L (bolded)';
    end
    
    % Weight
    expr = '"horseWeightValue">([0-9]+)</span>';
    tok = regexp(data,expr,'tokens');
    weight = tok{1}{1};
    
    % Trainer
    expr = '"horseTrainerStatsInner"><span\sclass="label">Tr:</span>';
    expr = [expr, '<span class="" title="([\s\w]+)([^"])+'];
    tok = regexp(data,expr,'tokens');
    trainer.name = tok{1}{1};
    trainer.record = tok{1}{2};
    
    % Record
    expr = '"tableCell\s+tableHead"><span>([\w\.\(\)\*])+</span>';
    tok = regexp(data,expr,'tokens');
    recordLabel = tok;
    if length(recordLabel) > 9
        recordLabel = recordLabel(1:9);
    end
    
    expr = 'horseRecordFigure"><span>([\d\w]?)</span>';
    tok = regexp(data,expr,'tokens');
    recordFigures = tok;
    if length(recordFigures) > 36
        recordFigures = recordFigures(1:36);
    end
    
    expr = 'horseRecordClaim"><span>(.[\d,]+)</span>';
    tok = regexp(data,expr,'tokens');
    recordClaims = tok;
    if length(recordClaims) > 9
        recordClaims = recordClaims(1:9);
    end
    
    expr = 'horseRecordBeyer\s"><span>([\d-]+)</span>';
    tok = regexp(data,expr,'tokens');
    recordBeyer = tok;
    if length(recordBeyer) > 9
        recordBeyer = recordBeyer(1:9);
    end
    
    nRecords = length(recordLabel);
    for iRecord = 1:nRecords
        record(iRecord,1) = recordLabel{iRecord};
        for iFigure = 1:4
        record(iRecord,1+iFigure) = recordFigures{4*(iRecord-1)+iFigure};
        end
        record(iRecord,6) = recordClaims{iRecord};
        record(iRecord,7) = recordBeyer{iRecord};
    end
    
    % Individual Past Performances
    expr = '<div\s+class="ppLinesMain\s+pull-left">';
    ppLinesStart = regexp(data,expr,'start');
    
    expr = '<div\s+class="worksNtrainer\s+clearfix">';
    ppLinesPotentialEnd = regexp(data,expr,'start');
    ppLinesEnd = min(ppLinesPotentialEnd);
    
    ppLines = parsePpLine(data(ppLinesStart:ppLinesEnd));
    
    
    ppData.(thisHorse).name = name;
    ppData.(thisHorse).owner = owner;
    ppData.(thisHorse).jockey = jockey;
    ppData.(thisHorse).horsePersonal = horsePersonal;
    ppData.(thisHorse).breed = breed;
    ppData.(thisHorse).medication = medication;
    ppData.(thisHorse).weight = weight;
    ppData.(thisHorse).trainer = trainer;
    ppData.(thisHorse).record = record;
    ppData.(thisHorse).ppLines = ppLines;
    
    clear record*
    


end

