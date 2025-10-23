function KeyResponseMap = balancekeyresponsemap(Seriesnum)
% key-response mapping
if rem(Seriesnum, 2) == 1
    KeyResponseMap{1,1} = 'left = angry, right = happy';
elseif rem(Seriesnum, 2) == 0
    KeyResponseMap{1,1} = 'left = happy, right = angry'; % changed
end
end